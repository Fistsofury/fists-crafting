fx_version "adamant"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game "rdr3"
lua54 'yes'
version '1.0.0'
author 'Fistsofury'
description 'XP Crafting script for VORP'

client_scripts {
    'client/helpers/functions.lua',
    'client/client.lua',
    'client/menu/*.lua'
}

shared_scripts {
    'config.lua',
    'fists-background.png'
}

server_scripts {
	'server/server.lua'
}