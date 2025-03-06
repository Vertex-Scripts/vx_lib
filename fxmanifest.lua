fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Vertex Scripts"
version "2.1.1"

ui_page "web/dist/index.html"

server_scripts {
   "config.server.lua",
   "resource/**/server.lua",
   "resource/**/server/*.lua"
}

client_scripts {
   "resource/**/client.lua",
   "resource/**/client/*.lua"
}

shared_scripts {
   "loader.lua",
   "config.shared.lua",
   "resource/init.lua",
   "resource/**/shared.lua",
}

files {
   "web/dist/index.html",
   "web/dist/**/*",

   "modules/**/client.lua",
   "modules/**/shared.lua",

   "bridge/**/client.lua",

   "loader.lua",
   "init.lua",
}
