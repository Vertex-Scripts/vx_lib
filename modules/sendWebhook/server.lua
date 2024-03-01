---@param url string
---@param params WebhookParams
function cfx.sendWebhook(url, params)
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

return cfx.sendWebhook
