---@class VxArray : VxClass
vx.array = vx.class("VxArray")

---@private
function vx.array:constructor(...)
   local arr = { ... }
   for i = 1, #arr do
      self[i] = arr[i]
   end
end

---@private
function vx.array:__newindex(index, value)
   vx.typeCheck("index", index, "number", ("Cannot insert non-number index '%s' into an array."):format(index))

   rawset(self, index, value)
end

---@param ... any
function vx.array:push(...)
   local elements = { ... }
   local length = #self

   for i = 1, #elements do
      length += 1
      self[length] = elements[i]
   end

   return length
end

---@param func fun(element: unknown, index: number)
function vx.array:forEach(func)
   for i = 1, #self do
      func(self[i], i)
   end
end

---@param func fun(element: unknown, index: number): unknown
function vx.array:map(func)
   local result = {}
   for i = 1, #self do
      result[i] = func(self[i], i)
   end

   return vx.array:new(table.unpack(result))
end

---@param testFunc fun(element: unknown): boolean
function vx.array:find(testFunc)
   local index = self:findIndex(testFunc)
   return self[index]
end

---@param testFunc fun(element: unknown): boolean
function vx.array:findIndex(testFunc)
   for i = 1, #self do
      if testFunc(self[i]) then
         return i
      end
   end
end

function vx.array:contains(value)
   for i = 1, #self do
      if self[i] == value then
         return true
      end
   end

   return false
end

function vx.array:pop()
   return table.remove(self)
end

function vx.array:shift()
   return table.remove(self, 1)
end

---@param testFunc fun(element: unknown): boolean
function vx.array:filter(testFunc)
   local result = {}
   local length = 0

   self:forEach(function(element)
      if testFunc(element) then
         length += 1
         result[length] = element
      end
   end)

   return vx.array:new(table.unpack(result))
end

return vx.array
