---@class VxTextUi : VxClass
vx.textui = vx.class("VxTextUi")

---@private
function vx.textui:constructor()
   self.isShown = false
end

---@param text string
---@param type? "success" | "error" | "info"
function vx.textui:show(text, type)
   if self.isShown then return end

   self.isShown = true
   vx.showTextUi(text, type)
end

function vx.textui:hide()
   if not self.isShown then return end

   self.isShown = false
   vx.hideTextUi()
end

return vx.textui
