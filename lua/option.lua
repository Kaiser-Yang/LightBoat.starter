vim.g.big_file_limit = 1024 * 1024 -- 1 MB
vim.g.big_file_average_every_line = 200
vim.g.highlight_on_yank = true
vim.g.highlight_on_yank_limit = 1024 -- 1 KB
vim.g.highlight_on_yank_duration = 300
vim.g.conform_on_save = true
vim.g.conform_on_save_reguess_indent = true
vim.g.conform_formatexpr_auto_set = true
vim.g.treesitter_highlight_auto_start = true
vim.g.treesitter_foldexpr_auto_set = true
vim.g.nohlsearch_auto_run = true

-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

-- We use another explore instead of netrw, so disable it
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.o.numberwidth = 1
vim.o.winborder = 'rounded'
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes:1'
vim.o.jumpoptions = 'stack'
vim.o.termguicolors = true
vim.o.scrolloff = 5
vim.o.colorcolumn = '100'
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = 'tab:»-,trail:·,lead:·'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.foldopen = 'block,mark,percent,quickfix,search,tag,undo'
vim.o.foldlevel = 99999
vim.o.foldcolumn = '1'
vim.o.fillchars = 'fold: ,foldopen:,foldclose:,foldsep: '
vim.o.splitright = true
vim.o.splitbelow = false

--- @class LightBoat.Opt
vim.g.lightboat_opt = {
  --- @type string[]
  treesitter_ensure_installed = { 'lua' },
  --- @type string[]
  mason_ensure_installed = { 'lua_ls' },
}

-- vim.g.loaded_matchit = 1
-- vim.o.cmdheight = 0
