fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Vertex Scripts"
version "1.2.1"

server_scripts {
   "resource/**/server.lua",
   "resource/**/server/*.lua"
}

client_scripts {
   "resource/**/client.lua",
   "resource/**/client/*.lua"
}

shared_scripts {
   "loader.lua",
   "resource/init.lua",
   "resource/**/shared.lua"
}

files {
   "modules/**/client.lua",
   "modules/**/shared.lua",

   "bridge/**/client.lua",

   "loader.lua",
   "init.lua",
}
