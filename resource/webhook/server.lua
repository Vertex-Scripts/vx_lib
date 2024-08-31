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
   if not url then
      error("invalid webhook url (received 'nil')")
   end

   if not params.content and not params.embeds then
      error("invalid webhook params (expected 'content' or 'embeds' to be set)")
   end

   local response = vx.sendHttpRequest(url, {
      method = "POST",
      body = json.encode(params),
      headers = { ['Content-Type'] = 'application/json' }
   })

   if not response.ok then
      vx.print.warn(("Failed to send webhook (status %s)"):format(response.status))
   end

   return response
end

vx.sendWebhook(
   "https://discord.com/api/webhooks/1279413465890422877/5L35T9lKXdj3Nm-mBpTt-_Jj2cwp46-OD9nuSAdZeFuxGp74eLCMkqpf4vnuSuePdzOK",
   {
      content = "test"
   })
