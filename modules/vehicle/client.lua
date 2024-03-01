vx.vehicle = {}

---@param vehicle number
function vx.vehicle.getProperties(vehicle)
   if not DoesEntityExist(vehicle) then
      return
   end

   local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
   local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
   local hasCustomPrimaryColor = GetIsVehiclePrimaryColourCustom(vehicle)
   local dashboardColor = GetVehicleDashboardColor(vehicle)
   local interiorColor = GetVehicleInteriorColour(vehicle)
   local customPrimaryColor = nil
   if hasCustomPrimaryColor then
      customPrimaryColor = { GetVehicleCustomPrimaryColour(vehicle) }
   end

   local hasCustomXenonColor, customXenonColorR, customXenonColorG, customXenonColorB = GetVehicleXenonLightsCustomColor(
      vehicle)
   local customXenonColor = nil
   if hasCustomXenonColor then
      customXenonColor = { customXenonColorR, customXenonColorG, customXenonColorB }
   end

   local hasCustomSecondaryColor = GetIsVehicleSecondaryColourCustom(vehicle)
   local customSecondaryColor = nil
   if hasCustomSecondaryColor then
      customSecondaryColor = { GetVehicleCustomSecondaryColour(vehicle) }
   end

   local extras = {}
   for extraId = 0, 20 do
      if DoesExtraExist(vehicle, extraId) then
         extras[tostring(extraId)] = IsVehicleExtraTurnedOn(vehicle, extraId)
      end
   end

   local doorsBroken, windowsBroken, tyreBurst = {}, {}, {}
   local numWheels = tostring(GetVehicleNumberOfWheels(vehicle))

   local TyresIndex = {          -- Wheel index list according to the number of vehicle wheels.
      ['2'] = { 0, 4 },          -- Bike and cycle.
      ['3'] = { 0, 1, 4, 5 },    -- Vehicle with 3 wheels (get for wheels because some 3 wheels vehicles have 2 wheels on front and one rear or the reverse).
      ['4'] = { 0, 1, 4, 5 },    -- Vehicle with 4 wheels.
      ['6'] = { 0, 1, 2, 3, 4, 5 } -- Vehicle with 6 wheels.
   }

   if TyresIndex[numWheels] then
      for _, idx in pairs(TyresIndex[numWheels]) do
         tyreBurst[tostring(idx)] = IsVehicleTyreBurst(vehicle, idx, false)
      end
   end

   for windowId = 0, 7 do           -- 13
      RollUpWindow(vehicle, windowId) --fix when you put the car away with the window down
      windowsBroken[tostring(windowId)] = not IsVehicleWindowIntact(vehicle, windowId)
   end

   local numDoors = GetNumberOfVehicleDoors(vehicle)
   if numDoors and numDoors > 0 then
      for doorsId = 0, numDoors do
         doorsBroken[tostring(doorsId)] = IsVehicleDoorDamaged(vehicle, doorsId)
      end
   end

   return {
      model = GetEntityModel(vehicle),
      doorsBroken = doorsBroken,
      windowsBroken = windowsBroken,
      tyreBurst = tyreBurst,
      tyresCanBurst = GetVehicleTyresCanBurst(vehicle),
      plate = vx.math.trim(GetVehicleNumberPlateText(vehicle)),
      plateIndex = GetVehicleNumberPlateTextIndex(vehicle),

      bodyHealth = vx.math.round(GetVehicleBodyHealth(vehicle), 1),
      engineHealth = vx.math.round(GetVehicleEngineHealth(vehicle), 1),
      tankHealth = vx.math.round(GetVehiclePetrolTankHealth(vehicle), 1),

      fuelLevel = vx.math.round(GetVehicleFuelLevel(vehicle), 1),
      dirtLevel = vx.math.round(GetVehicleDirtLevel(vehicle), 1),

      color1 = colorPrimary,
      color2 = colorSecondary,
      customPrimaryColor = customPrimaryColor,
      customSecondaryColor = customSecondaryColor,

      pearlescentColor = pearlescentColor,
      wheelColor = wheelColor,

      dashboardColor = dashboardColor,
      interiorColor = interiorColor,

      wheels = GetVehicleWheelType(vehicle),
      windowTint = GetVehicleWindowTint(vehicle),
      xenonColor = GetVehicleXenonLightsColor(vehicle),
      customXenonColor = customXenonColor,

      neonEnabled = { IsVehicleNeonLightEnabled(vehicle, 0), IsVehicleNeonLightEnabled(vehicle, 1),
         IsVehicleNeonLightEnabled(vehicle, 2), IsVehicleNeonLightEnabled(vehicle, 3) },

      neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
      extras = extras,
      tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),

      modSpoilers = GetVehicleMod(vehicle, 0),
      modFrontBumper = GetVehicleMod(vehicle, 1),
      modRearBumper = GetVehicleMod(vehicle, 2),
      modSideSkirt = GetVehicleMod(vehicle, 3),
      modExhaust = GetVehicleMod(vehicle, 4),
      modFrame = GetVehicleMod(vehicle, 5),
      modGrille = GetVehicleMod(vehicle, 6),
      modHood = GetVehicleMod(vehicle, 7),
      modFender = GetVehicleMod(vehicle, 8),
      modRightFender = GetVehicleMod(vehicle, 9),
      modRoof = GetVehicleMod(vehicle, 10),
      modRoofLivery = GetVehicleRoofLivery(vehicle),

      modEngine = GetVehicleMod(vehicle, 11),
      modBrakes = GetVehicleMod(vehicle, 12),
      modTransmission = GetVehicleMod(vehicle, 13),
      modHorns = GetVehicleMod(vehicle, 14),
      modSuspension = GetVehicleMod(vehicle, 15),
      modArmor = GetVehicleMod(vehicle, 16),

      modTurbo = IsToggleModOn(vehicle, 18),
      modSmokeEnabled = IsToggleModOn(vehicle, 20),
      modXenon = IsToggleModOn(vehicle, 22),

      modFrontWheels = GetVehicleMod(vehicle, 23),
      modCustomFrontWheels = GetVehicleModVariation(vehicle, 23),
      modBackWheels = GetVehicleMod(vehicle, 24),
      modCustomBackWheels = GetVehicleModVariation(vehicle, 24),

      modPlateHolder = GetVehicleMod(vehicle, 25),
      modVanityPlate = GetVehicleMod(vehicle, 26),
      modTrimA = GetVehicleMod(vehicle, 27),
      modOrnaments = GetVehicleMod(vehicle, 28),
      modDashboard = GetVehicleMod(vehicle, 29),
      modDial = GetVehicleMod(vehicle, 30),
      modDoorSpeaker = GetVehicleMod(vehicle, 31),
      modSeats = GetVehicleMod(vehicle, 32),
      modSteeringWheel = GetVehicleMod(vehicle, 33),
      modShifterLeavers = GetVehicleMod(vehicle, 34),
      modAPlate = GetVehicleMod(vehicle, 35),
      modSpeakers = GetVehicleMod(vehicle, 36),
      modTrunk = GetVehicleMod(vehicle, 37),
      modHydrolic = GetVehicleMod(vehicle, 38),
      modEngineBlock = GetVehicleMod(vehicle, 39),
      modAirFilter = GetVehicleMod(vehicle, 40),
      modStruts = GetVehicleMod(vehicle, 41),
      modArchCover = GetVehicleMod(vehicle, 42),
      modAerials = GetVehicleMod(vehicle, 43),
      modTrimB = GetVehicleMod(vehicle, 44),
      modTank = GetVehicleMod(vehicle, 45),
      modWindows = GetVehicleMod(vehicle, 46),
      modLivery = GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) or GetVehicleMod(vehicle, 48),
      modLightbar = GetVehicleMod(vehicle, 49)
   }
end

return vx.vehicle
