fx_version 'adamant'
game 'gta5'

author 'lanx'
description 'Shops'
version '1.0.0'

client_scripts {'client.lua',
'@es_extended/locale.lua'
}
server_scripts {
    'server.lua',
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua'
}
files {
    'ui/index.html'
}

ui_page     'ui/index.html'

