local primaryIdentifier = GetConvar("vx:primaryIdentifier", "license")

vx.player = {}

---@param source number|string
---@param keepPrefix? boolean
---@param forcedType? string
---@deprecated
function vx.player.getIdentifierFromSource(source, keepPrefix, forcedType)
   local identifierType = forcedType or primaryIdentifier or "license"
   local identifier = GetPlayerIdentifierByType(tostring(source), identifierType)
   if not keepPrefix then
      identifier = identifier:gsub(identifierType .. ":", "")
   end

   return identifier
end

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
   player.source = source

   return player
end

---@param keepPrefix? boolean
---@param type? IdentifierType
function VxPlayer:getIdentifier(keepPrefix, type)
   local identifierType = type or primaryIdentifier or "license"
   local identifier = GetPlayerIdentifierByType(tostring(this.source), identifierType)
   if not keepPrefix then
      identifier = identifier:gsub(identifierType .. ":", "")
   end

   return identifier
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

-- TODO: Implement for QB
---@param account AccountType
---@param amount number
---@param reason? string
function VxPlayer:removeAccountMoney(account, amount, reason)
   local caller = vx.caller.createFrameworkCaller({
      ["ESX"] = function()
         ---@type ExtendedPlayer
         local xPlayer = self.frameworkPlayer
         xPlayer.removeAccountMoney(account, amount, reason or "")
      end,
      -- ["QB"] = function()
      --    local player = self.frameworkPlayer
      --    local moneyType = account == "money" and "cash" or "bank"
      --    player.Functions.AddMoney(moneyType, amount, reason or "")
      -- end
   })

   caller()
end

-- TODO: Implement for QB
---@param account AccountType
function VxPlayer:getAccountMoney(account)
   local caller = vx.caller.createFrameworkCaller({
      ["ESX"] = function()
         ---@type ExtendedPlayer
         local xPlayer = self.frameworkPlayer
         return xPlayer.getAccount(account)?.money or 0
      end,
      -- ["QB"] = function()
      --    local player = QBCore.Functions.GetPlayer(source)
      --    return player.PlayerData.job.name
      -- end
   })

   return caller()
end

---@param name string
---@param grade? number
function VxPlayer:setJob(name, grade)
   local caller = vx.caller.createFrameworkCaller({
      ["ESX"] = function()
         ---@type ExtendedPlayer
         local xPlayer = self.frameworkPlayer
         xPlayer.setJob(name, tostring(grade) or "0")
      end,
      ["QB"] = function()
         local player = QBCore.Functions.GetPlayer(source)
         player.Functions.SetJob(name, grade or 0)
      end
   })

   caller()
end

-- TODO: Test if it works for QB
function VxPlayer:getJob()
   local caller = vx.caller.createFrameworkCaller({
      ["ESX"] = function()
         ---@type ExtendedPlayer
         local xPlayer = self.frameworkPlayer
         return xPlayer.job.name
      end,
      ["QB"] = function()
         local player = QBCore.Functions.GetPlayer(source)
         return player.PlayerData.job.name
      end
   })

   return caller()
end

-- TODO: Implement for QB
function VxPlayer:getGroup()
   local caller = vx.caller.createFrameworkCaller({
      ["ESX"] = function()
         ---@type ExtendedPlayer
         local xPlayer = self.frameworkPlayer
         return xPlayer.getGroup()
      end,
      -- ["QB"] = function()
      --    local player = QBCore.Functions.GetPlayer(source)
      --    return player.PlayerData.group
      -- end
   })

   return caller()
end

function vx.player.getFromId(source)
   local player = VxPlayer:new(source)
   return player
end

return vx.player
