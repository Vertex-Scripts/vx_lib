local resourceName = GetCurrentResourceName()
local context = IsDuplicityVersion() and "server" or "client"
local export = exports["vx_lib"]

local function loadResourceFile(root, module)
   local dir = ("%s/%s"):format(root, module)
   local chunk = LoadResourceFile("vx_lib", ("%s/%s.lua"):format(dir, context))
   local shared = LoadResourceFile("vx_lib", ("%s/shared.lua"):format(dir))

   return root, chunk, shared
end


local function loadModule(self, module)
   local dir, chunk, shared = loadResourceFile("modules", module)
   if not chunk and not shared then
      dir, chunk, shared = loadResourceFile("wrappers", module)
   end

   if shared then
      chunk = (chunk and ("%s\n%s"):format(shared, chunk)) or shared
   end

   if chunk then
      local fn, err = load(chunk, ("@@vx_lib/%s/%s/%s.lua"):format(dir, module, context))
      if not fn or err then
         return error(("Failed to load module %s: %s"):format(module, err))
      end

      local result = fn()
      self[module] = result

      return self[module]
   end
end

local function call(self, index, ...)
   local module = rawget(self, index)
   if not module then
      self[index] = noop
      module = loadModule(self, index)

      if not module then
         local function method(...)
            return export[index](nil, ...)
         end

         if not ... then
            self[index] = method
         end

         return method
      end
   end

   return module
end

-- TODO: Cache and fix the config :)
local vx = setmetatable({
   name = "vx_lib",
   ---@type SharedConfig
   config = export:getConfig(),
   cache = {
      resource = resourceName
   },
}, {
   __index = call,
   __call = call
})

print(json.encode(vx))
_ENV.vx = vx
require = vx.require
