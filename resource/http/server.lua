-- TODO: Find a good way to decode the response error, It should returns this now: 'HTTP 404: {"error":"Repository not found"}'

---@class VxHttpResponse
---@field status number
---@field ok boolean
---@field data? table
---@field errorText? string
---@field headers table<string, any>

---@class VxHttpOptions
---@field method? "GET" | "POST" | "PUT" | "DELETE" | "PATCH"
---@field body? any
---@field headers? table<string, any>

---@param url string
---@param options? VxHttpOptions
---@return VxHttpResponse
function vx.sendHttpRequest(url, options)
   local promise = promise.new()
   local method = options?.method or "GET"
   local body = options?.body or nil
   local headers = options?.headers or nil

   PerformHttpRequest(url, function(statusCode, data, responseHeaders, statusText)
      ---@type VxHttpResponse
      local response = {
         status = statusCode,
         data = json.decode(data),
         headers = responseHeaders,
         errorText = statusText,
         ok = statusCode >= 200 and statusCode < 300,
      }

      promise:resolve(response)
   end, method, body, headers)

   return Citizen.Await(promise)
end
