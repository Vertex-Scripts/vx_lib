-- TODO: add timeouts

vx.streaming = {}

---@param model number | string
---@return number?
function vx.streaming.requestModel(model)
   model = tonumber(model) or joaat(model)

   ---@cast model -string
   if HasModelLoaded(model) then
      return model
   end

   if not IsModelValid(model) then
      return error(("attempted to load invalid model '%s'"):format(model))
   end

   RequestModel(model)
   while not HasModelLoaded(model) do
      Citizen.Wait(0)
   end

   return model
end

---@param set string
---@return string
function vx.streaming.requestAnimSet(set)
   if HasAnimSetLoaded(animSet) then
      return set
   end

   RequestAnimSet(animSet)
   while not HasAnimSetLoaded(animSet) do
      Citizen.Wait(0)
   end

   return set
end

---@param dict string
---@return string
function vx.streaming.requestAnimDict(dict)
   if HasAnimDictLoaded(animDict) then
      return dict
   end

   RequestAnimDict(animDict)
   while not HasAnimDictLoaded(animDict) do
      Citizen.Wait(0)
   end

   return dict
end

---@param dict string
---@return string?
function vx.streaming.requestTextureDict(dict)
   if HasStreamedTextureDictLoaded(dict) then
      return dict
   end

   RequestStreamedTextureDict(dict, false)
   while not HasStreamedTextureDictLoaded(dict) do
      Citizen.Wait(0)
   end

   return dict
end

---@param asset string
---@return string?
function vx.streaming.requestPtfxAsset(asset)
   if HasNamedPtfxAssetLoaded(assetName) then
      return asset
   end


   RequestNamedPtfxAsset(assetName)
   while not HasNamedPtfxAssetLoaded(assetName) do
      Citizen.Wait(0)
   end

   return asset
end

return vx.streaming
