---@class VxStringBuilder : VxClass
VxStringBuilder = vx.class("VxStringBuilder")

function VxStringBuilder:constructor()
   self.buffer = {}
end

function VxStringBuilder:append(str)
   table.insert(self.buffer, str)
   return self
end

function VxStringBuilder:appendFormat(str, ...)
   table.insert(self.buffer, string.format(str, ...))
   return self
end

function VxStringBuilder:appendLine(str)
   table.insert(self.buffer, str .. "\n")
   return self
end

function VxStringBuilder:toString()
   return table.concat(self.buffer)
end

function vx.createStringBuilder()
   return VxStringBuilder:new()
end

return vx.createStringBuilder
