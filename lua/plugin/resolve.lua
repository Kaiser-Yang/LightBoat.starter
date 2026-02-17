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
        { { 'n', 'x' }, '[x', previous_conflict, { desc = 'Previous Git Conflict' } },
        { { 'n', 'x' }, ']x', next_conflict, { desc = 'Next Git Conflict' } },
        { 'n', '<leader>xc', resolve.choose_ours, { desc = 'Choose Current Conflict' } },
        { 'n', '<leader>xi', resolve.choose_theirs, { desc = 'Choose Incoming Conflict' } },
        { 'n', '<leader>xb', resolve.choose_both, { desc = 'Choose Both Conflict' } },
        { 'n', '<leader>xB', resolve.choose_both_reverse, { desc = 'Choose Both Reverse Conflict' } },
        { 'n', '<leader>xn', resolve.choose_none, { desc = 'Choose None Conflict' } },
        { 'n', '<leader>xa', resolve.choose_base, { desc = 'Choose Ancestor Conflict' } },
        { 'n', '<leader>xq', resolve.list_conflicts, { desc = 'Quickfix Conflict' } },
      }
      if vim.fn.executable('delta') == 1 then
        mapping = vim.list_extend(mapping, {
          { 'n', '<leader>xdi', resolve.show_diff_theirs, { desc = 'Diff Incoming Conflict' } },
          { 'n', '<leader>xdc', resolve.show_diff_ours, { desc = 'Diff Current Conflict' } },
          { 'n', '<leader>xdb', resolve.show_diff_both, { desc = 'Diff Both Conflict' } },
          { 'n', '<leader>xdv', resolve.show_diff_ours_vs_theirs, { desc = 'Diff Current V.S. Incoming Conflict' } },
          { 'n', '<leader>xdV', resolve.show_diff_theirs_vs_ours, { desc = 'Diff Incoming V.S. Current Conflict' } },
        })
      end
      if require('lightboat.util').plugin_available('which-key.nvim') then
        local wk = require('which-key')
        wk.add({ '<leader>x', desc = 'Conflict', buffer = args.bufnr })
        wk.add({ '<leader>xd', desc = 'Conflict Diff', buffer = args.bufnr })
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
