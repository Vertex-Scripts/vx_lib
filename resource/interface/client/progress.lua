local progress = nil

---@class VxProgressCircleProps
---@field duration number
---@field label string
---@field canCancel? boolean
---@field useWhileDead? boolean
---@field allowRagdoll? boolean
---@field allowCuffed? boolean
---@field allowFalling? boolean
---@field allowSwimming? boolean
---@field disable? { move?: boolean, sprint?: boolean, car?: boolean, combat?: boolean, mouse?: boolean }
---@field anim? { dict?: string, clip: string, flag?: number, blendIn?: number, blendOut?: number, duration?: number, playbackRate?: number, lockX?: boolean, lockY?: boolean, lockZ?: boolean, scenario?: string, playEnter?: boolean }

local controls = {
   INPUT_LOOK_LR = 1,
   INPUT_LOOK_UD = 2,
   INPUT_SPRINT = 21,
   INPUT_AIM = 25,
   INPUT_MOVE_LR = 30,
   INPUT_MOVE_UD = 31,
   INPUT_DUCK = 36,
   INPUT_VEH_MOVE_LEFT_ONLY = 63,
   INPUT_VEH_MOVE_RIGHT_ONLY = 64,
   INPUT_VEH_ACCELERATE = 71,
   INPUT_VEH_BRAKE = 72,
   INPUT_VEH_EXIT = 75,
   INPUT_VEH_MOUSE_CONTROL_OVERRIDE = 106
}

local function interruptProgress(data)
   if not data.useWhileDead and IsEntityDead(cache.ped) then return true end
   if not data.allowRagdoll and IsPedRagdoll(cache.ped) then return true end
   if not data.allowCuffed and IsPedCuffed(cache.ped) then return true end
   if not data.allowFalling and IsPedFalling(cache.ped) then return true end
   if not data.allowSwimming and IsPedSwimming(cache.ped) then return true end
end

local function startProgress(data)
   LocalPlayer.state.invBusy = true
   progress = data

   local anim = data.anim
   if anim then
      if anim.dict then
         vx.requestAnimDict(anim.dict)

         TaskPlayAnim(vx.cache.ped, anim.dict, anim.clip, anim.blendIn or 3.0, anim.blendOut or 1.0, anim.duration or -1,
            anim.flag or 49, anim.playbackRate or 0,
            anim.lockX, anim.lockY, anim.lockZ)
         RemoveAnimDict(anim.dict)
      elseif anim.scenario then
         TaskStartScenarioInPlace(cache.ped, anim.scenario, 0, anim.playEnter == nil or anim.playEnter --[[@as boolean]])
      end
   end

   local startTime = GetGameTimer()
   local disable = data.disable
   while progress do
      if disable then
         if disable.mouse then
            DisableControlAction(0, controls.INPUT_LOOK_LR, true)
            DisableControlAction(0, controls.INPUT_LOOK_UD, true)
            DisableControlAction(0, controls.INPUT_VEH_MOUSE_CONTROL_OVERRIDE, true)
         end

         if disable.move then
            DisableControlAction(0, controls.INPUT_SPRINT, true)
            DisableControlAction(0, controls.INPUT_MOVE_LR, true)
            DisableControlAction(0, controls.INPUT_MOVE_UD, true)
            DisableControlAction(0, controls.INPUT_DUCK, true)
         end

         if disable.sprint and not disable.move then
            DisableControlAction(0, controls.INPUT_SPRINT, true)
         end

         if disable.car then
            DisableControlAction(0, controls.INPUT_VEH_MOVE_LEFT_ONLY, true)
            DisableControlAction(0, controls.INPUT_VEH_MOVE_RIGHT_ONLY, true)
            DisableControlAction(0, controls.INPUT_VEH_ACCELERATE, true)
            DisableControlAction(0, controls.INPUT_VEH_BRAKE, true)
            DisableControlAction(0, controls.INPUT_VEH_EXIT, true)
         end

         if disable.combat then
            DisableControlAction(0, controls.INPUT_AIM, true)
            DisablePlayerFiring(cache.playerId, true)
         end
      end

      if interruptProgress(data) then
         progress = false
      end

      Citizen.Wait(0)
   end

   if anim then
      if anim.dict then
         StopAnimTask(vx.cache.ped, anim.dict, anim.clip, 1.0)
         Citizen.Wait(0)
      else
         ClearPedTasks(vx.cache.ped)
      end
   end

   LocalPlayer.state.invBusy = false
   local duration = progress ~= false and GetGameTimer() - startTime + 100
   if progress == false or duration <= data.duration then
      SendNUIMessage({
         action = "progressCancel"
      })
      return false
   end

   return true
end

RegisterCommand("vx_cancelProgress", function()
   if progress?.canCancel then
      progress = false
   end
end)

RegisterKeyMapping("vx_cancelProgress", "Cancel Progress", "keyboard", "x")

---@param data VxProgressCircleProps
function vx.progressCircle(data)
   while progres ~= nil do
      Citizen.Wait(0)
   end

   if not interruptProgress(data) then
      SendNUIMessage({
         action = "progressCircle",
         data = {
            duration = data.duration,
            label = data.label,
         }
      })

      return startProgress(data)
   end
end

RegisterNUICallback("progressComplete", function(_, cb)
   cb({})
   progress = nil
end)
