return {
  'Kaiser-Yang/maplayer.nvim',
  event = 'VeryLazy',
  config = function()
    -- We have provide another key binding for commenting current line
    -- We must remove this to make "gc" work
    vim.api.nvim_del_keymap('n', 'gcc')
    -- When all key bindings has no overlapping,
    -- you can set "timeoutlen" with zero
    -- The default satisfy the requirement.
    -- When you update key bindings, be careful to check if there is any overlapping,
    -- if there is, you should set "timeoutlen" with a proper value such as 300 or 500
    -- "which-key.nvim" can not be used in vscode neovim extension,
    -- so we must set "timeoutlen" with a proper value to make it work
    vim.o.timeoutlen = vim.g.vscode and 300 or 0
    local u = require('lightboat.util')
    local c_dir = vim.fn.fnameescape(vim.fn.stdpath('config'))
    local l_dir = vim.fn.fnameescape(u.lazy_path())
    local h = require('lightboat.handler')
    local function toggle_conflict_detection()
      if not _G.plugin_loaded['resolve.nvim'] then return false end
      local status = require('resolve').toggle_auto_detect(nil, true)
      u.toggle_notify('Conflict Detection', status, { title = 'Resolve' })
    end
    -- stylua: ignore start
    require('maplayer').setup({
      -- Basic
      { key = '<cr>', mode = 'i', desc = 'Insert Undo Point', handler = function() u.key.feedkeys('<c-g>u', 'n') return false end },
      -- By default "<C-A>" is used to insert all commands in command mode
      -- and is used to insert previously inserted text in insert mode
      { key = '<c-a>', mode = 'ci', desc = 'Cursor to BOL', handler = h.cursor_to_bol, fallback = false },
      { key = '<m-c>', mode = 'nox', desc = 'System Yank', handler = h.system_yank, expr = true, fallback = false },
      { key = '<m-d>', mode = 'ci', desc = 'Delete to EOW', handler = h.delete_to_eow, fallback = false },
      { key = '<m-n>', mode = 'c', desc = 'Next Commend History', handler = '<down>', fallback = false },
      { key = '<m-p>', mode = 'c', desc = 'Previous Commend History', handler = '<up>', fallback = false },
      { key = '<m-v>', mode = 'cinx', desc = 'System Put', handler = h.system_put, fallback = false },
      { key = '<m-x>', mode = 'nox', desc = 'System Cut', handler = h.system_cut, expr = true, fallback = false },
      { key = '<m-C>', desc = 'System Yank EOL', handler = h.system_yank_eol, fallback = false },
      { key = '<m-V>', desc = 'System Put Before', handler = h.system_put_before, fallback = false },
      { key = '<m-X>', desc = 'System Cut EOL', handler = h.system_cut_eol, fallback = false },
      { key = '<m-/>', mode = 'inx', desc = 'Toggle Comment', handler = h.toggle_comment, fallback = false },
      { key = '<leader>ti', desc = 'Inlay Hint', handler = h.toggle_inlay_hint, fallback = false },
      { key = '<leader>ts', desc = 'Spell', handler = h.toggle_spell, fallback = false },
      { key = '<leader>tt', desc = 'Treesitter Highlight', handler = h.toggle_treesitter },
      { key = { 'ae', 'ie' }, mode = 'ox', desc = 'Edit', handler = h.select_file, fallback = false },

      -- Repmove Motion
      { key = ';', mode = 'nx', desc = 'Repeat Last Motion Forward', handler = h.semicolon, fallback = false },
      { key = ',', mode = 'nx', desc = 'Repeat Last Motion Backward', handler = h.comma, fallback = false },
      { key = 'f', mode = 'nx', desc = 'Move to Next Character', handler = h.f, fallback = false },
      { key = 'F', mode = 'nx', desc = 'Move to Previous Character', handler = h.F, fallback = false },
      { key = 't', mode = 'nx', desc = 'Move till Next Character', handler = h.t, fallback = false },
      { key = 'T', mode = 'nx', desc = 'Move till Previous Character', handler = h.T, fallback = false },
      { key = '[s', mode = 'nx', desc = 'Misspelled Word', handler = h.previous_misspelled, fallback = false },
      { key = ']s', mode = 'nx', desc = 'Misspelled Word', handler = h.next_misspelled, fallback = false },
      -- By default "[f" and "]f" are aliases of "gf"
      { key = '[f', mode = 'nox', desc = 'For Start', handler = h.previous_loop_start, fallback = false },
      { key = ']f', mode = 'nx', desc = 'For Start', handler = h.next_loop_start, fallback = false },
      { key = '[F', mode = 'nx', desc = 'For End', handler = h.previous_loop_end, fallback = false },
      { key = ']F', mode = 'nox', desc = 'For End', handler = h.next_loop_end, fallback = false },
      { key = '[m', mode = 'nox', desc = 'Method Start', handler = h.previous_function_start, fallback = false },
      { key = ']m', mode = 'nx', desc = 'Method Start', handler = h.next_function_start, fallback = false },
      { key = '[M', mode = 'nx', desc = 'Method End', handler = h.previous_function_end, fallback = false },
      { key = ']M', mode = 'nox', desc = 'Method End', handler = h.next_function_end, fallback = false },
      { key = '[o', mode = 'nx', desc = 'Call Start', handler = h.previous_call_start, fallback = false },
      { key = ']o', mode = 'nx', desc = 'Call Start', handler = h.next_call_start, fallback = false },
      { key = '[O', mode = 'nx', desc = 'Call End', handler = h.previous_call_end, fallback = false },
      { key = ']O', mode = 'nx', desc = 'Call End', handler = h.next_call_end, fallback = false },
      -- By default "[t" and "]t" are mapped to ":tp" and ":tn"
      -- Those two below do not support vim.v.count
      { key = '[t', mode = 'nx', desc = 'Todo', handler = h.previous_todo, fallback = false },
      { key = ']t', mode = 'nx', desc = 'Todo', handler = h.next_todo, fallback = false },
      { key = '[[', mode = 'nox', desc = 'Block Start', handler = h.previous_block_start, fallback = false },
      { key = ']]', mode = 'nx', desc = 'Block Start', handler = h.next_block_start, fallback = false },
      { key = '[]', mode = 'nx', desc = 'Block End', handler = h.previous_block_end, fallback = false },
      { key = '][', mode = 'nox', desc = 'Block End', handler = h.next_block_end, fallback = false },

      -- Treesitter Text Object
      { key = 'af', mode = 'nox', desc = 'For', handler = h.around_loop, fallback = false },
      { key = 'if', mode = 'nox', desc = 'For', handler = h.inside_loop, fallback = false },
      { key = 'am', mode = 'nox', desc = 'Method', handler = h.around_function, fallback = false },
      { key = 'im', mode = 'nox', desc = 'Method', handler = h.inside_function, fallback = false },
      { key = 'ao', mode = 'nox', desc = 'Call', handler = h.around_call, fallback = false },
      { key = 'io', mode = 'nox', desc = 'Call', handler = h.inside_call, fallback = false },

      -- Swap
      { key = '<m-s>pf', desc = 'For', handler = h.swap_with_previous_loop, fallback = false },
      { key = '<m-s>nf', desc = 'For', handler = h.swap_with_next_loop, fallback = false },
      { key = '<m-s>po', desc = 'Call', handler = h.swap_with_previous_call, fallback = false },
      { key = '<m-s>no', desc = 'Call', handler = h.swap_with_next_call, fallback = false },
      { key = '<m-s>pm', desc = 'Method', handler = h.swap_with_previous_function, fallback = false },
      { key = '<m-s>nm', desc = 'Method', handler = h.swap_with_next_function, fallback = false },

      -- Completion
      -- By default <C-J> is an alias of <CR>
      { key = '<c-j>', mode = 'ic', desc = 'Select Next Completion Item', handler = h.next_completion_item },
      { key = '<s-tab>', mode = 'i', desc = 'Snippet Backward', handler = h.snippet_backward, fallback = false },
      { key = '<c-x><c-o>', mode = 'ic', desc = 'Show Completion', handler = h.show_completion, fallback = false },
      { key = '<c-y>', mode = 'ic', desc = 'Accept Completion Item', handler = h.accept_completion_item },
      { key = '<c-s>', mode = 'i', desc = 'Toggle Signature Help', handler = h.toggle_signature, fallback = false },

      -- Format
      -- We will format automatically on save, therefore this one is not used frequently.
      -- It will only be useful when the format on save occurs errors such as timeout
      { key = '<m-F>', desc = 'Async Format', handler = h.async_format, fallback = false },

      -- Surround
      -- By default "s" and "S" in visual mode are aliases of "c"
      { key = 's', mode = 'x', desc = 'Surround', handler = h.surround_visual, count = true, fallback = false },
      { key = 'S', mode = 'x', desc = 'Surround Line Mode', handler = h.surround_visual_line, count = true, fallback = false },
      -- We use this tricky way to make "ys", "cs", "ds", "yS", "cS", "dS", "yss", "ysS", "ySs" and "ySS" work
      -- We do not recommend to update those mappings
      { key = 's', mode = 'o', desc = 'Surround', handler = h.hack_wrap(), fallback = false },
      { key = 'S', mode = 'o', desc = 'Surround Line Mode', handler = h.hack_wrap('_line'), fallback = false },
      -- Because we have an auto pair plugin, those two below are rarely used
      { key = '<c-g>s', mode = 'i', desc = 'Surround', handler = h.surround_insert, fallback = false },
      { key = '<c-g>S', mode = 'i', desc = 'Surround Line Mode', handler = h.surround_insert_line, fallback = false },

      -- Indent
      { key = '[|', mode = 'nox', desc = 'Indent Start', handler = h.indent_top },
      { key = ']|', mode = 'nox', desc = 'Indent End', handler = h.indent_bottom },
      { key = 'i|', mode = 'ox', desc = 'Indent Line', handler = h.inside_indent },
      { key = 'a|', mode = 'ox', desc = 'Indent Line', handler = h.around_indent },
      { key = '<leader>tI', desc = 'Indent Line', handler = h.toggle_indent_line },

      -- Picker
      { key = 'gy', desc = 'Search Register', handler = '<cmd>Telescope registers<cr>' },
      { key = '<c-f>', desc = 'Search Content', handler = '<cmd>Telescope live_grep<cr>' },
      { key = '<c-p>', desc = 'Serach File', handler = '<cmd>Telescope find_files<cr>' },
      { key = '<f1>', desc = 'Search Help', handler = '<cmd>Telescope help_tags<cr>' },
      { key = '<m-f>', mode = 'nx', desc = 'Search Word', handler = '<cmd>Telescope grep_string<cr>' },
      { key = '<leader>sb', desc = 'Buffer', handler = '<cmd>Telescope buffers<cr>' },
      { key = '<leader>scc', desc = 'Config Path', handler = '<cmd>Telescope live_grep cwd=' .. c_dir .. '<cr>' },
      { key = '<leader>scl', desc = 'Lazy Path', handler = '<cmd>Telescope live_grep cwd=' .. l_dir .. '<cr>' },
      { key = '<leader>sfc', desc = 'Config Path', handler = '<cmd>Telescope find_files cwd=' .. c_dir .. '<cr>' },
      { key = '<leader>sfl', desc = 'Lazy Path', handler = '<cmd>Telescope find_files cwd=' .. l_dir .. '<cr>' },
      { key = '<leader>sh', desc = 'Highlight', handler = '<cmd>Telescope highlights<cr>' },
      { key = '<leader>sk', desc = 'Key Mapping', handler = '<cmd>Telescope keymaps<cr>' },
      { key = '<leader>sm', desc = 'Man Page', handler = '<cmd>Telescope man_pages<cr>' },
      { key = '<leader>sr', desc = 'Resume', handler = '<cmd>Telescope resume<cr>' },
      { key = '<leader>st', desc = 'Todo', handler = '<cmd>Telescope todo-comments todo<cr>' },

      -- Window
      { key = '<c-h>', desc = 'To Left', handler = h.to_left, fallback = false },
      { key = '<c-j>', desc = 'To Bottom', handler = h.to_bottom, fallback = false },
      { key = '<c-k>', desc = 'To Above', handler = h.to_above, fallback = false },
      { key = '<c-l>', desc = 'To Right', handler = h.to_right, fallback = false },

      -- Conflict
      { key = '<leader>tx', desc = 'Conflict Detection', handler = toggle_conflict_detection, fallback = false },

      -- Key with Multi Functionalities
      { key = '<c-e>', mode = 'ic', desc = 'Cancel Completion', handler = h.cancel_completion },
      -- By default, "<c-e>" is used to insert content below the cursor
      -- This hack will make it still work as default when the cusor is already at the end of the line in insert mode
      { key = '<c-e>', mode = 'ic', desc = 'Cursor to EOL', handler = h.cursor_to_eol },
      -- By default, "<c-u>" are used to delete content before
      { key = '<c-u>', mode = 'i', desc = 'Scroll Documentation Up', handler = h.scroll_documentation_up },
      { key = '<c-u>', mode = 'i', desc = 'Scroll Signature Up', handler = h.scroll_signature_up },
      -- By default, "<c-d>" and "<c-t>" are used to delete or add indent in insert mode
      { key = '<c-d>', mode = 'i', desc = 'Scroll Documentation Down', handler = h.scroll_documentation_down, priority = 2 },
      { key = '<c-d>', mode = 'i', desc = 'Scroll Signature Down', handler = h.scroll_signature_down, priority = 1 },
      { key = '<tab>', mode = 'i', desc = 'Snippet Forward', handler = h.snippet_forward },
      { key = '<tab>', mode = 'i', desc = 'Auto Indent', handler = h.auto_indent },
      -- By default, "<c-k>" is used to insert digraph, see ":help i_CTRL-K" and ":help c_CTRL-K"
      { key = '<c-k>', mode = 'ic', desc = 'Select Previous Completion Item', handler = h.previous_completion_item },
      { key = '<c-k>', mode = 'ic', desc = 'Delete to EOL', handler = h.delete_to_eol },

      -- Some Disabled Keys
      { key = '[s', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = ']s', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = ']f', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = '[F', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = ']m', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = '[M', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = '[o', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = ']o', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = '[O', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
      { key = ']O', mode = 'o', desc = 'Nop', handler = h.nop, fallback = false },
    })
    -- stylua: ignore end
    if u.plugin_available('which-key.nvim') then
      local wk = require('which-key')
      wk.add({
        { '<leader>g', buffer = true, icon = { icon = ' ', color = 'red' }, desc = 'Git', mode = 'nx' },
        { '<leader>x', buffer = true, icon = { icon = ' ', color = 'red' }, desc = 'Conflict' },
        { '<leader>xd', buffer = true, icon = { icon = ' ', color = 'red' }, desc = 'Diff' },
        { '<leader>tg', buffer = true, icon = { icon = ' ', color = 'yellow' }, desc = 'Git' },
        { '<leader>t', icon = { icon = ' ', color = 'yellow' }, desc = 'Toggle' },
        { '<leader>s', icon = { icon = ' ', color = 'green' }, desc = 'Search' },
        { '<leader>sf', icon = { icon = ' ', color = 'green' }, desc = 'File' },
        { '<leader>sc', icon = { icon = ' ', color = 'green' }, desc = 'Content' },
        { 'a', desc = 'Around', mode = 'xo' },
        { 'i', desc = 'Inside', mode = 'xo' },
        { '*', desc = 'Search Backward', icon = { icon = ' ', color = 'green' }, mode = 'x' },
        { '#', desc = 'Search Forward', icon = { icon = ' ', color = 'green' }, mode = 'x' },
        { '@', desc = 'Execute Register', mode = 'x' },
        { 'Q', desc = 'Repeat Last Recorded Macro', mode = 'x' },
        { '<m-s>', desc = 'Swap', icon = { icon = '󰓡 ', color = 'green' } },
        { '<m-s>p', desc = 'Previous', icon = { icon = '󰓡 ', color = 'green' } },
        { '<m-s>n', desc = 'Next', icon = { icon = '󰓡 ', color = 'green' } },
        { '[', desc = 'Previous', mode = 'nxo', icon = { icon = ' ', color = 'green' } },
        { ']', desc = 'Next', mode = 'nxo', icon = { icon = ' ', color = 'green' } },
        { 'gr', desc = 'LSP', mode = 'nx', icon = { icon = ' ', color = 'orange' } },
      })
    end
  end,
}
