--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright (c) 2025 Linden <https://github.com/thelindat/fivem>
]]

local logLevels = {
   error = 1,
   warn = 2,
   info = 3,
   verbose = 4,
   debug = 5,
}

local levels = {
   "^7[^1ERROR^7]",
   "^7[^3WARN^7]",
   "^7[^2INFO^7]",
   '^7[^4VERBOSE^7]',
   "^7[^6DEBUG^7]",
}

local logLevel = logLevels[GetConvar("vx:logLevel", "info")] or logLevels.info

local function handleException(reason, value)
   if type(value) == "function" then
      return tostring(value)
   end

   return reason
end

local function log(level, ...)
   if level > logLevel then
      return
   end

   local args = { ... }
   for i = 1, #args do
      local arg = args[i]
      args[i] = type(arg) == "table" and
          json.encode(arg, { sort_keys = true, indent = true, exception = handleException }) or tostring(arg)
   end
   print(("^8%s ^7%s^7"):format(levels[level], table.concat(args, " ")))
end

vx.print = {
   error = function(...) log(1, ...) end,
   warn = function(...) log(2, ...) end,
   info = function(...) log(3, ...) end,
   verbose = function(...) log(4, ...) end,
   debug = function(...) log(5, ...) end,
}

return vx.print
