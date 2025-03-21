--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright (c) 2025 Linden <https://github.com/thelindat/fivem>
]]

---@class VxArray<T> : VxClass, { [number]: T }
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

---@generic T
---@param self VxArray<T>
---@param ... T
function vx.array:push(...)
   local elements = { ... }
   local length = #self

   for i = 1, #elements do
      length += 1
      self[length] = elements[i]
   end

   return length
end

---@generic T
---@param self VxArray<T>
---@param func fun(element: T, index: number)
function vx.array:forEach(func)
   for i = 1, #self do
      func(self[i], i)
   end
end

---@generic T, R
---@param self VxArray<T>
---@param func fun(element: T, index: number): R
---@return VxArray<R>
function vx.array:map(func)
   local result = {}
   for i = 1, #self do
      result[i] = func(self[i], i)
   end

   return vx.array:new(table.unpack(result))
end

---@generic T
---@param self VxArray<T>
---@param testFunc fun(element: T): boolean
---@return T
function vx.array:find(testFunc)
   local index = self:findIndex(testFunc)
   return self[index]
end

---@generic T
---@param self VxArray<T>
---@param testFunc fun(element: T): boolean
---@return number
function vx.array:findIndex(testFunc)
   for i = 1, #self do
      if testFunc(self[i]) then
         return i
      end
   end

   return -1
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

---@generic T
---@param self VxArray<T>
---@param testFunc fun(element: T): boolean
---@return VxArray<T>
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
