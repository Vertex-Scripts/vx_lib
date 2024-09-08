fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Vertex Scripts"
version "1.2.0"

server_scripts {
   "resource/**/server.lua"
}

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

   "bridge/**/client.lua",

   "init.lua",
}
