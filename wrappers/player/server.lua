vx.player = {}

---@param source number|string
---@param keepPrefix? boolean
function vx.player.getIdentifierFromSource(source, keepPrefix)
   local identifierType = vx.config.primaryIdentifier or "license"
   local identifier = GetPlayerIdentifierByType(tostring(source), identifierType)
   if not keepPrefix then
      identifier = identifier:gsub("license:", "")
   end

   return identifier
end

---------------
-- getFromId --
---------------

VxPlayer = {}
VxPlayer.__index = VxPlayer

function VxPlayer:new(source)
   local player = setmetatable({}, self)
   local getFrameworkPlayer = vx.caller.createFrameworkCaller({
      ["ESX"] = function()
         return ESX.GetPlayerFromId(source)
      end,
      ["QB"] = function()
         return QBCore.Functions.GetPlayer(source)
      end
   })

   player.frameworkPlayer = getFrameworkPlayer()
   return player
end

---@param account AccountType
---@param amount number
---@param reason? string
function VxPlayer:addAccountMoney(account, amount, reason)
   local caller = vx.caller.createFrameworkCaller({
      ["ESX"] = function()
         ---@type ExtendedPlayer
         local xPlayer = self.frameworkPlayer
         xPlayer.addAccountMoney(account, amount, reason or "")
      end,
      ["QB"] = function()
         local player = self.frameworkPlayer
         local moneyType = account == "money" and "cash" or "bank"
         player.Functions.AddMoney(moneyType, amount, reason or "")
      end
   })

   caller()
end

---@param name string
---@param grade? number
function VxPlayer:setJob(name, grade)
   local caller = vx.caller.createFrameworkCaller({
      ["ESX"] = function()
         ---@type ExtendedPlayer
         local xPlayer = ESX.GetPlayerFromId(source)
         xPlayer.setJob(name, grade or 0)
      end,
      ["QB"] = function()
         local player = QBCore.Functions.GetPlayer(source)
         player.Functions.SetJob(name, grade or 0)
      end
   })

   caller()
end

-- TODO: Add support for QB
function VxPlayer:getJob()
   local caller = vx.caller.createFrameworkCaller({
      ["ESX"] = function()
         ---@type ExtendedPlayer
         local xPlayer = ESX.GetPlayerFromId(source)
         return xPlayer.getJob()
      end,
      ["QB"] = function()
         local player = QBCore.Functions.GetPlayer(source)
         return player.PlayerData.job.name
      end
   })

   caller()
end

function vx.player.getFromId(source)
   local player = VxPlayer:new(source)
   return player
end

return vx.player
