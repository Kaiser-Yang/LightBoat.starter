-- INFO:
-- See https://github.com/topics/neovim-colorscheme to find one you like and set it here
return {
  'ellisonleao/gruvbox.nvim',
  priority = 1000,
  opts = {
    overrides = {
      SignColumn = { bg = 'NONE' },
      Folded = { bg = 'NONE' },
      FoldColumn = { bg = 'NONE' },
      GruvboxRedSign = { bg = 'NONE' },
      GruvboxGreenSign = { bg = 'NONE' },
      GruvboxYellowSign = { bg = 'NONE' },
      GruvboxBlueSign = { bg = 'NONE' },
      GruvboxPurpleSign = { bg = 'NONE' },
      GruvboxAquaSign = { bg = 'NONE' },
      GruvboxOrangeSign = { bg = 'NONE' },
    },
  },
  lazy = false,
  config = function(_, opts)
    require('gruvbox').setup(opts)
    vim.o.background = 'dark'
    vim.cmd.colorscheme('gruvbox')
    vim.api.nvim_set_hl(0, 'CursorLineFold', { fg = '#928374', bg = '#3c3836', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentRed', { link = 'GruvboxRed', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentOrange', { link = 'GruvboxOrange', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentYellow', { link = 'GruvboxYellow', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentGreen', { link = 'GruvboxGreen', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentBlue', { link = 'GruvboxBlue', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentCyan', { link = 'GruvboxAqua', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentViolet', { link = 'GruvboxPurple', force = true })

    vim.api.nvim_set_hl(0, 'BlinkIndentRedUnderline', { underline = true, sp = '#fb4934', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentOrangeUnderline', { underline = true, sp = '#fe8019', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentYellowUnderline', { underline = true, sp = '#fabd2f', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentGreenUnderline', { underline = true, sp = '#b8bb26', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentBlueUnderline', { underline = true, sp = '#83a598', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentCyanUnderline', { underline = true, sp = '#8ec07c', force = true })
    vim.api.nvim_set_hl(0, 'BlinkIndentVioletUnderline', { underline = true, sp = '#d3869b', force = true })
  end,
}
