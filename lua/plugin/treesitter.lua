return {
  'nvim-treesitter/nvim-treesitter',
  cond = not vim.g.vscode,
  cmd = { 'TSUpdate', 'TSInstall', 'TSUninstall', 'TSInstallFromGrammar' },
  event = 'VeryLazy',
  branch = 'main',
  build = ':TSUpdate',
  opts = {},
}
