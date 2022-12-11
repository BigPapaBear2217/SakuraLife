resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'by kermo.designs'

version '1.0.4'

client_scripts {
	'@es_extended/client/wrapper.lua',
	'client/main.lua',

}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/js/*.js',
	'html/fonts/*.ttf',
}

dependencies {
	'es_extended'
}

client_script "api-ac_MGMjpEJwTdpJ.lua"