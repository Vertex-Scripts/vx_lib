---@param ped number
function vx.freezePed(ped)
   if not DoesEntityExist(ped) then
      return
   end

   SetEntityInvincible(ped, true)
   SetEntityHasGravity(ped, true)
   SetEntityCollision(ped, true, true)
   SetPedCanRagdoll(ped, false)
   SetEntityCanBeDamaged(ped, false)
   FreezeEntityPosition(ped, true)
   TaskSetBlockingOfNonTemporaryEvents(ped, true)
end

return vx.freezePed
