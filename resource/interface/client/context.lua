local registeredMenus = {}
local openContextMenuId = nil

---@class VxContextMenu
---@field id string
---@field title? string
---@field onExit? fun()
---@field options? VxContextMenuOption[]

---@class VxContextMenuOption
---@field title? string
---@field description? string
---@field args? any
---@field onSelect? fun(args: any)

---@param menus VxContextMenu | VxContextMenu[]
function vx.registerContextMenu(menus)
   registeredMenus[menus.id] = menus
end

function vx.openContextMenu(id)
   if not registeredMenus[id] then
      error(("No context menu with id '%s' registered"):format(id))
   end

   local menu = registeredMenus[id]
   openContextMenuId = id

   vx.setNuiFocus()
   vx.sendNuiAction("openContextMenu", {
      title = menu.title,
      options = menu.options
   })
end

RegisterNUICallback("clickContextMenuOption", function(id, cb)
   cb(true)
   id += 1

   local menu = registeredMenus[openContextMenuId]
   local option = menu.options[id]

   openContextMenuId = nil
   vx.sendNuiAction("hideContextMenu")
   vx.resetNuiFocus()

   if not option.onSelect then
      return
   end

   if option.onSelect then
      option.onSelect()
   end
end)

RegisterNUICallback("closeContextMenu", function(_, cb)
   cb(true)

   vx.resetNuiFocus()
   if not openContextMenuId then
      return
   end

   local menu = registeredMenus[openContextMenuId]
   if menu.onExit then
      menu.onExit()
   end
end)
