--[[
	LSP setup script for default capibilities
--]]
local fn = vim.fn

-- {{{ on_attach config
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- {{{ Mappings.
	local opts = { noremap = true, silent = true }
	buf_set_keymap('n', '<space>LgD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', '<space>Lgd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', '<space>Lgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', '<space>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>Lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>Lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>Lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<space>LR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>Lh', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', '<space>Ll', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	-- }}}

	-- {{{ Set some keybinds conditional on server capabilities
	if client.server_capabilities.document_formatting then
		buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
	elseif client.server_capabilities.document_range_formatting then
		buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
	end
	-- }}}

	-- {{{ Set autocommands conditional on server_capabilities
	if client.server_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
                augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
            ]],
			false
		)
	end
-- }}}

    -- Attach navic
    require('nvim-navic').attach(client, bufnr)

    -- Notify the user that the server has been started
    -- vim.notify(' LSP -> attached ' .. client.name, 'INFO')
end
-- }}}

-- {{{ standard paths for lsp servers

-- check if lspservers directory exists in data stdpath
-- and create one if not
local lspserver_dir = fn.isdirectory(fn.stdpath('data') .. '/lspservers')
if lspserver_dir == 0 then
	fn.mkdir(fn.stdpath('data') .. '/lspservers')
end

-- }}}

return { on_attach = on_attach, lspserver_dir = lspserver_dir }

-- # vim foldmethod=marker
