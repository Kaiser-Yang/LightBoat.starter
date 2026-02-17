return {
  'lewis6991/gitsigns.nvim',
  event = { { event = 'User', pattern = 'GitRepoDetected' } },
  cond = not vim.g.vscode,
  opts = {
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
      local previous_hunk, next_hunk = unpack(r(function()
        vim.schedule(function()
          if vim.fn.mode('1') == 'no' then vim.cmd('norm! V') end
          g.nav_hunk('prev')
        end)
      end, function()
        vim.schedule(function()
          if vim.fn.mode('1') == 'no' then vim.cmd('norm! V') end
          g.nav_hunk('next')
        end)
      end))
      local diff_this = function() g.diffthis('~') end
      local mapping = {
        { { 'n', 'x' }, '[g', previous_hunk, { desc = 'Previous Git Hunk', expr = true } },
        { { 'n', 'x' }, ']g', next_hunk, { desc = 'Next Git Hunk', expr = true } },
        { { 'x', 'o' }, 'ah', g.select_hunk, { desc = 'Select Hunk' } },
        { { 'x', 'o' }, 'ih', g.select_hunk, { desc = 'Select Hunk' } },
        { 'x', '<leader>ga', stage_selection, { desc = 'Stage Selection' } },
        { 'x', '<leader>gr', reset_selection, { desc = 'Reset Selection' } },
        { 'n', '<leader>ga', g.stage_hunk, { desc = 'Stage Hunk' } },
        { 'n', '<leader>gA', g.stage_buffer, { desc = 'Stage Buffer' } },
        { 'n', '<leader>gu', g.undo_stage_hunk, { desc = 'Undo Stage Hunk' } },
        { 'n', '<leader>gU', g.reset_buffer_index, { desc = 'Unstage Buffer' } },
        { 'n', '<leader>gr', g.reset_hunk, { desc = 'Reset Hunk' } },
        { 'n', '<leader>gR', g.reset_buffer, { desc = 'Reset Buffer' } },
        { 'n', '<leader>gd', g.preview_hunk_inline, { desc = 'Hunk Diff Inline' } },
        { 'n', '<leader>gD', g.preview_hunk, { desc = 'Hunk Diff' } },
        { 'n', '<leader>gb', g.blame_line, { desc = 'Blame Line' } },
        { 'n', '<leader>gt', diff_this, { desc = 'Diff this' } },
        { 'n', '<leader>gq', quickfix_all_hunk, { desc = 'Quickfix All Hunk' } },
        { 'n', '<leader>tgb', toggle_current_line_blame, { desc = 'Toggle Blame' } },
        { 'n', '<leader>tgw', toggle_word_diff, { desc = 'Toggle Word Diff' } },
      }
      for _, m in ipairs(mapping) do
        m[4].buffer = buffer
        vim.keymap.set(unpack(m))
      end
    end,
  },
}
