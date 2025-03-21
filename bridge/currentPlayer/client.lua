vx.currentPlayer = {}

function vx.currentPlayer.isLoaded()
   if ESX then
      return ESX.GetPlayerData()?.identifier ~= nil
   elseif QBCore then
      return QBCore.Functions.GetPlayerData()?.citizenid ~= nil
   end
end

function vx.currentPlayer.waitForLoaded(cb)
   Citizen.CreateThread(function()
      while not vx.currentPlayer.isLoaded() do
         Citizen.Wait(100)
      end

      cb()
   end)
end

function vx.currentPlayer.getFirstName()
   if ESX then
      local playerData = ESX.GetPlayerData()
      return playerData.firstName
   elseif QBCore then
      local playerData = QBCore.Functions.GetPlayerData()
      return playerData.charinfo?.firstname
   end
end

function vx.currentPlayer.getLastName()
   if ESX then
      local playerData = ESX.GetPlayerData()
      return playerData.lastName
   elseif QBCore then
      local playerData = QBCore.Functions.GetPlayerData()
      return playerData.charinfo?.lastname
   end
end

function vx.currentPlayer.getFullName()
   return ("%s %s"):format(vx.currentPlayer.getFirstName(), vx.currentPlayer.getLastName())
end

function vx.currentPlayer.getJob()
   if ESX then
      local playerData = ESX.GetPlayerData()
      return {
         name = playerData.job.name,
         label = playerData.job.label,
         grade = playerData.job.grade,
         grade_name = playerData.job.grade_name,
         grade_label = playerData.job.grade_label,
      }
   elseif QBCore then
      local playerData = QBCore.Functions.GetPlayerData()
      local job = playerData.job
      return {
         name = job.name,
         label = job.label,
         grade = job.grade,
         grade_name = job.grade_name,
         grade_label = job.grade_label,
      }
   end
end

return vx.currentPlayer
