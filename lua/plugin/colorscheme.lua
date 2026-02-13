-- INFO:
-- See https://github.com/topics/neovim-colorscheme to find one you like and set it here
return {
  'ellisonleao/gruvbox.nvim',
  priority = 1000,
  opts = {},
  lazy = false,
  config = function(_, opts)
    require('gruvbox').setup(opts)
    vim.o.background = 'dark'
    vim.cmd.colorscheme('gruvbox')
    vim.api.nvim_set_hl(0, 'FoldColumn', { fg = '#928374', bg = 'NONE', force = true })
  end,
}
