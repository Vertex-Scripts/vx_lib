---@class Path : OxClass
vx.path = vx.class("Path")

---@private
function vx.path:constructor(...)
   self.path = ""
   self.separator = "/"

   for _, segment in pairs({ ... }) do
      self:append(segment)
   end
end

---@private
function vx.path:fixPath(path)
   return path:gsub("\\", self.separator):gsub("/+", self.separator)
end

function vx.path:append(...)
   local segments = { ... }
   for _, segment in pairs(segments) do
      if #self.path > 0 then
         self.path = self.path .. self.separator
      end

      self.path = self.path .. segment
   end

   return self.path
end

function vx.path:toString()
   return self.path
end

return vx.path
