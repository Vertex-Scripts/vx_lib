---@class ErrorResponse
---@field message string
---@field code integer

---@class BaseResponse
---@field status integer
---@field body any
---@field headers table<string, string>
---@field error ErrorResponse?

---@class DiscordUser
---@field id string
---@field username string

---@class DiscordMember
---@field user DiscordUser
---@field avatar? string
---@field banner? string
---@field roles string[]

---@class DiscordRole
---@field name string
---@field id string
---@field colors { primary_color: integer, secondary_color: integer }

---@class DiscordGuild
---@field id string
---@field roles DiscordRole[]

---@class DiscordRole
---@field id string
---@field name string
---@field color integer
---@field hexColor? string
---@field position integer
