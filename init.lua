require('option')
require('core.lazy')
require('command')
vim.api.nvim_create_autocmd('User', {
  pattern = 'TelescopePreviewerLoaded',
  callback = function() vim.wo.wrap = true end,
})
