-- INFO:
-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

-- INFO:
-- We use nvim-tree instead of netrw, so disable it
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.o.winborder = 'rounded'
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
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
vim.o.syntax = 'on'
