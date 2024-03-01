fx_version "cerulean"
game "gta5"
lua54 "yes"

author "CFX Store"
version "1.0.0"

server_scripts {
   -- "modules/**/server.lua",
   -- "wrappers/**/server.lua"
}

client_scripts {
   -- "modules/**/client.lua",
   -- "wrappers/**/client.lua"
}

shared_scripts {
   "configs/*.lua",
   "resource/init.lua",
   -- "modules/**/shared.lua",
}

files {
   "modules/**/client.lua",
   "modules/**/shared.lua",

   "wrappers/**/client.lua",
   "wrappers/**/shared.lua",

   "configs/client.lua",
   "configs/shared.lua",

   "init.lua",
}
