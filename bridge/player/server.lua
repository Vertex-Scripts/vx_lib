vx.player = {}

---@class VxPlayer : VxClass
VxPlayer = vx.class("VxPlayer")

local function transformAccountType(type)
   if QB and type == "money" then
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
   elseif QB then
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

function VxPlayer:getFirstName()
   if ESX then
      return string.match(self.fp.getName(), "%S+")
   elseif QB then
      return self.fp.PlayerData.charinfo.firstname
   end
end

function VxPlayer:getLastName()
   if ESX then
      return string.match(self.fp.getName(), "%s(.+)")
   elseif QB then
      return self.fp.PlayerData.charinfo.lastname
   end
end

function VxPlayer:getFullName()
   if ESX then
      return self.fp.getName()
   elseif QB then
      return string.format("%s %s", self:getFirstName(), self:getLastName())
   end
end

function VxPlayer:getJob()
   return getJob(self)
end

function VxPlayer:getGroup()
   return ESX and self.fp.getGroup() or QB and QBCore.Functions.GetPermission(self.source)
end

---@param amount number
---@param type AccountType|string
function VxPlayer:giveMoney(amount, type)
   type = transformAccountType(type)

   if ESX then
      self.fp.addAccountMoney(type, amount)
   elseif QB then
      self.fp.Functions.AddMoney(type, amount)
   end
end

---@param amount number
---@param type AccountType|string
function VxPlayer:removeMoney(amount, type)
   type = transformAccountType(type)

   if ESX then
      self.fp.removeAccountMoney(type, amount)
   elseif QB then
      self.fp.Functions.RemoveMoney(type, amount)
   end
end

---@param type AccountType|string
function VxPlayer:getMoney(type)
   type = transformAccountType(type)
   return ESX and self.fp.getAccount(type).money or QB
       and self.fp.Functions.GetMoney(type)
end

function VxPlayer:getGang()
   return getJob(self, "gang")
end

---@param source number
function vx.player.getFromId(source)
   return VxPlayer:new(source)
end

return vx.player
