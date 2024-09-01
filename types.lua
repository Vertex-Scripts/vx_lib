---@alias IdentifierType
---| '"steam"'
---| '"license"'
---| '"xbl"'
---| '"live"'
---| '"discord"'
---| '"ip"'

---@alias Framework
---| '"esx"'
---| '"qb"'
---| '"auto"'

---@alias TargetSystem
---| '"ox_target"'
---| '"qb_target"'
---| '"qtarget"'
---| '"auto"'

---@alias InventorySystem
---| '"ox_inventory"'
---| '"qb_inventory"'
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

---@class VxCache
---@field resource string
---@field playerId number
---@field serverId number
---@field vehicle number
---@field ped number
---@field set fun(self, key: string, value: any)
