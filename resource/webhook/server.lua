---@class WebhookParams
---@field content? string
---@field username? string
---@field avatar_url? string
---@field embeds? WebhookEmbed[]

---@class WebhookEmbedField
---@field name string
---@field value string
---@field inline boolean

---@class WebhookEmbed
---@field title? string
---@field description? string
---@field timestamp? number|osdate
---@field color? number
---@field fields? WebhookEmbedField[]

---@param url string
---@param params WebhookParams
function vx.sendWebhook(url, params)
   vx.typeCheck("url", url, "string")

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
