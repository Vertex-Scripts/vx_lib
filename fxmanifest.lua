fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Vertex Scripts"
version "1.0.0"

shared_scripts {
   "configs/*.lua",
   "resource/init.lua",
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
