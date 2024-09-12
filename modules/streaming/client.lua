---@diagnostic disable: deprecated
-- TODO: add timeouts

---@deprecated
vx.streaming = {}

---@param model number | string
---@return number?
function vx.streaming.requestModel(model)
   return vx.requestModel(model)
end

---@param set string
---@return string
function vx.streaming.requestAnimSet(set)
   return vx.requestAnimSet(set)
end

---@param dict string
---@return string
function vx.streaming.requestAnimDict(dict)
   return vx.requestAnimDict(dict)
end

---@param dict string
---@return string?
function vx.streaming.requestTextureDict(dict)
   return vx.requestTextureDict(dict)
end

---@param asset string
---@return string?
function vx.streaming.requestPtfxAsset(asset)
   return vx.requestPtfxAsset(asset)
end

return vx.streaming
