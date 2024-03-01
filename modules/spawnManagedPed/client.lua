local peds = {}

---@param type number
---@param model string|number
---@param coords vector3
---@param heading number
---@param isNetwork? boolean
---@param bScriptHostPed? boolean
function cfx.spawnManagedPed(type, model, coords, heading, isNetwork, bScriptHostPed)
	local ped = cfx.spawnPed(type, model, coords, heading, isNetwork, bScriptHostPed)
	table.insert(peds, ped)

	return ped
end

AddEventHandler('onResourceStop', function(resource)
	if resource ~= cfx.cache.resource then
		return
	end

	for _, ped in ipairs(peds) do
		if DoesEntityExist(ped) then
			DeleteEntity(ped)
		end
	end
end)

return cfx.spawnManagedPed
