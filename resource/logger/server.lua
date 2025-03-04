---@class VxLogger : VxClass
VxLogger = vx.class("VxLogger")

local function formatNumber(n)
   local formatted = tostring(n):reverse():gsub("(%d%d%d)", "%1."):reverse()
   return formatted:gsub("^%.", ""):gsub("%.$", "")
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
      return
   end

   if type(value) == "number" then
      value = formatNumber(value)
   end

   local line = string.format("**%s**: %s", key, value)
   self.descriptionBuilder:appendLine(line)
end

---@param options? { includeAccounts?: boolean; displayName?: string; }
function VxLogger:addPlayer(playerId, options)
   local fieldDescription = ""

   local playerName = GetPlayerName(playerId)
   local displayName = string.format("Speler: %s", playerName)
   if options and options.displayName then
      displayName = string.format(options.displayName, playerName)
   end

   local license = vx.player.getIdentifier(playerId, false, "license")
   local license2 = vx.player.getIdentifier(playerId, false, "license2")
   local discord = vx.player.getIdentifier(playerId, false, "discord")
   local steam = vx.player.getIdentifier(playerId, false, "steam")

   fieldDescription = string.format("%s`🔢` Server ID: `%s`\n", fieldDescription, playerId)
   if license then fieldDescription = string.format("%s`💿` License: `%s`\n", fieldDescription, license) end
   if license2 then fieldDescription = string.format("%s`📀` License2: `%s`\n", fieldDescription, license2) end
   if discord then fieldDescription = string.format("%s`💬` Discord: `%s`\n", fieldDescription, discord) end
   if steam then fieldDescription = string.format("%s`🎮` Steam: `%s`\n", fieldDescription, steam) end

   if options?.includeAccounts then
      local vxPlayer = vx.player.getFromId(playerId)
      local bank = vxPlayer:getAccountMoney("bank")
      local money = vxPlayer:getAccountMoney("money")
      local blackMoney = vxPlayer:getAccountMoney("black_money")

      fieldDescription = string.format("%s`💰` Bank: `%s`\n", fieldDescription, bank)
      fieldDescription = string.format("%s`💵` Geld: `%s`\n", fieldDescription, money)
      fieldDescription = string.format("%s`💸` Zwart Geld: `%s`\n", fieldDescription, blackMoney)
   end

   local field = {
      name = displayName,
      value = fieldDescription,
      inline = false
   }

   table.insert(self.fields, field)
end

function VxLogger:send()
   local response = vx.sendHttpRequest(self.url, {
      method = "POST",
      body = json.encode({
         username = Config.logger.username,
         avatar_url = Config.logger.avatarUrl,
         embeds = {
            {
               title = string.format("%s Logs", self.name),
               description = self.descriptionBuilder:toString(),
               fields = self.fields,
               color = 0x1b4de3,
               footer = {
                  text = os.date("%X - %d/%m/%Y"),
                  icon_url = Config.logger.avatarUrl
               }
            }
         }
      }),
      headers = { ['Content-Type'] = 'application/json' }
   })

   vx.print.info(response)
end

---@param name string
---@param url string
function vx.createLogger(name, url)
   return VxLogger:new(name, url)
end
