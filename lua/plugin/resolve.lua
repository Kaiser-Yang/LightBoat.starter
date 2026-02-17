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
      local resolve = require('resolve')
      local previous_conflict = h.repmove_wrap(resolve.prev_conflict, resolve.next_conflict, 1)
      local next_conflict = h.repmove_wrap(resolve.prev_conflict, resolve.next_conflict, 2)
      local mapping = {
        { { 'n', 'x' }, '[x', previous_conflict, { desc = 'Conflict' } },
        { { 'n', 'x' }, ']x', next_conflict, { desc = 'Conflict' } },
        { 'n', '<leader>xc', resolve.choose_ours, { desc = 'Choose Current' } },
        { 'n', '<leader>xi', resolve.choose_theirs, { desc = 'Choose Incoming' } },
        { 'n', '<leader>xb', resolve.choose_both, { desc = 'Choose Both' } },
        { 'n', '<leader>xB', resolve.choose_both_reverse, { desc = 'Choose Both Reverse' } },
        { 'n', '<leader>xn', resolve.choose_none, { desc = 'Choose None' } },
        { 'n', '<leader>xa', resolve.choose_base, { desc = 'Choose Ancestor' } },
        { 'n', '<leader>xq', resolve.list_conflicts, { desc = 'Quickfix Conflict of Buffer' } },
      }
      if vim.fn.executable('delta') == 1 then
        mapping = vim.list_extend(mapping, {
          { 'n', '<leader>xdi', resolve.show_diff_theirs, { desc = 'Incoming' } },
          { 'n', '<leader>xdc', resolve.show_diff_ours, { desc = 'Current' } },
          { 'n', '<leader>xdb', resolve.show_diff_both, { desc = 'Both' } },
          { 'n', '<leader>xdv', resolve.show_diff_ours_vs_theirs, { desc = 'Current V.S. Incoming' } },
          { 'n', '<leader>xdV', resolve.show_diff_theirs_vs_ours, { desc = 'Incoming V.S. Current' } },
        })
      end
      for _, m in ipairs(mapping) do
        m[4].buffer = args.bufnr
        vim.keymap.set(unpack(m))
      end
      vim.diagnostic.enable(false, { bufnr = args.bufnr })
    end,
    on_conflicts_resolved = function(args)
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
        pcall(vim.keymap.del, m[1], m[2], { buffer = args.bufnr })
      end
    end,
  },
}
