cfx.player = {}

---@param source number|string
---@param keepPrefix? boolean
function cfx.player.getIdentifierFromSource(source, keepPrefix)
   local identifierType = cfx.config.primaryIdentifier or "license"
   local identifier = GetPlayerIdentifierByType(tostring(source), identifierType)
   if not keepPrefix then
      identifier = identifier:gsub("license:", "")
   end

   return identifier
end

---------------
-- getFromId --
---------------

Player = {}
Player.__index = Player

function Player:new(source)
   local player = setmetatable({}, self)
   local getFrameworkPlayer = cfx.caller.createFrameworkCaller({
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
function Player:addAccountMoney(account, amount, reason)
   local caller = cfx.caller.createFrameworkCaller({
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
function Player:setJob(name, grade)
   local caller = cfx.caller.createFrameworkCaller({
      ["ESX"] = function()
         ---@type ExtendedPlayer
         local xPlayer = self.frameworkPlayer
         xPlayer.setJob(name, grade or 0)
      end,
      ["QB"] = function()
         local player = self.frameworkPlayer
         player.Functions.SetJob(name, grade or 0)
      end
   })

   caller()
end

function cfx.player.getFromId(source)
   local player = Player:new(source)
   return player
end

return cfx.player
