return {
  'Kaiser-Yang/resolve.nvim',
  event = { { event = 'User', pattern = 'GitConflictDetected' } },
  cond = not vim.g.vscode,
  opts = {
    diff_view_labels = {
      ours = 'Current',
      theirs = 'Incoming',
      base = 'Base',
    },
    should_skip = function(buffer) return require('lightboat.util').buffer.big(buffer) end,
    default_keymaps = false,
    on_conflict_detected = function(args)
      local h = require('lightboat.handler')
      local previous_conflict = h.repmove_wrap('<plug>(resolve-prev)', '<plug>(resolve-next)', 1)
      local next_conflict = h.repmove_wrap('<plug>(resolve-prev)', '<plug>(resolve-next)', 2)
      local mapping = {
        { 'n', '<leader>xc', '<plug>(resolve-ours)', { desc = 'Choose Current Conflict' } },
        { 'n', '<leader>xi', '<plug>(resolve-theirs)', { desc = 'Choose Incoming Conflict' } },
        { 'n', '<leader>xb', '<plug>(resolve-both)', { desc = 'Choose Both Conflict' } },
        { 'n', '<leader>xB', '<plug>(resolve-both-reverse)', { desc = 'Choose Both Reverse Conflict' } },
        { 'n', '<leader>xn', '<plug>(resolve-none)', { desc = 'Choose None Conflict' } },
        { 'n', '<leader>xa', '<plug>(resolve-base)', { desc = 'Choose Ancestor Conflict' } },
        { 'n', '<leader>xq', '<plug>(resolve-list)', { desc = 'Quickfix Conflict' } },
        -- WARN: This only works for normal mode
        { 'n', '[x', previous_conflict, { desc = 'Previous Git Conflict', expr = true } },
        { 'n', ']x', next_conflict, { desc = 'Next Git Conflict', expr = true } },
      }
      if vim.fn.executable('delta') == 1 then
        mapping = vim.list_extend(mapping, {
          { 'n', '<leader>xdi', '<plug>(resolve-diff-theirs)', { desc = 'Diff Incoming Conflict' } },
          { 'n', '<leader>xdc', '<plug>(resolve-diff-ours)', { desc = 'Diff Current Conflict' } },
          { 'n', '<leader>xdb', '<plug>(resolve-diff-both)', { desc = 'Diff Both Conflict' } },
          { 'n', '<leader>xdv', '<plug>(resolve-diff-vs)', { desc = 'Diff Current V.S. Incoming Conflict' } },
          { 'n', '<leader>xdV', '<plug>(resolve-diff-vs-reverse)', { desc = 'Diff Incoming V.S. Current Conflict' } },
        })
      end
      for _, m in ipairs(mapping) do
        m[4].buffer = args.bufnr
        vim.keymap.set(unpack(m))
      end
      vim.diagnostic.enable(false, { bufnr = args.bufnr })
    end,
    disable_diagnostics = function(args)
      vim.diagnostic.enable(true, { bufnr = args.bufnr })
      local mapping = {
        { 'n', '<leader>xc' },
        { 'n', '<leader>xi' },
        { 'n', '<leader>xb' },
        { 'n', '<leader>xB' },
        { 'n', '<leader>xn' },
        { 'n', '<leader>xa' },
        { 'n', '<leader>xq' },
        { 'n', '[x' },
        { 'n', ']x' },
      }
      if vim.fn.executable('delta') == 1 then
        mapping = vim.list_extend(mapping, {
          { 'n', '<leader>xdi' },
          { 'n', '<leader>xdc' },
          { 'n', '<leader>xdb' },
          { 'n', '<leader>xdv' },
          { 'n', '<leader>xdV' },
        })
      end
      for _, m in ipairs(mapping) do
        vim.keymap.del(unpack(m), { buffer = args.bufnr })
      end
    end,
  },
}
