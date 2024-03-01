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


---@class SharedConfig
---@field primaryIdentifier "license" | "steam" | "discord" | "fivem"
---@field framework Framework
---@field target TargetSystem
---@field inventory InventorySystem
---@field debug boolean


---@class CommandParams
---@field name string
---@field help? string
---@field type? 'number' | 'playerId' | 'string'
---@field optional? boolean
---@field full? boolean

---@class CommandProperties
---@field help string?
---@field params CommandParams[]?
---@field restricted boolean | string | string[]?


---@class WebhookParams
---@field content? string
---@field username? string
---@field avatar_url? string
---@field embeds WebhookEmbed[]

---@class WebhookEmbed
---@field title? string
---@field description? string
---@field timestamp? number|osdate
---@field color? number
---@field fields? { name: string, value: string, inline: boolean }[]

---@class QbTargetOptions
---@field options QbTargetOption[]
---@field distance? number

---@class QbTargetOption
---@field label string
---@field icon? string
---@field action? fun(entity: number)
---@field canInteract? fun(entity: number, distance: number, data: table): boolean


---@class TargetOptions
---@field label string
---@field name string
---@field icon? string
---@field distance? number
---@field onSelect fun(data: table)
---@field canInteract fun(data: table): boolean


---@class EntityTargetOptions : TargetOptions
---@field onSelect? fun(data: { entity: number })
---@field canInteract? fun(data: { entity: number }): boolean
