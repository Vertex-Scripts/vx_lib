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

---@param key string
---@param value any
function vx.memoryCache:update(key, value)
   if self.cache[key] then
      self.cache[key] = value
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

---@param key string
---@param resolver fun():any
---@param ttl number
function vx.memoryCache:getOrSet(key, resolver, ttl)
   local value = self:get(key)
   if value then
      return value
   end

   value = resolver()
   self:set(key, value, ttl)

   return value
end

return vx.memoryCache
