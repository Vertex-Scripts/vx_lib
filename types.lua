---@alias IdentifierType
---| '"steam"'
---| '"license"'
---| '"xbl"'
---| '"live"'
---| '"discord"'
---| '"ip"'

---@alias Framework
---| '"es_extended"'
---| '"qb-core"'
---| '"auto"'

---@alias Target
---| '"ox_target"'
---| '"qb-target"'
---| '"auto"'

---@alias Inventory
---| '"ox_inventory"'
---| '"es_extended"'
---| '"qb-inventory"'
---| '"auto"'

---@alias AccountType
---| '"bank"'
---| '"money"'
---| '"cash"'
---| '"black_money"'

---@alias NotificationSystem
---| '"ox_lib"'
---| '"es_extended"'
---| '"qb-core"'
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
