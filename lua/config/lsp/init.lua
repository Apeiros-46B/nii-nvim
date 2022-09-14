local setup = require('config.lsp.setup')

return {
    -- We don't setup the java lsp here, that happens in an ftplugin
	require('config.lsp.lua_lsp')(setup.on_attach),
    require('config.lsp.python_lsp')(setup.on_attach),
	require('config.lsp.rust_lsp')(setup.on_attach),
}
