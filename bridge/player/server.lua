vx.player = {}

local primaryIdentifier = GetConvar("vx:primaryIdentifier", "license")

---@class VxPlayer : VxClass
VxPlayer = vx.class("VxPlayer")

local function transformAccountType(type)
   if QBCore and type == "money" then
      return "cash"
   end

   if ESX and type == "cash" then
      return "money"
   end

   return type
end

local function getJob(self, type)
   type = type or "job"

   if ESX then
      return {
         name = self.fp.job.name,
         label = self.fp.job.label,
         grade = self.fp.job.grade,
         gradeLabel = self.fp.job.grade_label
      }
   elseif QBCore then
      return {
         name = self.fp.PlayerData[type].name,
         label = self.fp.PlayerData[type].label,
         grade = self.fp.PlayerData[type].grade.level,
         gradeLabel = self.fp.PlayerData[type].grade.name
      }
   end
end

function VxPlayer:constructor(source)
   local frameworkPlayer = ESX and ESX.GetPlayerFromId(source) or QBCore and QBCore.Functions.GetPlayer(source)
   ---@cast frameworkPlayer table

   self.source = source
   self.fp = frameworkPlayer
end

function VxPlayer:getIdentifier()
   return vx.player.getIdentifier(self.source)
end

function VxPlayer:getFirstName()
   if ESX then
      return string.match(self.fp.getName(), "%S+")
   elseif QBCore then
      return self.fp.PlayerData.charinfo.firstname
   end
end

function VxPlayer:getLastName()
   if ESX then
      return string.match(self.fp.getName(), "%s(.+)")
   elseif QBCore then
      return self.fp.PlayerData.charinfo.lastname
   end
end

function VxPlayer:getFullName()
   if ESX then
      return self.fp.getName()
   elseif QBCore then
      return string.format("%s %s", self:getFirstName(), self:getLastName())
   end
end

---@param job string
---@param grade number
function VxPlayer:setJob(job, grade)
   if ESX then
      self.fp.setJob(job, grade)           -- TODO: Test
   elseif QBCore then
      self.fp.Functions.SetJob(job, grade) -- TODO: Test
   end
end

function VxPlayer:getJob()
   return getJob(self)
end

function VxPlayer:getGroup()
   return ESX and self.fp.getGroup() or QBCore and QBCore.Functions.GetPermission(self.source)
end

---@param amount number
---@param type AccountType|string
function VxPlayer:giveMoney(amount, type)
   type = transformAccountType(type)

   if ESX then
      self.fp.addAccountMoney(type, amount)
   elseif QBCore then
      self.fp.Functions.AddMoney(type, amount)
   end
end

---@param amount number
---@param type AccountType|string
function VxPlayer:removeMoney(amount, type)
   type = transformAccountType(type)

   if ESX then
      self.fp.removeAccountMoney(type, amount)
   elseif QBCore then
      self.fp.Functions.RemoveMoney(type, amount)
   end
end

---@param type AccountType|string
function VxPlayer:getMoney(type)
   type = transformAccountType(type)
   return ESX and self.fp.getAccount(type).money or QBCore
       and self.fp.Functions.GetMoney(type)
end

-- Backwards compatibility

function VxPlayer:removeAccountMoney(type, amount, _)
   vx.print.warn(
      "Deprecated: Use vxPlayer:removeMoney instead of vxPlayer:removeAccountMoney (will be removed in the future)")

   self:removeMoney(amount, type)
end

function VxPlayer:addAccountMoney(type, amount, _)
   vx.print.warn(
      "Deprecated: Use vxPlayer:addMoney instead of vxPlayer:addAccountMoney (will be removed in the future)")

   self:giveMoney(amount, type)
end

function VxPlayer:getAccountMoney(type)
   vx.print.warn(
      "Deprecated: Use vxPlayer:getMoney instead of vxPlayer:getAccountMoney (will be removed in the future)")

   return self:getMoney(type)
end

---@param item string
---@param count? number
function VxPlayer:addItem(item, count)
   vx.inventory.addItem(self.source, item, count)
end

---@param item string
---@param count? number
function VxPlayer:removeItem(item, count)
   vx.inventory.removeItem(self.source, item, count)
end

---@param item string
function VxPlayer:getItemCount(item)
   return vx.inventory.getItemCount(self.source, item)
end

---@param item string
function VxPlayer:hasItem(item, count)
   return vx.inventory.hasItem(self.source, item, count)
end

function VxPlayer:getGang()
   return getJob(self, "gang")
end

---@param options NotificationOptions
function VxPlayer:notify(options)
   vx.notify(self.source, options)
end

---@param source number
function vx.player.getFromId(source)
   return VxPlayer:new(source)
end

---@param source number|string
---@param keepPrefix? boolean
---@param forcedType? string
function vx.player.getIdentifier(source, keepPrefix, forcedType)
   local identifierType = forcedType or primaryIdentifier or "license"
   local identifier = GetPlayerIdentifierByType(tostring(source), identifierType)
   if identifier and not keepPrefix then
      identifier = identifier:gsub(identifierType .. ":", "")
   end

   return identifier
end

---@param identifier string
---@param type? IdentifierType Defaults to license
function vx.player.getPlayerIdFromIdentifier(identifier, type)
   local players = GetPlayers()
   for _, playerId in pairs(players) do
      local targetIdentifier = vx.player.getIdentifier(playerId, false, type)
      if targetIdentifier == identifier then
         return playerId
      end
   end

   return nil
end

return vx.player
