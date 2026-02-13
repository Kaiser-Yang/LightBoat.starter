return {
  'folke/todo-comments.nvim',
  cond = not vim.g.vscode,
  cmd = { 'TodoTelescope', 'TodoQuickFix', 'TodoLocList' },
  event = 'VeryLazy',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { sign_priority = 1, highlight = { multiline = false } },
}
