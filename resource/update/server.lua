-- This function is to check if there is an update for vertexscripts.com
function vx.checkUpdate(resourceName)
   local response = vx.sendHttpRequest(("https://versions.vertexscripts.com/api/%s"):format(resourceName))
   if not response.ok then
      vx.print.error("Failed to check for updates.", response.errorText)
      return
   end

   local latestVersion = response.data.version
   local isUpdated = vx.checkDependency(resourceName, latestVersion)
   if not isUpdated then
      vx.print.info(("^2%s has an update available! (%s -> %s)^0"):format(resourceName,
         GetResourceMetadata(resourceName, "version", 0), latestVersion))
   end
end
