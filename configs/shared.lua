-- You can't use the config like this in modules, use `cfx.config` for that

---@type SharedConfig
SharedConfig = {
   debug = true,                  -- Don't touch
   logLevel = 3,                  -- Don't touch

   primaryIdentifier = "license", -- 'license' | 'steam' | 'discord' | 'fivem'

   framework = "auto",            -- 'ESX' | 'QB' | 'auto'
   target = "auto",               -- 'ox_target' | 'qb_target' | 'qtarget' | 'auto'
   inventory = "auto",            -- 'ox_inventory' | 'qb-inventory' | 'es_extended' | 'qs-inventory' | 'auto'
}
