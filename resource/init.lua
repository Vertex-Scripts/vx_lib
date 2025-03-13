if not LoadResourceFile("vx_lib", "web/dist/index.html") then
   error(
      "Failed to load UI, build vx_lib or download the latest release. (https://github.com/Vertex-Scripts/vx_lib)")
end

local context = IsDuplicityVersion() and "server" or "client"
local currentResourceName = GetCurrentResourceName()

---@type VxCache
---@diagnostic disable-next-line: missing-fields
local cache = {
   resource = currentResourceName
}

local function proxyExports(self, key, fn)
   rawset(self, key, fn)

   if debug.getinfo(2, 'S').short_src:find('@vx_lib/resource') then
      exports(key, fn)
   end
end

vx = setmetatable({
   context = context,
   cache = cache,
   serverConfig = ServerConfig,
   sharedConfig = SharedConfig
}, {
   __index = vx_loadModule,
   __newindex = proxyExports,
})

vx.frameworkResource = vx_autoDetect.getFramework()
vx.targetResource = vx_autoDetect.getTarget()
vx.inventoryResource = vx_autoDetect.getInventory()

if GetResourceState("ox_lib") ~= "missing" then
   local oxInit = LoadResourceFile("ox_lib", "init.lua")
   local loadOx, err = load(oxInit)
   if not loadOx or err then
      vx.print.error(("Failed to load ox_lib (%s)"):format(err))
   else
      loadOx()
      if context == "server" then
         vx.print.info("Successfully loaded ox_lib")
      end
   end
end

function vx.getFramework() return vx.frameworkResource end

function vx.getTarget() return vx.targetResource end

function vx.getServerConfig() return ServerConfig end

function vx.getSharedConfig() return SharedConfig end

function vx.getInventory() return vx_autoDetect.getInventory() end

vx_autoDetect.loadFramework()
