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


---@param url string
---@param params WebhookParams
function vx.sendWebhook(url, params)
   if url == nil then
      return
   end

   local body = json.encode(params)
   local headers = { ['Content-Type'] = 'application/json' }

   PerformHttpRequest(url, function(statusCode, t, _)
      if statusCode ~= 204 then
         -- TODO
         print(statusCode, t)
      end
   end, 'POST', body, headers)
end

return vx.sendWebhook
