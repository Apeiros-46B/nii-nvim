--[[
This init file loads all of the plugin configuration files
--]]

return {
    -- original nii-nvim plugins
    require('config.plug.hop'),
    require('config.plug.cmp'),
    require('config.plug.lualine'),
    require('config.plug.lspkind'),
    -- require('config.plug.tabline'),
    require('config.plug.nvimtree'),
    require('config.plug.gitsigns'),
    require('config.plug.ultisnips'),
    -- require('config.plug.dashboard'),
    require('config.plug.autopairs'),
    require('config.plug.telescope'),
    require('config.plug.which-key'),
    require('config.plug.nvimcomment'),
    require('config.plug.nvimcolorizer'),
    require('config.plug.treesitter'),

    -- plugins added by me
    require('config.plug.hexokinase'),
    require('config.plug.fugitive'),
    require('config.plug.lspsaga'),
    require('config.plug.navic'),
    require('config.plug.neorg'),
    -- require('config.plug.notify'),
    require('config.plug.mini'),
    require('config.plug.presence'),
}

-- # vim foldmethod=marker
