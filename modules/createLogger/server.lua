---@class VxLogger : VxClass
VxLogger = vx.class("VxLogger")

local function createFieldDescription(icon, key, value)
   return string.format("`%s` %s: `%s`", icon, key, value)
end

function VxLogger:constructor(name, url)
   self.descriptionBuilder = vx.createStringBuilder()
   self.url = url
   self.name = name
   self.fields = {}
end

function VxLogger:addDescriptionField(key, value)
   if not key and not value then
      self.descriptionBuilder:appendLine("")
      return self
   end

   local line = string.format("**%s**: %s", key, value)
   self.descriptionBuilder:appendLine(line)

   return self
end

---@param options? { includeAccounts?: boolean; displayName?: string; additionalFields?: { icon: string, key: string, value: any }[] }
function VxLogger:addPlayer(playerId, options)
<<<<<<< Updated upstream
   if type(playerId) == "string" then
      playerId = tonumber(playerId) or 0
   end
=======
   playerId = tonumber(playerId) or 0
>>>>>>> Stashed changes

   options = options or {}
   options.includeAccounts = options.includeAccounts == nil and vx.serverConfig.logger.defaults.includeAccounts or
       options.includeAccounts

   local fieldDescriptionBuilder = vx.createStringBuilder()
   local playerName = playerId > 0 and GetPlayerName(playerId) or "Console"
   local displayName = string.format("Speler: %s", playerName)
   if options and options.displayName then
      displayName = string.format(options.displayName, playerName)
   end

   if playerId <= 0 then
      local field = {
         name = displayName,
         value = "*Console*",
         inline = false
      }

      table.insert(self.fields, field)
      return self
   end

   local license = vx.player.getIdentifier(playerId, false, "license")
   local license2 = vx.player.getIdentifier(playerId, false, "license2")
   local discord = vx.player.getIdentifier(playerId, false, "discord")
   local steam = vx.player.getIdentifier(playerId, false, "steam")

   fieldDescriptionBuilder:appendLine(createFieldDescription("🔢", "Server ID", playerId))
   if license then fieldDescriptionBuilder:appendLine(createFieldDescription("💿", "License", license)) end
   if license2 then fieldDescriptionBuilder:appendLine(createFieldDescription("📀", "License2", license2)) end
   if discord then
      fieldDescriptionBuilder:appendLine(createFieldDescription("💬", "Discord", discord) ..
         (" (<@%s>)"):format(discord))
   end

   if steam then fieldDescriptionBuilder:appendLine(createFieldDescription("🎮", "Steam", steam)) end
   if options?.includeAccounts then
      local vxPlayer = vx.player.getFromId(playerId)
      local bank = vxPlayer:getMoney("bank")
      local money = vxPlayer:getMoney("money")
      local blackMoney = vxPlayer:getMoney("black_money")

      fieldDescriptionBuilder:appendLine(createFieldDescription("💰", "Bank", vx.formatting.formatCurrency(bank)))
      fieldDescriptionBuilder:appendLine(createFieldDescription("💵", "Geld", vx.formatting.formatCurrency(money)))
      fieldDescriptionBuilder:appendLine(createFieldDescription("💸", "Zwart Geld",
         vx.formatting.formatCurrency(blackMoney)))
   end

   if options?.additionalFields then
      for _, field in ipairs(options.additionalFields) do
         fieldDescriptionBuilder:appendLine(createFieldDescription(field.icon, field.key, field.value))
      end
   end

   local field = {
      name = displayName,
      value = fieldDescriptionBuilder:toString(),
      inline = false
   }

   table.insert(self.fields, field)
   return self
end

function VxLogger:send()
   local response = vx.sendHttpRequest(self.url, {
      method = "POST",
      body = json.encode({
         username = vx.serverConfig.logger.username,
         avatar_url = vx.serverConfig.logger.avatarUrl,
         embeds = {
            {
               title = string.format("%s Logs", self.name),
               description = self.descriptionBuilder:toString(),
               fields = self.fields,
               color = vx.serverConfig.logger.color,
               footer = {
                  text = os.date("%X - %d/%m/%Y"),
                  icon_url = vx.serverConfig.logger.avatarUrl
               }
            }
         }
      }),
      headers = { ['Content-Type'] = 'application/json' }
   })

   if response.status ~= 204 then
      vx.print.error(string.format("Failed to send %s logs to Discord: %s", self.name, response.errorText))
   end
end

---@param name string
---@param url string
function vx.createLogger(name, url)
   return VxLogger:new(name, url)
end

return vx.createLogger
