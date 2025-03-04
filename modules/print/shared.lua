local logLevels = {
   error = 1,
   warn = 2,
   info = 3,
   verbose = 4,
   debug = 5,
}

local levels = {
   "^1[ERROR]",
   "^3[WARN]",
   "^2[INFO]",
   '^4[VERBOSE]',
   "^6[DEBUG]",
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
