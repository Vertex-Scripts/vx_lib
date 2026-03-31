local pedInteractionCam = nil
local pedInteractionResolve = nil

---@class VxPedInteractionOption
---@field id? string Unique identifier (defaults to label)
---@field label string
---@field icon? string
---@field description? string
---@field args? any
---@field onSelect? fun(args: any)

---@class VxPedInteractionButton
---@field id? string Unique identifier (defaults to label)
---@field label string
---@field style? "primary" | "secondary" | "danger"
---@field args? any
---@field onSelect? fun(args: any)

---@class VxPedInteractionProps
---@field ped number The ped entity to focus the camera on
---@field name? string The name displayed in the chat bubble (default: "NPC")
---@field message? string Single chat message (shorthand for messages = { message })
---@field messages? string[] Multiple chat messages shown sequentially with typing animation
---@field options? VxPedInteractionOption[]
---@field buttons? VxPedInteractionButton[]
---@field onClose? fun() Called when the interaction is closed without selecting
---@field camOffset? vector3 Camera position offset from ped (default: vec3(0.0, 0.8, 0.6))
---@field camFov? number Camera field of view (default: 45.0)

local function destroyPedInteractionCam()
   if pedInteractionCam then
      RenderScriptCams(false, true, 700, true, true)
      Wait(700)
      DestroyCam(pedInteractionCam, false)
      pedInteractionCam = nil
   end
end

---@param props VxPedInteractionProps
---@return string? id The id (or label) of the selected option/button, or nil if closed
function vx.pedInteraction(props)
   local ped = props.ped
   local offset = props.camOffset or vector3(0.0, 0.8, 0.6)

   local messages = props.messages or { props.message or "" }

   local faceCoord = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
   local camPos = GetOffsetFromEntityInWorldCoords(ped, offset.x, offset.y, offset.z)

   pedInteractionCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
   SetCamCoord(pedInteractionCam, camPos.x, camPos.y, camPos.z)
   PointCamAtCoord(pedInteractionCam, faceCoord.x, faceCoord.y, faceCoord.z)
   SetCamFov(pedInteractionCam, props.camFov or 45.0)
   SetCamActiveWithInterp(pedInteractionCam, true, 700, 1, 1)
   RenderScriptCams(true, true, 700, true, true)

   Wait(500)

   local nuiOptions = nil
   if props.options then
      nuiOptions = {}
      for i = 1, #props.options do
         local opt = props.options[i]
         nuiOptions[i] = {
            id = opt.id or opt.label,
            label = opt.label,
            icon = opt.icon,
            description = opt.description,
         }
      end
   end

   local nuiButtons = nil
   if props.buttons then
      nuiButtons = {}
      for i = 1, #props.buttons do
         local btn = props.buttons[i]
         nuiButtons[i] = {
            id = btn.id or btn.label,
            label = btn.label,
            style = btn.style,
         }
      end
   end

   vx.setNuiFocus()
   vx.nui.sendAction("openPedInteraction", {
      name = props.name or "NPC",
      messages = messages,
      options = nuiOptions,
      buttons = nuiButtons,
   })

   local p = promise.new()
   pedInteractionResolve = p

   local selectedId = Citizen.Await(p)
   pedInteractionResolve = nil

   destroyPedInteractionCam()

   if selectedId then
      if props.options then
         for i = 1, #props.options do
            local opt = props.options[i]
            if (opt.id or opt.label) == selectedId and opt.onSelect then
               opt.onSelect(opt.args)
               break
            end
         end
      end

      if props.buttons then
         for i = 1, #props.buttons do
            local btn = props.buttons[i]
            if (btn.id or btn.label) == selectedId and btn.onSelect then
               btn.onSelect(btn.args)
               break
            end
         end
      end
   elseif props.onClose then
      props.onClose()
   end

   return selectedId
end

RegisterNUICallback("selectPedInteractionOption", function(data, cb)
   cb(true)

   vx.nui.sendAction("closePedInteraction")
   vx.resetNuiFocus()

   if pedInteractionResolve then
      pedInteractionResolve:resolve(data.id)
   end
end)

RegisterNUICallback("closePedInteraction", function(_, cb)
   cb(true)

   vx.nui.sendAction("closePedInteraction")
   vx.resetNuiFocus()

   if pedInteractionResolve then
      pedInteractionResolve:resolve(nil)
   end
end)

-- local ped = vx.createPed(4, `a_m_m_skater_01`, vector3(340.2528, -1396.6494, 32.5092), 0.0)
-- RegisterCommand("do", function()
--    -- local result = vx.pedInteraction({
--    --    ped = ped,
--    --    name = "Dealer",
--    --    messages = {
--    --       "Hey, you looking for something?",
--    --       "I got the good stuff today.",
--    --       "What do you want?",
--    --    },
--    --    options = {
--    --       { label = "Weed",    description = "5x", onSelect = function() end },
--    --       { label = "Cocaine", description = "3x", onSelect = function() end },
--    --    },
--    --    buttons = {
--    --       { label = "Accept",  style = "primary", onSelect = function() end },
--    --       { label = "Decline", style = "danger",  onSelect = function() end },
--    --    },
--    -- })
-- end)
