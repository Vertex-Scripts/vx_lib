vx_autoDetect = {}

local resources = {
   ["framework"] = {
      "es_extended",
      "qb-core"
   },
   ["inventory"] = {
      "ox_inventory",
      "qb-inventory",
      "es_extended"
   },
   ["target"] = {
      "ox_target",
      "qb-target",
      "qtarget",
   },
   ["notify"] = {
      "ox_lib",
      "es_extended",
      "qb-core"
   },
   ["textui"] = {
      "ox_lib",
      "es_extended",
      "qb-core",
      "auto"
   }
}

local convars = {
   ["framework"] = GetConvar("vx:framework", "auto"),
   ["inventory"] = GetConvar("vx:inventory", "auto"),
   ["target"] = GetConvar("vx:target", "auto"),
   ["notify"] = GetConvar("vx:notify", "auto"),
   ["textui"] = GetConvar("vx:textui", "auto")
}

local function isResourceStarted(name)
   return GetResourceState(name) == "started"
end

---@param type "framework"|"inventory"|"target"|"notify"|"textui"
local function getResource(type)
   local convar = convars[type]
   if convar ~= "auto" then
      if isResourceStarted(convar) then
         return convar
      end

      print(("^3[WARN] ^7Configured %s '%s' is not started, falling back to detection."):format(type, convar))
   end

   local map = resources[type]
   for _, resource in pairs(map) do
      if isResourceStarted(resource) then
         return resource
      end
   end

   print(("^3[WARN] ^7Failed to find a running %s resource"):format(type))
   return nil
end

local framework = getResource("framework")
local inventory = getResource("inventory")
local target = getResource("target")
local notify = getResource("notify")
local textui = getResource("textui")

print(("^2[INFO] ^7Detected framework: %s"):format(framework))
print(("^2[INFO] ^7Detected inventory: %s"):format(inventory))
print(("^2[INFO] ^7Detected target: %s"):format(target))
print(("^2[INFO] ^7Detected notify: %s"):format(notify))
print(("^2[INFO] ^7Detected textui: %s"):format(textui))

function vx_autoDetect.getFramework()
   ---@cast framework Framework
   return framework
end

function vx_autoDetect.getTarget()
   ---@cast target Target
   return target
end

function vx_autoDetect.getInventory()
   ---@cast inventory Inventory
   return inventory
end

function vx_autoDetect.getNotify()
   ---@cast notify Notify
   return notify
end

function vx_autoDetect.getTextUi()
   ---@cast textui TextUISystem
   return textui
end

function vx_autoDetect.loadFramework()
   local context = IsDuplicityVersion() and "server" or "client"
   if framework == "es_extended" then
      _ENV.ESX = exports[framework]:getSharedObject()
   elseif framework == "qb-core" then
      _ENV.QBCore = exports[framework]:GetCoreObject()
      RegisterNetEvent(("QBCore:%s:UpdateObject"):format(context), function()
         _ENV.QBCore = exports[framework]:GetCoreObject()
      end)
   end
end
