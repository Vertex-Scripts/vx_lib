---@diagnostic disable: duplicate-set-field
vx.inventory = {}

local oxInventory = vx.inventoryResource == "ox_inventory" and exports.ox_inventory
local qbInventory = vx.inventoryResource == "qb-inventory" and exports["qb-inventory"]
local esxInventory = vx.inventoryResource == "es_extended"

---@param source number
---@param item string
---@param count? number
function vx.inventory.addItem(source, item, count)
   if oxInventory then
      return oxInventory:AddItem(source, item, count or 1)
   elseif qbInventory then
      return qbInventory:AddItem(source, item, count or 1)
   elseif esxInventory then
      local xPlayer = ESX.GetPlayerFromId(source)
      return xPlayer.addInventoryItem(item, count or 1)
   end
end

---@param source number
---@param item string
---@param count? number
function vx.inventory.removeItem(source, item, count)
   if oxInventory then
      return oxInventory:RemoveItem(source, item, count or 1)
   elseif qbInventory then
      return qbInventory:RemoveItem(source, item, count or 1)
   elseif esxInventory then
      local xPlayer = ESX.GetPlayerFromId(source)
      return xPlayer.removeInventoryItem(item, count or 1)
   end
end

---@param source number
---@param item string
function vx.inventory.getItemCount(source, item)
   if oxInventory then
      return oxInventory:GetItemCount(source, item)
   elseif qbInventory then
      return qbInventory:GetItemCount(source, item)
   elseif esxInventory then
      local xPlayer = ESX.GetPlayerFromId(source)
      return xPlayer.getInventoryItem(item).count
   end
end

---@param source number
---@param item string
---@param count? number
function vx.inventory.hasItem(source, item, count)
   return vx.inventory.getItemCount(source, item) >= (count or 1)
end

return vx.inventory
