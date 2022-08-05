-- {{{ load scheme wrapper library
local scheme = require('lib.scheme')

-- initialize vars for schemes
local lualine_theme = nil

-- if a scheme is not bundled with lualine, look for a theme file
if scheme.is_lualine_default == false then
	lualine_theme = require('themes.lualine.' .. scheme.scheme)
else
	lualine_theme = scheme.scheme
end
-- }}}

-- {{{ custom separators
scheme.set_lualine_style({ '',  ''  })

-- lines
-- scheme.set_lualine_seperator({ '│', '│' }) -- thin box
-- scheme.set_lualine_seperator({ '┃', '┃' }) -- bold box
-- scheme.set_lualine_seperator({ '⎮', '⎮' }) -- idk what this is
-- scheme.set_lualine_seperator({ '|', '|' }) -- pipe

-- slashes
-- scheme.set_lualine_seperator({ [[\]], [[\]] })
-- scheme.set_lualine_seperator({ [[/]], [[/]] })
-- scheme.set_lualine_seperator({ [[/]], [[\]] })
-- scheme.set_lualine_seperator({ [[\]], [[/]] })

-- pointy
-- scheme.set_lualine_seperator({ '>', '<' })
-- scheme.set_lualine_seperator({ '<', '>' })
-- scheme.set_lualine_seperator({ '', '' })
-- scheme.set_lualine_seperator({ '', '' })
-- scheme.set_lualine_seperator({ '🞂',  '🞀'  })
-- scheme.set_lualine_seperator({ '🞀',  '🞂'  })
-- scheme.set_lualine_seperator({ '->', '<-' })
-- scheme.set_lualine_seperator({ '<-', '->' })

-- other
-- scheme.set_lualine_seperator({ '-', '-' })
scheme.set_lualine_seperator({ '~', '~' })
-- scheme.set_lualine_seperator({ '+', '+' })
-- scheme.set_lualine_seperator({ '', '' })
-- scheme.set_lualine_seperator({ '🞙', '🞙' })
-- }}}

-- {{{ custom formats
local mode_fmts = {
    -- normal/misc
    ['NORMAL'] = 'NOR',
    ['O-PENDING'] = 'O-P',
    ['MORE'] = 'MOR',
    ['CONFIRM'] = 'CF?',

    -- insert
    ['INSERT'] = 'INS',

    -- visual
    ['VISUAL'] = 'VIS',
    ['V-LINE'] = 'V-L',
    -- ['V-LINE'] = 'VLN',
    ['V-BLOCK'] = 'V-B',
    -- ['V-BLOCK'] = 'VBL',

    -- select
    ['SELECT'] = 'SEL',
    ['S-LINE'] = 'S-L',
    -- ['S-LINE'] = 'SLN',
    ['S-BLOCK'] = 'S-B',
    -- ['S-BLOCK'] = 'SBL',

    -- replace
    ['REPLACE'] = 'RPL',
    ['V-REPLACE'] = 'V-R',
    -- ['V-REPLACE'] = 'VRP',

    -- cmd, terminal, shell, and ex
    ['COMMAND'] = 'CMD',
    ['SHELL'] = 'SHL',
    ['TERMINAL'] = 'TER',
    ['EX'] = 'EXM', -- M stands for mode, had to add to fit 3 chars
}

local mode_fmt = function(str) return mode_fmts[str] end

local diff_fmt = function(str) return str:gsub('%+', ''):gsub('~', ''):gsub('-', '') end
-- }}}

-- {{{ reused widgets/functions/sections
local mode = { 'mode', fmt = mode_fmt }
local branch = { 'branch', icon = '' }
local filename   = { 'filename', path = 0, shorting_target = 40, symbols = { modified = '', readonly = ' +RO', unnamed = 'No Name' } }
local fileformat = { 'fileformat', symbols = { unix = 'u', dos = 'd', mac = 'm' } }

local function short_cwd() return vim.fn.fnamemodify(vim.fn.getcwd(), ':~') end -- iconless

local sections = {
    lualine_a = { mode },
    lualine_b = { 'filesize', { 'filetype', colored = false, icon = { align = 'right' } } }, -- why won't right align work?
    lualine_c = { branch, { 'diff', symbols = { added = '', modified = '', removed = '' } } },
    lualine_x = { filename },
    lualine_y = { fileformat, 'encoding' },
    lualine_z = { 'location' },
}
-- }}}

-- {{{ custom extensions
-- template
local extension_template = {
    lualine_b = { short_cwd },
    lualine_c = { branch },
    lualine_x = { 'os.date("%d/%m:%u")' },
    lualine_y = { 'hostname' },
    lualine_z = { 'location' },
}

-- {{{ dashboard
local dashboard = {}

dashboard.sections = vim.deepcopy(extension_template)
dashboard.sections.lualine_a = { function() return "DSH" end }

dashboard.filetypes = { 'dashboard' }
-- }}}

-- {{{ git
local fugitive = {}

fugitive.sections = vim.deepcopy(extension_template)
fugitive.sections.lualine_a = { function() return "GIT" end }

fugitive.filetypes = { 'fugitive' }

local gitcommit = {}

gitcommit.sections = vim.deepcopy(extension_template)
gitcommit.sections.lualine_a = { mode }
gitcommit.sections.lualine_b = { { function() return "COMMITTING @" end, separator = '', padding = { left = 1 } }, short_cwd }

gitcommit.filetypes = { 'gitcommit' }
-- }}}

-- {{{ nvim-tree
local nvim_tree = {}

nvim_tree.sections = vim.deepcopy(extension_template)
nvim_tree.sections.lualine_a = { function() return "NVT" end }

nvim_tree.filetypes = { 'NvimTree' }
-- }}}

-- {{{ telescope
local telescope = {}

telescope.sections = vim.deepcopy(extension_template)
telescope.sections.lualine_a = { function() return "TSC" end } -- could have a better abbreviation

telescope.filetypes = { 'TelescopePrompt' }
-- }}}

-- {{{ word count
local wc = {}

wc.sections = vim.deepcopy(sections)
wc.sections.lualine_x = { '', filename }
--                        ^^ some word count magic i'll implement later

wc.filetypes = { 'markdown', 'org', 'text' }
-- }}}
-- }}}

-- {{{ lualine setup config
require('lualine').setup({
    extensions = { dashboard, fugitive, gitcommit, nvim_tree, telescope, wc },

	options = {
		theme = lualine_theme,

		section_separators = { left = scheme.lualine_style_left, right = scheme.lualine_style_right },
		component_separators = { left = scheme.lualine_seperator_left, right = scheme.lualine_seperator_right },

        always_divide_middle = true,
        globalstatus = true,
	},

	sections = sections,
})
-- }}}
