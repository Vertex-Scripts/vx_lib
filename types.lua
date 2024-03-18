---@alias Framework
---| '"ESX"'
---| '"QB"'
---| '"auto"'

---@alias TargetSystem
---| '"ox_target"'
---| '"qb-target"'
---| '"qtarget"'
---| '"auto"'

---@alias InventorySystem
---| '"ox_inventory"'
---| '"qb-inventory"'
---| '"es_extended"'
---| '"qs-inventory"'
---| '"auto"'

---@alias AccountType
---| '"bank"'
---| '"money"'

---@alias NotificationSystem
---| '"ox"'
---| '"esx"'
---| '"qb"'
---| '"custom"'

---@alias TextUISystem
---| '"ox"'
---| '"custom"'


---@class SharedConfig
---@field primaryIdentifier "license" | "steam" | "discord" | "fivem"
---@field framework Framework
---@field target TargetSystem
---@field inventory InventorySystem
---@field notification NotificationSystem
---@field debug boolean
---@field textui TextUISystem
