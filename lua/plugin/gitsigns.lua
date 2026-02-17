return {
  'lewis6991/gitsigns.nvim',
  event = { { event = 'User', pattern = 'GitRepoDetected' } },
  cond = not vim.g.vscode,
  opts = {
    attach_to_untracked = true,
    current_line_blame = true,
    current_line_blame_opts = { delay = 300 },
    preview_config = { border = vim.o.winborder or nil },
    on_attach = function(buffer)
      local g = require('gitsigns')
      local r = require('lightboat.handler').repmove_wrap
      local u = require('lightboat.util')
      local stage_selection = function() g.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end
      local reset_selection = function() g.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end
      local quickfix_all_hunk = function() require('gitsigns').setqflist('all') end
      local toggle_current_line_blame = function()
        u.toggle_notify('Current Line Blame', require('gitsigns').toggle_current_line_blame(), { title = 'Git Signs' })
      end
      local toggle_word_diff = function()
        u.toggle_notify('Word Diff', require('gitsigns').toggle_word_diff(), { title = 'Git Signs' })
      end
      local toggle_signs = function()
        u.toggle_notify('Signs', require('gitsigns').toggle_signs(), { title = 'Git Signs' })
      end
      local toggle_numhl = function()
        u.toggle_notify('Line Number Highlight', require('gitsigns').toggle_numhl(), { title = 'Git Signs' })
      end
      local toggle_linehl = function()
        u.toggle_notify('Line Highlight', require('gitsigns').toggle_linehl(), { title = 'Git Signs' })
      end
      local toggle_deleted = function()
        u.toggle_notify('Deleted', require('gitsigns').toggle_deleted(), { title = 'Git Signs' })
      end
      local previous_hunk, next_hunk = unpack(r(function() g.nav_hunk('prev') end, function() g.nav_hunk('next') end))
      local diff_this = function() g.diffthis('~') end
      local mapping = {
        { { 'n', 'x' }, '[g', previous_hunk, { desc = 'Git Hunk' } },
        { { 'n', 'x' }, ']g', next_hunk, { desc = 'Git Hunk' } },
        { { 'x', 'o' }, 'ah', g.select_hunk, { desc = 'Git Hunk' } },
        { { 'x', 'o' }, 'ih', g.select_hunk, { desc = 'Git Hunk' } },
        { 'x', '<leader>ga', stage_selection, { desc = 'Add' } },
        { 'x', '<leader>gr', reset_selection, { desc = 'Reset' } },
        { 'n', '<leader>ga', g.stage_hunk, { desc = 'Add Hunk' } },
        { 'n', '<leader>gA', g.stage_buffer, { desc = 'Add Buffer' } },
        { 'n', '<leader>gu', g.undo_stage_hunk, { desc = 'Undo Add Hunk' } },
        { 'n', '<leader>gU', g.reset_buffer_index, { desc = 'Undo Add Buffer' } },
        { 'n', '<leader>gr', g.reset_hunk, { desc = 'Reset Hunk' } },
        { 'n', '<leader>gR', g.reset_buffer, { desc = 'Reset Buffer' } },
        { 'n', '<leader>gd', g.preview_hunk, { desc = 'Diff' } },
        { 'n', '<leader>gD', g.preview_hunk_inline, { desc = 'Diff Inline' } },
        { 'n', '<leader>gt', diff_this, { desc = 'Diff this' } },
        { 'n', '<leader>gb', g.blame_line, { desc = 'Blame Line' } },
        { 'n', '<leader>gq', quickfix_all_hunk, { desc = 'Quickfix All Hunk' } },
        { 'n', '<leader>tgb', toggle_current_line_blame, { desc = 'Blame' } },
        { 'n', '<leader>tgw', toggle_word_diff, { desc = 'Word Diff' } },
        { 'n', '<leader>tgs', toggle_signs, { desc = 'Sign' } },
        { 'n', '<leader>tgn', toggle_numhl, { desc = 'Line Number Highlight' } },
        { 'n', '<leader>tgl', toggle_linehl, { desc = 'Line Highlight' } },
        { 'n', '<leader>tgd', toggle_deleted, { desc = 'Deleted' } },
      }
      if require('lightboat.util').plugin_available('which-key.nvim') then
        local wk = require('which-key')
        wk.add({ '<leader>g', desc = 'Git', mode = { 'n', 'x' }, buffer = true })
        wk.add({ '<leader>tg', desc = 'Git', mode = { 'n', 'x' }, buffer = true })
      end
      for _, m in ipairs(mapping) do
        m[4].buffer = buffer
        vim.keymap.set(unpack(m))
      end
    end,
  },
}
