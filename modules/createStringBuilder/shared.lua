---@class VxStringBuilder : VxClass
vx.stringBuilder = vx.class("VxStringBuilder")

function vx.stringBuilder:constructor()
   self.buffer = {}
end

function vx.stringBuilder:append(str)
   table.insert(self.buffer, str)
   return self
end

function vx.stringBuilder:appendFormat(str, ...)
   table.insert(self.buffer, string.format(str, ...))
   return self
end

function vx.stringBuilder:appendLine(str)
   table.insert(self.buffer, str .. "\n")
   return self
end

function vx.stringBuilder:toString()
   return table.concat(self.buffer)
end

return vx.stringBuilder
