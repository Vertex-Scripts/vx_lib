---@class PointProps
---@field coords vector3
---@field distance number
---@field onEnter? fun(self: Point)
---@field onExit? fun(self: Point)
---@field nearby? fun(self: Point)
---@field [string] any

---@class Point : PointProps
---@field id number
---@field currentDistance number
---@field isClosest? boolean
---@field remove fun()

---@type table<number, Point>
local points = {}
---@type Point[]
local nearbyPoints = {}
local intervals = {}
local nearbyCount = 0
---@type Point?
local closestPoint
local tick

local function removePoint(self)
   if closestPoint?.id == self.id then
      closestPoint = nil
   end

   points[self.id] = nil
end

---@param callback function | number
---@param interval? number
---@param ... any
function SetInterval(callback, interval, ...)
   interval = interval or 0

   if type(interval) ~= 'number' then
      return error(('Interval must be a number. Received %s'):format(json.encode(interval --[[@as unknown]])))
   end

   local cbType = type(callback)
   if cbType == 'number' and intervals[callback] then
      intervals[callback] = interval or 0
      return
   end

   if cbType ~= 'function' then
      return error(('Callback must be a function. Received %s'):format(cbType))
   end

   ---@diagnostic disable-next-line: unbalanced-assignments
   local args, id = { ... }
   Citizen.CreateThreadNow(function(ref)
      id = ref
      intervals[id] = interval or 0
      repeat
         interval = intervals[id]
         Wait(interval)
         callback(table.unpack(args))
      until interval < 0
      intervals[id] = nil
   end)

   return id
end

---@param id number
function ClearInterval(id)
   if type(id) ~= 'number' then
      return error(('Interval id must be a number. Received %s'):format(json.encode(id --[[@as unknown]])))
   end

   if not intervals[id] then
      return error(('No interval exists with id %s'):format(id))
   end

   intervals[id] = -1
end

CreateThread(function()
   while true do
      if nearbyCount ~= 0 then
         table.wipe(nearbyPoints)
         nearbyCount = 0
      end

      local ped = PlayerPedId()
      local coords = GetEntityCoords(ped)

      if closestPoint and #(coords - closestPoint.coords) > closestPoint.distance then
         closestPoint = nil
      end

      for _, point in pairs(points) do
         local distance = #(coords - point.coords)

         if distance <= point.distance then
            point.currentDistance = distance

            if closestPoint then
               if distance < closestPoint.currentDistance then
                  closestPoint.isClosest = nil
                  point.isClosest = true
                  closestPoint = point
               end
            elseif distance < point.distance then
               point.isClosest = true
               closestPoint = point
            end

            if point.nearby then
               nearbyCount += 1
               nearbyPoints[nearbyCount] = point
            end

            if point.onEnter and not point.inside then
               point.inside = true
               point:onEnter()
            end
         elseif point.currentDistance then
            if point.onExit then point:onExit() end
            point.inside = nil
            point.currentDistance = nil
         end
      end

      if not tick then
         if nearbyCount ~= 0 then
            tick = SetInterval(function()
               for i = 1, nearbyCount do
                  local point = nearbyPoints[i]

                  if point then
                     point:nearby()
                  end
               end
            end)
         end
      elseif nearbyCount == 0 then
         tick = ClearInterval(tick)
      end

      Wait(300)
   end
end)

local function toVector(coords)
   local _type = type(coords)

   if _type ~= 'vector3' then
      if _type == 'table' or _type == 'vector4' then
         return vec3(coords[1] or coords.x, coords[2] or coords.y, coords[3] or coords.z)
      end

      error(("expected type 'vector3' or 'table' (received %s)"):format(_type))
   end

   return coords
end

vx.points = {
   ---@return Point
   ---@overload fun(data: PointProps): Point
   ---@overload fun(coords: vector3, distance: number, data?: PointProps): Point
   new = function(...)
      local args = { ... }
      local id = #points + 1
      local self

      -- Support sending a single argument containing point data
      if type(args[1]) == 'table' then
         self = args[1]
         self.id = id
         self.remove = removePoint
      else
         -- Backwards compatibility for original implementation (args: coords, distance, data)
         self = {
            id = id,
            coords = args[1],
            remove = removePoint,
         }
      end

      self.coords = toVector(self.coords)
      self.distance = self.distance or args[2]

      if args[3] then
         for k, v in pairs(args[3]) do
            self[k] = v
         end
      end

      points[id] = self

      return self
   end,

   getAllPoints = function() return points end,

   getNearbyPoints = function() return nearbyPoints end,

   ---@return Point?
   getClosestPoint = function() return closestPoint end,
}

return vx.points
