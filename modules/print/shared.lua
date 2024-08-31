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

local function replaceFunctions(table)
   local result = {}
   for k, v in pairs(table) do
      local type = type(v)
      if type == "table" then
         result[k] = replaceFunctions(v)
      elseif type == "function" then
         result[k] = "function"
      else
         result[k] = tostring(v)
      end
   end

   return result
end

local function log(level, ...)
   if level > logLevel then
      return
   end

   local args = { ... }
   for i = 1, #args do
      local arg = args[i]
      if type(args[i]) == "table" then
         local res = replaceFunctions(args[i])
         args[i] = json.encode(res, {
            sort_keys = true,
            indent = true,
         })
      else
         args[i] = tostring(arg)
      end
   end

   print(("^8%s ^7%s^7"):format(levels[level], table.concat(args, " ")))
end

vx.print = {
   error = function(...) log(1, ...) end,
   warn = function(...) log(2, ...) end,
   info = function(...) log(3, ...) end,
   debug = function(...) log(4, ...) end,
}

return vx.print
