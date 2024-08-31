fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Vertex Scripts"
version "1.1.0"

client_scripts {
   "resource/**/client.lua"
}

shared_scripts {
   "resource/init.lua",
   "resource/**/shared.lua"
}

files {
   "modules/**/client.lua",
   "modules/**/shared.lua",

   "wrappers/**/client.lua",

   "init.lua",
}
