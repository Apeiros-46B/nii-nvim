-- lazy loading
-- from NvChad
local M = {}

-- require('packer').loader(tbl.plugins)
-- this must be used for plugins that need to be loaded just after a file
-- e.g. treesitter, lspconfig etc
M.lazy_load = function(tbl)
    vim.api.nvim_create_autocmd(tbl.events, {
        group = vim.api.nvim_create_augroup(tbl.augroup_name, {}),
        callback = function()
            if tbl.condition() then
                vim.api.nvim_del_augroup_by_name(tbl.augroup_name)

                -- don't defer for treesitter as it will show slow highlighting
                -- this deferring only happens only when we do 'nvim filename'
                if tbl.plugin ~= 'nvim-treesitter' then
                    vim.defer_fn(function()
                        require('packer').loader(tbl.plugin)
                        if tbl.plugin == 'nvim-lspconfig' then
                            vim.cmd 'silent! do FileType'
                        end
                    end, 0)
                else
                    require('packer').loader(tbl.plugin)
                end
            end
        end,
    })
end

-- load certain plugins only when there's a file opened in the buffer
-- if 'nvim filename' is executed -> load the plugin after nvim gui loads
-- this gives an instant preview of nvim with the file opened
M.on_file_open = function(plugin_name)
    M.lazy_load {
        events = { 'BufRead', 'BufWinEnter', 'BufNewFile' },
        augroup_name = 'BeLazyOnFileOpen' .. plugin_name,
        plugin = plugin_name,
        condition = function()
            local file = vim.fn.expand '%'
            return file ~= 'NvimTree_1' and file ~= '[packer]' and file ~= ''
        end,
    }
end

M.gitsigns = function()
    vim.api.nvim_create_autocmd({ 'BufRead' }, {
        group = vim.api.nvim_create_augroup('GitSignsLazyLoad', { clear = true }),
        callback = function()
            vim.fn.system('git -C ' .. vim.fn.expand '%:p:h' .. ' rev-parse')
            if vim.v.shell_error == 0 then
                vim.api.nvim_del_augroup_by_name('GitSignsLazyLoad')
                vim.schedule(function()
                    require('packer').loader('gitsigns.nvim')
                end)
            end
        end,
    })
end

M.packer_cmds = {
    'PackerSnapshot',
    'PackerSnapshotRollback',
    'PackerSnapshotDelete',
    'PackerInstall',
    'PackerUpdate',
    'PackerSync',
    'PackerClean',
    'PackerCompile',
    'PackerStatus',
    'PackerProfile',
    'PackerLoad',
}

M.treesitter_cmds = {
    'TSInstall',
    'TSBufEnable',
    'TSBufDisable',
    'TSEnable',
    'TSDisable',
    'TSModuleInfo'
}

M.hop_cmds = {
    'HopWord',
    'HopWordBC',
    'HopWordAC',
    'HopPattern',
    'HopPatternBC',
    'HopPatternAC',
    'HopChar1',
    'HopChar1BC',
    'HopChar1AC',
    'HopChar2',
    'HopChar2BC',
    'HopChar2AC',
    'HopLine',
    'HopLineBC',
    'HopLineAC',
    'HopLineStart',
    'HopLineStartBC',
    'HopLineStartAC',
    'HopChar1Line',
    'HopChar1LineAC',
    'HopChar1LineBC',
}

return M
