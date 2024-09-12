local context = IsDuplicityVersion() and "server" or "client"

local function loadResourceFile(root, module)
   local dir = ("%s/%s"):format(root, module)

   local chunk = LoadResourceFile("vx_lib", ("%s/%s.lua"):format(dir, context))
   local shared = LoadResourceFile("vx_lib", ("%s/shared.lua"):format(dir))

   return root, chunk, shared
end

function vx_loadModule(self, module)
   local dir, chunk, shared = loadResourceFile("modules", module)
   if not chunk and not shared then
      dir, chunk, shared = loadResourceFile("bridge", module)
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
