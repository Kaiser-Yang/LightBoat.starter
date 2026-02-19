local function setqflist(conflicts)
  local qf_list = {}
  vim.notify(
    string.format('Detected %d conflict(s) in current repository, they have been added to quickfix list.', #conflicts),
    vim.log.levels.INFO,
    { title = 'Resolve' }
  )
  for i, conflict in ipairs(conflicts) do
    table.insert(qf_list, {
      bufnr = conflict.bufnr,
      filename = vim.api.nvim_buf_get_name(conflict.bufnr),
      lnum = conflict.start,
      text = string.format('Conflict %d/%d', i, #conflicts),
    })
  end
  vim.fn.setqflist(qf_list)
end

return {
  'Kaiser-Yang/resolve.nvim',
  dir = '/home/kaiser/repo/resolve.nvim',
  event = { { event = 'User', pattern = 'GitConflictDetected' } },
  cond = not vim.g.vscode,
  opts = {
    should_skip = function(buffer) return require('lightboat.util').buffer.big(buffer) end,
    default_keymaps = false,
    auto_detect_enabled = false,
    on_conflict_detected = function(args)
      local h = require('lightboat.handler')
      local r = require('resolve')
      local previous_conflict = h.repmove_wrap(r.prev_conflict, r.next_conflict, 1)
      local next_conflict = h.repmove_wrap(r.prev_conflict, r.next_conflict, 2)
      local mapping = {
        { { 'n', 'x' }, '[x', previous_conflict, { desc = 'Conflict' } },
        { { 'n', 'x' }, ']x', next_conflict, { desc = 'Conflict' } },
        { 'n', '<leader>xc', r.choose_ours, { desc = 'Choose Current' } },
        { 'n', '<leader>xi', r.choose_theirs, { desc = 'Choose Incoming' } },
        { 'n', '<leader>xb', r.choose_both, { desc = 'Choose Both' } },
        { 'n', '<leader>xB', r.choose_both_reverse, { desc = 'Choose Both Reverse' } },
        { 'n', '<leader>xn', r.choose_none, { desc = 'Choose None' } },
        { 'n', '<leader>xa', r.choose_base, { desc = 'Choose Ancestor' } },
        { 'n', '<leader>xq', r.list_conflicts, { desc = 'Quickfix Conflict of Buffer' } },
      }
      if vim.fn.executable('delta') == 1 then
        mapping = vim.list_extend(mapping, {
          { 'n', '<leader>xdi', r.show_diff_theirs, { desc = 'Incoming' } },
          { 'n', '<leader>xdc', r.show_diff_ours, { desc = 'Current' } },
          { 'n', '<leader>xdb', r.show_diff_both, { desc = 'Both' } },
          { 'n', '<leader>xdv', r.show_diff_ours_vs_theirs, { desc = 'Current V.S. Incoming' } },
          { 'n', '<leader>xdV', r.show_diff_theirs_vs_ours, { desc = 'Incoming V.S. Current' } },
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
  config = function(_, opts)
    local r = require('resolve')
    r.setup(opts)
    local conflicts = {}
    local function extend(bufnr, new_conflicts)
      for _, conflict in ipairs(new_conflicts) do
        conflict.bufnr = bufnr
        table.insert(conflicts, conflict)
      end
    end
    vim.api.nvim_create_user_command('DetectConflictAndLoad', function()
      vim.system(
        { 'git', 'diff', '--name-only', '--diff-filter=U' },
        { text = true, cwd = vim.fn.getcwd() },
        function(result)
          if result.code ~= 0 then
            vim.notify('Error running git command: ' .. result.stderr, vim.log.levels.ERROR, { title = 'Resolve' })
            return
          end
          local files = vim.split(result.stdout, '\n', { trimempty = true })
          vim.schedule(function()
            for _, file in ipairs(files) do
              file = vim.fn.fnamemodify(file, ':p')
              local bufnr = vim.fn.bufadd(file)
              vim.bo[bufnr].buflisted = true
              if not vim.api.nvim_buf_is_loaded(bufnr) then
                vim.api.nvim_create_autocmd('BufReadPost', {
                  buffer = bufnr,
                  once = true,
                  callback = function()
                    if vim.api.nvim_buf_is_valid(bufnr) then
                      extend(bufnr, r.detect_conflicts(bufnr, true))
                    end
                  end,
                })
                vim.fn.bufload(bufnr)
              else
                extend(bufnr, r.detect_conflicts(bufnr, true))
              end
            end
            setqflist(conflicts)
          end)
        end
      )
    end, { desc = 'Detect Git Conflict in Current Repository' })
    vim.cmd('DetectConflictAndLoad')
  end,
}
