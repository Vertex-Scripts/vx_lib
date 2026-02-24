vx.discordApi = {}

local memoryCache = vx.memoryCache:new()

Citizen.CreateThread(function()
   serverEventBridge.playerLoaded()
end)

---@diagnostic disable-next-line: duplicate-set-field
function vx.discordApi.getMember()
   local member = serverCallbackBridge.getCurrentMember()
   return member
end

function vx.discordApi.getMemberRoles()
   local cacheKey = "discord_roles"
   local cachedRoles = memoryCache:get(cacheKey)
   if cachedRoles then
      return cachedRoles
   end

   local roles = serverCallbackBridge.getDiscordRoles()
   memoryCache:set(cacheKey, roles, 60 * 1000)

   return roles
end

---@diagnostic disable-next-line: duplicate-set-field
function vx.discordApi.hasRoleId(roleId)
   local member = serverCallbackBridge.getCurrentMember()
   if not member then return false end

   local hasRole = vx.array.fromTable(member.roles):contains(roleId)
   return hasRole
end
