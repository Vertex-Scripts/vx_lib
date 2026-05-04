---@class VxCooldown : VxClass
vx.cooldown = vx.class("VxCooldown")

---@private
function vx.cooldown:constructor()
   self.memoryCache = vx.memoryCache:new()
end

local function getCooldownKey(playerId, action)
   return string.format("cooldown:%s:%s", playerId, action)
end

---@param playerId string|number
---@param action string
---@return number? timestamp
function vx.cooldown:get(playerId, action)
   local key = getCooldownKey(playerId, action)
   return self.memoryCache:get(key)
end

---@param playerId string|number
---@param action string
function vx.cooldown:set(playerId, action, duration)
   local key = getCooldownKey(playerId, action)
   local expireAt = os.time() + math.ceil(duration / 1000)
   self.memoryCache:set(key, expireAt, duration)

   return expireAt
end

---@param playerId string|number
---@param action string
---@return number cooldown left in seconds, or 0
function vx.cooldown:getTimeLeft(playerId, action)
   local expireAt = self:get(playerId, action)
   if not expireAt then return 0 end

   local left = expireAt - os.time()
   return math.max(left, 0)
end

---@param playerId string|number
---@param action string
---@return boolean, string?
function vx.cooldown:hasCooldown(playerId, action)
   local timeLeft = self:getTimeLeft(playerId, action)
   return timeLeft > 0, timeLeft > 0 and self:getTimeLeftFormatted(timeLeft) or nil
end

---@param seconds number
---@return string human-readable
function vx.cooldown:getTimeLeftFormatted(seconds)
   seconds = math.floor(seconds)
   local minutes = math.floor(seconds / 60)
   local secs = seconds % 60

   local parts = {}
   if minutes > 0 then table.insert(parts, minutes .. " minuut" .. (minutes > 1 and "en" or "")) end
   if secs > 0 or minutes == 0 then table.insert(parts, secs .. " seconde" .. (secs ~= 1 and "n" or "")) end

   return table.concat(parts, ", ")
end

return vx.cooldown
