---@diagnostic disable: param-type-mismatch
vx.vehicle = {}

---@param vehicle number
function vx.getVehicleProperties(vehicle)
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

   local TyresIndex = {            -- Wheel index list according to the number of vehicle wheels.
      ['2'] = { 0, 4 },            -- Bike and cycle.
      ['3'] = { 0, 1, 4, 5 },      -- Vehicle with 3 wheels (get for wheels because some 3 wheels vehicles have 2 wheels on front and one rear or the reverse).
      ['4'] = { 0, 1, 4, 5 },      -- Vehicle with 4 wheels.
      ['6'] = { 0, 1, 2, 3, 4, 5 } -- Vehicle with 6 wheels.
   }

   if TyresIndex[numWheels] then
      for _, idx in pairs(TyresIndex[numWheels]) do
         tyreBurst[tostring(idx)] = IsVehicleTyreBurst(vehicle, idx, false)
      end
   end

   for windowId = 0, 7 do             -- 13
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

function vx.setVehicleProperties(vehicle, props)
   if not DoesEntityExist(vehicle) then
      return
   end

   local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
   local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
   SetVehicleModKit(vehicle, 0)

   if props.tyresCanBurst ~= nil then
      SetVehicleTyresCanBurst(vehicle, props.tyresCanBurst)
   end

   if props.plate ~= nil then
      SetVehicleNumberPlateText(vehicle, props.plate)
   end
   if props.plateIndex ~= nil then
      SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
   end
   if props.bodyHealth ~= nil then
      SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
   end
   if props.engineHealth ~= nil then
      SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
   end
   if props.tankHealth ~= nil then
      SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0)
   end
   if props.fuelLevel ~= nil then
      SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
   end
   if props.dirtLevel ~= nil then
      SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
   end
   if props.customPrimaryColor ~= nil then
      SetVehicleCustomPrimaryColour(vehicle, props.customPrimaryColor[1], props.customPrimaryColor[2],
         props.customPrimaryColor[3])
   end
   if props.customSecondaryColor ~= nil then
      SetVehicleCustomSecondaryColour(vehicle, props.customSecondaryColor[1], props.customSecondaryColor[2],
         props.customSecondaryColor[3])
   end
   if props.color1 ~= nil then
      SetVehicleColours(vehicle, props.color1, colorSecondary)
   end
   if props.color2 ~= nil then
      SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2)
   end
   if props.pearlescentColor ~= nil then
      SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
   end

   if props.interiorColor ~= nil then
      SetVehicleInteriorColor(vehicle, props.interiorColor)
   end

   if props.dashboardColor ~= nil then
      SetVehicleDashboardColor(vehicle, props.dashboardColor)
   end

   if props.wheelColor ~= nil then
      SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
   end
   if props.wheels ~= nil then
      SetVehicleWheelType(vehicle, props.wheels)
   end
   if props.windowTint ~= nil then
      SetVehicleWindowTint(vehicle, props.windowTint)
   end

   if props.neonEnabled ~= nil then
      SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
      SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
      SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
      SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
   end

   if props.extras ~= nil then
      for extraId, enabled in pairs(props.extras) do
         SetVehicleExtra(vehicle, tonumber(extraId), enabled and 0 or 1)
      end
   end

   if props.neonColor ~= nil then
      SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
   end
   if props.xenonColor ~= nil then
      SetVehicleXenonLightsColor(vehicle, props.xenonColor)
   end
   if props.customXenonColor ~= nil then
      SetVehicleXenonLightsCustomColor(vehicle, props.customXenonColor[1], props.customXenonColor[2],
         props.customXenonColor[3])
   end
   if props.modSmokeEnabled ~= nil then
      ToggleVehicleMod(vehicle, 20, true)
   end
   if props.tyreSmokeColor ~= nil then
      SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
   end
   if props.modSpoilers ~= nil then
      SetVehicleMod(vehicle, 0, props.modSpoilers, false)
   end
   if props.modFrontBumper ~= nil then
      SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
   end
   if props.modRearBumper ~= nil then
      SetVehicleMod(vehicle, 2, props.modRearBumper, false)
   end
   if props.modSideSkirt ~= nil then
      SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
   end
   if props.modExhaust ~= nil then
      SetVehicleMod(vehicle, 4, props.modExhaust, false)
   end
   if props.modFrame ~= nil then
      SetVehicleMod(vehicle, 5, props.modFrame, false)
   end
   if props.modGrille ~= nil then
      SetVehicleMod(vehicle, 6, props.modGrille, false)
   end
   if props.modHood ~= nil then
      SetVehicleMod(vehicle, 7, props.modHood, false)
   end
   if props.modFender ~= nil then
      SetVehicleMod(vehicle, 8, props.modFender, false)
   end
   if props.modRightFender ~= nil then
      SetVehicleMod(vehicle, 9, props.modRightFender, false)
   end
   if props.modRoof ~= nil then
      SetVehicleMod(vehicle, 10, props.modRoof, false)
   end

   if props.modRoofLivery ~= nil then
      SetVehicleRoofLivery(vehicle, props.modRoofLivery)
   end

   if props.modEngine ~= nil then
      SetVehicleMod(vehicle, 11, props.modEngine, false)
   end
   if props.modBrakes ~= nil then
      SetVehicleMod(vehicle, 12, props.modBrakes, false)
   end
   if props.modTransmission ~= nil then
      SetVehicleMod(vehicle, 13, props.modTransmission, false)
   end
   if props.modHorns ~= nil then
      SetVehicleMod(vehicle, 14, props.modHorns, false)
   end
   if props.modSuspension ~= nil then
      SetVehicleMod(vehicle, 15, props.modSuspension, false)
   end
   if props.modArmor ~= nil then
      SetVehicleMod(vehicle, 16, props.modArmor, false)
   end
   if props.modTurbo ~= nil then
      ToggleVehicleMod(vehicle, 18, props.modTurbo)
   end
   if props.modXenon ~= nil then
      ToggleVehicleMod(vehicle, 22, props.modXenon)
   end
   if props.modFrontWheels ~= nil then
      SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomFrontWheels)
   end
   if props.modBackWheels ~= nil then
      SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomBackWheels)
   end
   if props.modPlateHolder ~= nil then
      SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
   end
   if props.modVanityPlate ~= nil then
      SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
   end
   if props.modTrimA ~= nil then
      SetVehicleMod(vehicle, 27, props.modTrimA, false)
   end
   if props.modOrnaments ~= nil then
      SetVehicleMod(vehicle, 28, props.modOrnaments, false)
   end
   if props.modDashboard ~= nil then
      SetVehicleMod(vehicle, 29, props.modDashboard, false)
   end
   if props.modDial ~= nil then
      SetVehicleMod(vehicle, 30, props.modDial, false)
   end
   if props.modDoorSpeaker ~= nil then
      SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
   end
   if props.modSeats ~= nil then
      SetVehicleMod(vehicle, 32, props.modSeats, false)
   end
   if props.modSteeringWheel ~= nil then
      SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
   end
   if props.modShifterLeavers ~= nil then
      SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
   end
   if props.modAPlate ~= nil then
      SetVehicleMod(vehicle, 35, props.modAPlate, false)
   end
   if props.modSpeakers ~= nil then
      SetVehicleMod(vehicle, 36, props.modSpeakers, false)
   end
   if props.modTrunk ~= nil then
      SetVehicleMod(vehicle, 37, props.modTrunk, false)
   end
   if props.modHydrolic ~= nil then
      SetVehicleMod(vehicle, 38, props.modHydrolic, false)
   end
   if props.modEngineBlock ~= nil then
      SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
   end
   if props.modAirFilter ~= nil then
      SetVehicleMod(vehicle, 40, props.modAirFilter, false)
   end
   if props.modStruts ~= nil then
      SetVehicleMod(vehicle, 41, props.modStruts, false)
   end
   if props.modArchCover ~= nil then
      SetVehicleMod(vehicle, 42, props.modArchCover, false)
   end
   if props.modAerials ~= nil then
      SetVehicleMod(vehicle, 43, props.modAerials, false)
   end
   if props.modTrimB ~= nil then
      SetVehicleMod(vehicle, 44, props.modTrimB, false)
   end
   if props.modTank ~= nil then
      SetVehicleMod(vehicle, 45, props.modTank, false)
   end
   if props.modWindows ~= nil then
      SetVehicleMod(vehicle, 46, props.modWindows, false)
   end

   if props.modLivery ~= nil then
      SetVehicleMod(vehicle, 48, props.modLivery, false)
      SetVehicleLivery(vehicle, props.modLivery)
   end

   if props.windowsBroken ~= nil then
      for k, v in pairs(props.windowsBroken) do
         if v then
            RemoveVehicleWindow(vehicle, tonumber(k))
         end
      end
   end

   if props.doorsBroken ~= nil then
      for k, v in pairs(props.doorsBroken) do
         if v then
            SetVehicleDoorBroken(vehicle, tonumber(k), true)
         end
      end
   end

   if props.tyreBurst ~= nil then
      for k, v in pairs(props.tyreBurst) do
         if v then
            SetVehicleTyreBurst(vehicle, tonumber(k), true, 1000.0)
         end
      end
   end
end
