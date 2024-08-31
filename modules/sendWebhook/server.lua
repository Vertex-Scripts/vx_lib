---@class WebhookParams
---@field content? string
---@field username? string
---@field avatar_url? string
---@field embeds? WebhookEmbed[]

---@class WebhookEmbed
---@field title? string
---@field description? string
---@field timestamp? number|osdate
---@field color? number
---@field fields? { name: string, value: string, inline: boolean }[]

---@param url string
---@param params WebhookParams
function vx.sendWebhook(url, params)
   if url == nil then
      return
   end

   local response = vx.sendHttpRequest(url, {
      method = "POST",
      body = json.encode(params),
      headers = { ['Content-Type'] = 'application/json' }
   })

   if not response.ok then
      vx.print.warn("Failed to send webhook", response.errorText)
   end
end

return vx.sendWebhook
