vim.api.nvim_create_autocmd('User', {
  pattern = 'TelescopePreviewerLoaded',
  callback = function() vim.wo.wrap = true end,
})
vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.api.nvim_buf_is_loaded(bufnr)
        and vim.bo[bufnr].modified
        and vim.bo[bufnr].buftype == ''
        and vim.api.nvim_buf_get_name(bufnr) ~= ''
        and vim.bo[bufnr].modifiable
        and not vim.bo[bufnr].readonly
      then
        vim.api.nvim_buf_call(bufnr, function() vim.cmd('update') end)
      end
    end
  end,
})
local lsp_m = {
  -- By default, "tagfunc" is set whne "LspAttach",
  -- "<C-]>", "<C-W>]", and "<C-W>}" will work, you can use them to go to definition
  { 'n', 'K', vim.lsp.buf.hover, { desc = 'Hover' } },
  { 'n', 'grn', vim.lsp.buf.rename, { desc = 'Rename Symbol' } },
  { 'n', 'gra', vim.lsp.buf.code_action, { desc = 'Code Action' } },
  { 'n', 'grr', '<cmd>Telescope lsp_references<cr>', { desc = 'References' } },
  { 'n', 'gri', '<cmd>Telescope lsp_implementations<cr>', { desc = 'Go to Implementation' } },
  { 'n', 'grI', '<cmd>Telescope lsp_incoming_calls<cr>', { desc = 'Incoming Call' } },
  { 'n', 'grO', '<cmd>Telescope lsp_outgoing_calls<cr>', { desc = 'Outgoint Call' } },
  { 'n', 'grt', '<cmd>Telescope lsp_type_definitions<cr>', { desc = 'Go to Type Definition' } },
  { 'n', 'gO', '<cmd>Telescope lsp_document_symbols<cr>', { desc = 'Document Symbol' } },
}
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    for _, m in ipairs(lsp_m) do
      m[4].buffer = ev.buf
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.keymap.set(unpack(m))
    end
  end,
})
vim.diagnostic.config({
  virtual_lines = { current_line = true },
})
require('option')
require('core.lazy')
require('command')
