fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Pedy#9084'

version '1.0.0'

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua'
}

dependencies {
	'ox_lib'
}

escrow_ignore {
	'config.lua'
  }

data_file 'DLC_ITYP_REQUEST' 'stream/jsd_prop_pumpkin.ytyp'
