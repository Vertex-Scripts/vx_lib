function vx.requireMinimumVersion(resource, requiredVersion)
   local currentVersion = GetResourceMetadata(resource, "version", 0)
   currentVersion = currentVersion and currentVersion:match("%d+%.%d+%.%d+") or "unknown"

   if currentVersion == "unknown" then
      vx.print.error(("Resource '%s' version is unknown."):format(resource))
      return false
   end

   if currentVersion == requiredVersion then
      return true
   end

   local function splitVersion(ver)
      local parts = {}
      for part in string.gmatch(ver, "%d+") do
         parts[#parts + 1] = tonumber(part)
      end
      return parts
   end

   local cv = splitVersion(currentVersion)
   local rv = splitVersion(requiredVersion)

   for i = 1, math.max(#cv, #rv) do
      local current = cv[i] or 0
      local required = rv[i] or 0
      if current < required then
         vx.print.error(("^1%s requires version '%s' of '%s' (current version: %s)^0"):format(
            GetInvokingResource() or GetCurrentResourceName(), requiredVersion, resource, currentVersion))
         return false
      elseif current > required then
         break
      end
   end

   return false
end
