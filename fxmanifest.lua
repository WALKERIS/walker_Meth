shared_script '@FGM/ai_module_fg-obfuscated.lua'
shared_script '@FGM/shared_fg-obfuscated.lua'
fx_version 'bodacious'
lua54 'yes' 
game 'gta5'
author 'WALKER'
discription 'TEST PROJECT MADE FOR VISION RP| BY WALKER| NO UPDATES PROMISED'
version '1.0'

client_script "client/client.lua"



server_script {
            "server/server.lua"
}


shared_scripts {
    '@ox_lib/init.lua',
}