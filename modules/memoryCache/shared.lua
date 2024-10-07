---@class MemoryCache : OxClass
vx.memoryCache = vx.class("MemoryCache")

---@private
function vx.memoryCache:constructor()
   self.cache = {}
   self.ttl = {}
end

local function getCurrentMilliseconds()
   return GetGameTimer()
end

---@param key string
---@param value any
---@param expiration number
function vx.memoryCache:set(key, value, expiration)
   self.cache[key] = value
   if expiration then
      self.ttl[key] = getCurrentMilliseconds() + expiration
   end
end

function vx.memoryCache:get(key)
   local cachedValue = self.cache[key]
   if not cachedValue then
      return nil
   end

   if self.ttl[key] < getCurrentMilliseconds() then
      self:remove(key)
      return nil
   end

   return cachedValue
end

function vx.memoryCache:remove(key)
   self.cache[key] = nil
   self.ttl[key] = nil
end

return vx.memoryCache
