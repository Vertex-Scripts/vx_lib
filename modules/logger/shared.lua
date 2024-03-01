local levels = {
   "^1[ERROR]",
   "^3[WARN]",
   "^7[INFO]",
   "^6[DEBUG]",
}

local function replaceFunctions(table)
   local result = {}
   for k, v in pairs(table) do
      local type = type(v)
      if type == "table" then
         result[k] = replaceFunctions(v)
         cfx.logger.info(result[k])
      elseif type == "function" then
         result[k] = "function"
      else
         result[k] = tostring(v)
      end
   end

   return result
end

local function log(level, ...)
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

cfx.logger = {
   error = function(...) log(1, ...) end,
   warn = function(...) log(2, ...) end,
   info = function(...) log(3, ...) end,
   debug = function(...) log(4, ...) end,
}

return cfx.logger
