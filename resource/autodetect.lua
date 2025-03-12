vx_autoDetect = {}

local resources = {
   ["framework"] = {
      "es_extended",
      "qb-core"
   },
   ["inventory"] = {
      "ox_inventory",
      "qb-inventory"
   },
   ["target"] = {
      "ox_target",
      "qb-target",
      "qtarget",
   }
}

local convars = {
   ["framework"] = GetConvar("vx:framework", "auto"),
   ["inventory"] = GetConvar("vx:inventory", "auto"),
   ["target"] = GetConvar("vx:target", "auto")
}

local function isResourceStarted(name)
   return GetResourceState(name) == "started"
end

---@param type "framework"|"inventory"|"target"
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

print(("^2[INFO] ^7Detected framework: %s"):format(framework))
print(("^2[INFO] ^7Detected inventory: %s"):format(inventory))
print(("^2[INFO] ^7Detected target: %s"):format(target))

---@return Framework
function vx_autoDetect.getFramework()
   ---@cast framework Framework
   return framework
end
