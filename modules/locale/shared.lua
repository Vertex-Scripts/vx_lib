local fallbackLocale = "en"
local defaultLocale = GetConvar("vx:locale", fallbackLocale)
local dict = {}

---@overload fun(key: string, ...: string | number)
vx.locale = setmetatable({}, {
   __call = function(_, key, ...)
      local str = dict[key]
      if str then
         if ... then
            return str:format(...)
         end
      end

      return str
   end
})

local function loadLocale(locale)
   local file = LoadResourceFile(vx.cache.resource, ("locales/%s.json"):format(locale))
   if not file then
      warn(("could not load 'locales/%s.json'"):format(locale))
      if locale ~= fallbackLocale then
         return loadLocale(fallbackLocale)
      end
   end

   return json.decode(file) or {}
end

function vx.locale.load(key)
   key = key or defaultLocale

   local locales = loadLocale(key)
   table.wipe(dict)

   for k, v in pairs(locales) do
      for var in v:gmatch('${[%w%s%p]-}') do
         local locale = locales[var:sub(3, -2)]

         if locale then
            locale = locale:gsub('%%', '%%%%')
            v = v:gsub(var, locale)
         end
      end

      dict[k] = v
   end
end

return vx.locale
