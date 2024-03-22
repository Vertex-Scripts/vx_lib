vx.outfit = {}

---@class Variation
---@field drawable number
---@field texture? number
---@field palette? number

local numVariations = 12

function vx.outfit.save()
   local ped = PlayerPedId()
   local variations = {}

   for i = 1, numVariations do
      ---@type Variation
      local variation = {
         drawable = GetPedDrawableVariation(ped, i),
         texture = GetPedTextureVariation(ped, i),
         palette = GetPedPaletteVariation(ped, i)
      }

      variations[i] = variation
   end

   SetResourceKvp("vx_original_outfit", json.encode(variations))
   return variations
end

---@param variations Variation[]
function vx.outfit.set(variations)
   local ped = PlayerPedId()
   for i = 1, numVariations do
      local variation = variations[i]
      if variation then
         SetPedComponentVariation(ped, i, variation.drawable, variation.texture, variation.palette)
      end
   end
end

function vx.outfit.reset()
   local variations = json.decode(GetResourceKvpString("vx_original_outfit"))
   vx.outfit.set(variations)
end

---@class Outfit
---@field face? Variation
---@field mask? Variation
---@field hands? Variation
---@field pants? Variation
---@field parachute? Variation
---@field shoes? Variation
---@field accessory? Variation
---@field undershirt? Variation
---@field kevlar? Variation
---@field extras? Variation
---@field torso? Variation

--TODO: Better way to do this, and add other components
---@param outfit Outfit
function vx.outfit.create(outfit)
   ---@type Variation[]
   local variations = {
      { drawable = outfit.mask?.drawable,       texture = outfit.mask?.texture,       palette = outfit.mask?.palette },
      nil,
      { drawable = outfit.hands?.drawable,      texture = outfit.hands?.texture,      palette = outfit.hands?.palette },
      { drawable = outfit.pants?.drawable,      texture = outfit.pants?.texture,      palette = outfit.pants?.palette },
      { drawable = outfit.parachute?.drawable,  texture = outfit.parachute?.texture,  palette = outfit.parachute?.palette },
      { drawable = outfit.shoes?.drawable,      texture = outfit.shoes?.texture,      palette = outfit.shoes?.palette },
      { drawable = outfit.accessory?.drawable,  texture = outfit.accessory?.texture,  palette = outfit.accessory?.palette },
      { drawable = outfit.undershirt?.drawable, texture = outfit.undershirt?.texture, palette = outfit.undershirt?.palette },
      { drawable = outfit.kevlar?.drawable,     texture = outfit.kevlar?.texture,     palette = outfit.kevlar?.palette },
      { drawable = outfit.extras?.drawable,     texture = outfit.extras?.texture,     palette = outfit.extras?.palette },
      { drawable = outfit.torso?.drawable,      texture = outfit.torso?.texture,      palette = outfit.torso?.palette }
   }

   return variations
end

return vx.outfit
