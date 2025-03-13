---@diagnostic disable: duplicate-set-field
vx.inventory = {}

local oxInventory = vx.inventoryResource == "ox_inventory" and exports.ox_inventory
local qbInventory = vx.inventoryResource == "qb-inventory" and exports["qb-inventory"]
local esxInventory = vx.inventoryResource == "es_extended"

---@param item string
function vx.inventory.getItemCount(item)
   if oxInventory then
      return oxInventory:GetItemCount(item)
   elseif qbInventory then
      local player = QBCore.Functions.GetPlayerData()
      local items = vx.array:new(table.unpack(player.items))
      local foundItem = items:find(function(i) return i.name == item end)
      return foundItem?.amount or 0
   elseif esxInventory then
      return ESX.SearchInventory(item)?.count
   end
end

---@param item string
---@param count? number
function vx.inventory.hasItem(item, count)
   return vx.inventory.getItemCount(item) >= (count or 1)
end

return vx.inventory
