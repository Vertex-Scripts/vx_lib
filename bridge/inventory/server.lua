vx.inventory = {}

-------------
-- addItem --
-------------

local function addItem_ox(source, item, count)
   exports.ox_inventory:AddItem(source, item, count)
end

local function addItem_esx(source, item, count)
   local xPlayer = ESX.GetPlayerFromId(source)
   xPlayer.addInventoryItem(item, count)
end

local function addItem_qb(source, item, count)
   local player = QBCore.Functions.GetPlayer(source)
   player.Functions.AddItem(item, count)
end

local function addItem_qs(source, item, count)
   local caller = vx.caller.createFrameworkCaller({
      ["ESX"] = addItem_esx,
      ["QB"] = addItem_qb
   })

   return caller(source, item, count)
end

---@param source number
---@param item string
---@param count? number
function vx.inventory.addItem(source, item, count)
   local caller = vx.caller.createInventoryCaller({
      ["ox_inventory"] = addItem_ox,
      ["es_extended"] = addItem_esx,
      ["qb-inventory"] = addItem_qb,
      ["qs-inventory"] = addItem_qs
   })

   return caller(source, item, count or 1)
end

----------------
-- removeItem --
----------------

local function removeItem_ox(source, item, count)
   exports.ox_inventory:RemoveItem(source, item, count)
end

local function removeItem_qb(source, item, count)
   local player = QBCore.Functions.GetPlayer(source)
   player.Functions.RemoveItem(item, count)
end

local function removeItem_esx(source, item, count)
   local xPlayer = ESX.GetPlayerFromId(source)
   xPlayer.removeInventoryItem(item, count)
end

-- QS Inventory also works with the framework istelf
local function removeItem_qs(source, item, count)
   local caller = vx.caller.createFrameworkCaller({
      ["ESX"] = removeItem_esx,
      ["QB"] = removeItem_qb
   })

   return caller(source, item, count)
end

---@param source number
---@param item string
---@param count? number
function vx.inventory.removeItem(source, item, count)
   local caller = vx.caller.createInventoryCaller({
      ["ox_inventory"] = removeItem_ox,
      ["es_extended"] = removeItem_esx,
      ["qb-inventory"] = removeItem_qb,
      ["qs-inventory"] = removeItem_qs,
   })

   return caller(source, item, count or 1)
end

------------------
-- getItemCount --
------------------

local function getItemCount_ox(source, item)
   local result = exports.ox_inventory:Search(source, 'count', item)
   return result
end

local function getItemCount_esx(source, item)
   local xPlayer = ESX.GetPlayerFromId(source)
   local result = xPlayer.getInventoryItem(item).count

   return result
end

local function getItemCount_qb(source, item)
   local player = QBCore.Functions.GetPlayer(source)
   local result = player.Functions.GetItemByName(item)

   return result?.amount
end

-- QS Inventory also works with the framework istelf
local function getItemCount_qs(source, item)
   local caller = vx.caller.createFrameworkCaller({
      ["ESX"] = getItemCount_esx,
      ["QB"] = getItemCount_qb
   })

   return caller(source, item)
end

---@param source number
---@param item string
function vx.inventory.getItemCount(source, item)
   local caller = vx.caller.createInventoryCaller({
      ["ox_inventory"] = getItemCount_ox,
      ["es_extended"] = getItemCount_esx,
      ["qb-inventory"] = getItemCount_qb,
      ["qs-inventory"] = getItemCount_qs,
   })

   return caller(source, item)
end

-------------
-- hasItem --
-------------

local function hasItem(source, item, count)
   local result = vx.inventory.getItemCount(source, item)
   return result >= count
end

---@param source number
---@param item string
---@param count? number
function vx.inventory.hasItem(source, item, count)
   local caller = vx.caller.createInventoryCaller({
      ["ox_inventory"] = hasItem,
      ["es_extended"] = hasItem,
      ["qb-inventory"] = hasItem,
      ["qs-inventory"] = hasItem,
   })

   return caller(source, item, count or 1)
end

return vx.inventory
