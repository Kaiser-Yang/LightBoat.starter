require('option')
require('core.lazy')
require('command')
vim.api.nvim_create_autocmd('User', {
  pattern = 'TelescopePreviewerLoaded',
  callback = function() vim.wo.wrap = true end,
})
vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].modified then
        if
          vim.bo[bufnr].buftype == ''
          and vim.api.nvim_buf_get_name(bufnr) ~= ''
          and vim.bo[bufnr].modifiable
          and not vim.bo[bufnr].readonly
        then
          vim.api.nvim_buf_call(bufnr, function() vim.cmd('update') end)
        end
      end
    end
  end,
})
