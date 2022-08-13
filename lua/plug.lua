-- {{{ bootstrapping
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end
-- }}}

-- {{{ packer
local packer = require('packer')
packer.startup({
	function(use)
		-- packer self management
		use('wbthomason/packer.nvim')

		-- {{{ lsp/autocompletion/snippets
		-- lsp plugins
		use({ 'neovim/nvim-lspconfig', commit = '9278dfb' })
		use({ 'onsails/lspkind-nvim', commit = '57e5b5d' })

        -- language servers
        use({ 'mfussenegger/nvim-jdtls', commit = '3a148da' })
        use({ 'simrat39/rust-tools.nvim', commit = '11dcd67' })

        -- debugging
        use({ 'mfussenegger/nvim-dap', commit = '3b5e4b7' })

		-- autocompletion
		use({
			'hrsh7th/nvim-cmp',
			requires = {
				{ 'hrsh7th/cmp-nvim-lsp', commit = 'ebdfc20' },
				{ 'hrsh7th/cmp-path', commit = '466b6b8' },
				{ 'hrsh7th/cmp-buffer', commit = 'd66c4c2' },
			},
			commit = '2aa7eee',
		})

        use({ 'petertriho/cmp-git', requires = 'nvim-lua/plenary.nvim', commit = '60e3de6' })

		-- snippets
		use({ 'sirver/ultisnips', commit = '5fc4862' })
		use({ 'quangnguyen30192/cmp-nvim-ultisnips', commit = 'c6ace8c' })

        -- lsp-related utils
        use({ 'folke/lsp-colors.nvim', commit = '517fe3a' })
        use({ 'glepnir/lspsaga.nvim', commit = '9d36a7a' })
        use({ 'SmiteshP/nvim-navic', commit = '94bf6fc' })
        use({ 'folke/trouble.nvim', requires = 'kyazdani42/nvim-web-devicons', commit = 'da61737' })
		-- }}}

		-- {{{ utility plugins
		-- status line
		use({
            'nvim-lualine/lualine.nvim', requires = {
                'kyazdani42/nvim-web-devicons',
                opt = true
            },
            commit = '18a07f7'
        })

        -- tabline
		-- use({ 'kdheepak/tabline.nvim', commit = 'b080ed3' })

        -- fuzzy finder
		use({
            'nvim-telescope/telescope.nvim',
            requires = {
                { 'nvim-lua/popup.nvim', commit = 'b7404d3' },
                { 'nvim-lua/plenary.nvim', commit = '9069d14' }
            },
            commit = 'b5833a6'
        })

        -- other
		use({ 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons', commit = '0f0f858' })
		use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', commit = '8ec164b' })
		use({ 'windwp/nvim-autopairs', commit = '38d486a' })
		use({ 'terrortylor/nvim-comment', commit = '8619217' })
		use({ 'sbdchd/neoformat', commit = '06920fa' })
		use({ 'phaazon/hop.nvim', commit = 'e2f978b' })
        use({ 'jghauser/mkdir.nvim', commit = '0126165' })
        use({ 'folke/which-key.nvim', commit = 'a3c19ec' })
        use({ 'echasnovski/mini.nvim', commit = '5561844' })
        use({ 'itchyny/calendar.vim', commit = 'fe13024' })
        use({ 'famiu/nvim-reload', commit = '7c1ab3f' })
        use({ 'soywod/himalaya', commit = '0696f36', rtp = '/vim' })
		-- }}}

        -- {{{ git plugins
		use({ 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim', commit = '565b94d' } })
        use({ 'tpope/vim-fugitive', commit = '00cc238' })
        use({ 'tpope/vim-rhubarb', commit = 'f8b70f5' })
        -- }}}

        -- {{{ improved syntax plugins
        -- treesitter
		use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', commit = 'd810c38' })

        -- colors
        use({ 'rrethy/vim-hexokinase', run = 'make hexokinase', commit = '62324b4' })
		use({ 'norcalli/nvim-colorizer.lua', commit = '36c610a' })

        -- documents
        use({ 'nvim-neorg/neorg', requires = { 'nvim-lua/plenary.nvim', 'nvim-neorg/neorg-telescope' }, commit = '5dc942c' })
        use({ 'ellisonleao/glow.nvim', commit = '900042f'})
        use({ 'jbyuki/nabla.nvim', commit = '8bcec91' })
		-- }}}

		-- {{{ themes
		-- popular themes incoming
		use({'joshdick/onedark.vim'})
		use({'sickill/vim-monokai'})
		use({'morhetz/gruvbox'})
		use({'shaunsingh/nord.nvim'})
		use({'sainnhe/gruvbox-material'})

		-- neesh themes
		use({'sainnhe/everforest'}) -- best theme btw
		use({'relastle/bluewery.vim'})
		use({'haishanh/night-owl.vim'})
		-- }}}

        -- {{{ bootstrapping
        if packer_bootstrap then
            packer.sync()
        end
        -- }}}
	end,
    -- {{{ packer config
	config = {
		display = {
	        -- display packer dialogue in the center in a floating window
			open_fn = require('packer.util').float,
		},
	},
    -- }}}
})
-- }}}

-- {{{ other
-- workaround for plugins that need rtp (himalaya)
local packer_compiled = vim.fn.stdpath('config') .. '/plugin/packer_compiled.lua'
vim.cmd('luafile'  .. packer_compiled)
-- }}}

-- # vim foldmethod=marker
