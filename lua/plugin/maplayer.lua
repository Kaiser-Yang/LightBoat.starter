return {
  'Kaiser-Yang/maplayer.nvim',
  -- We lazy load which-key, make sure this is loaded before which-key
  priority = 1000,
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
    local c = require('lightboat.condition')
    local h = require('lightboat.handler')
    -- Completion menu is visible
    local cmvc = c():completion_menu_visible()
    -- Completion menu is not visible
    local cmnvc = c():completion_menu_not_visible()
    -- There is a item selected in the completion menu
    local cisc = c():completion_item_selected()
    -- Snippet is active
    local sac = c():snippet_active()
    -- Snippet is not active
    local snac = c():snippet_not_active()
    -- The documentation of completion item is visible
    local dvc = c():documentation_visible()
    -- The signature help window is visible
    local svc = c():signature_visible()
    -- The cursor is not at the end of the line
    local cnec = c():cursor_not_eol()
    -- Completion menu is not visible and cursor is not at the end of the line
    local cmnvc_cnec = cmnvc:add(cnec)
    -- There is at least one LSP client attached to current buffer
    local lac = c():lsp_attached()
    -- Cursor is not at the first non blank character
    local cnfnbc = c():cursor_not_first_non_blank()
    -- Used for "ys", "ds", "cs"...
    local hsc = c():add(
      function()
        return vim.tbl_contains({ 'y', 'd', 'c' }, vim.v.operator)
          or vim.v.operator == 'g@' and vim.o.operatorfunc:find('nvim%-surround')
      end
    )
    -- stylua: ignore start
    require('maplayer').setup({
      -- Basic
      { key = '<cr>', mode = 'i', desc = 'Insert Undo Point', handler = function() u.key.feedkeys('<c-g>u', 'n') return false end },
      -- By default "<C-A>" is used to insert previously inserted text
      { key = '<c-a>', mode = 'i', 'Cursor to BOL', handler = h.cursor_to_bol_insert, fallback = false },
      -- By default "<C-A>" is used to insert all commands
      -- whose names match the pattern before cursor of command mode
      { key = '<c-a>', mode = 'c', 'Cursor to BOL', handler = h.cursor_to_bol_command, fallback = false },
      { key = '<m-d>', mode = 'i', 'Delete to EOW', handler = h.delete_to_eow_insert, fallback = false },
      { key = '<m-d>', mode = 'c', 'Delete to EOW', handler = h.delete_to_eow_command, fallback = false },
      -- By default, "<c-y>" and "<c-e>" are used to insert content above or below the cursor
      -- This hack will make it still work as default when the cusor is already at the end of the line in insert mode
      { key = '<c-e>', mode = 'i', desc = 'Cursor to EOL', handler = h.cursor_to_eol_insert },
      { key = '<c-e>', mode = 'c', desc = 'Cursor to EOL', handler = h.cursor_to_eol_command, fallback = false },
      { key = 'ae', mode = { 'o', 'x' }, desc = 'Select Edit', handler = h.select_file, fallback = false },
      { key = 'ie', mode = { 'o', 'x' }, desc = 'Select Edit', handler = h.select_file, fallback = false },
      -- These two are similar to "d" and "y",
      -- you and use "<m-x>d" or "<m-x><m-x>" to delete one line in normal mode
      { key = '<m-x>', mode = { 'n', 'x', 'o' }, desc = 'System Cut', handler = h.system_cut, expr = true, fallback = false },
      { key = '<m-c>', mode = { 'n', 'x', 'o' }, desc = 'System Yank', handler = h.system_yank, expr = true, fallback = false },
      { key = '<m-v>', mode = { 'n', 'x' }, desc = 'System Put', handler = h.system_put, fallback = false },
      { key = '<m-v>', mode = 'i', desc = 'System Put', handler = h.system_put_insert, fallback = false },
      { key = '<m-v>', mode = 'c', desc = 'System Put', handler = h.system_put_command, fallback = false },
      { key = '<m-X>', desc = 'System Cut EOL', handler = h.system_cut_eol, expr = true, fallback = false },
      { key = '<m-C>', desc = 'System Yank EOL', handler = h.system_yank_eol, expr = true, fallback = false },
      { key = '<m-V>', desc = 'System Put Before', handler = h.system_put_before, fallback = false },
      -- Use "gc" to comment with motion
      { key = '<m-/>', desc = 'Comment Line', handler = h.comment_line, expr = true, fallback = false },
      { key = '<m-/>', mode = 'i', desc = 'Comment Line', handler = h.comment_line_insert, fallback = false },
      { key = '<m-/>', mode = 'x', desc = 'Comment Selection', handler = h.comment_selection, fallback = false },
      { key = '<leader>ti', desc = 'Toggle Inlay Hint', handler = h.toggle_inlay_hint, fallback = false },
      { key = '<leader>ts', desc = 'Toggle Spell', handler = h.toggle_spell, fallback = false },
      { key = '<leader>tt', desc = 'Toggle Treesitter Highlight', handler = h.toggle_treesitter },

      -- Repmove Motion
      { key = ';', mode = { 'n', 'x', 'o' }, desc = 'Repeat Last Motion Forward', handler = h.semicolon, expr = true, fallback = false },
      { key = ',', mode = { 'n', 'x', 'o' }, desc = 'Repeat Last Motion Backward', handler = h.comma, expr = true, fallback = false },
      { key = 'f', mode = { 'n', 'x', 'o' }, desc = 'Find Next Character', handler = h.f, expr = true, fallback = false },
      { key = 'F', mode = { 'n', 'x', 'o' }, desc = 'Find Previous Character', handler = h.F, expr = true, fallback = false },
      { key = 't', mode = { 'n', 'x', 'o' }, desc = 'Till Next Character', handler = h.t, expr = true, fallback = false },
      { key = 'T', mode = { 'n', 'x', 'o' }, desc = 'Till Previous Character', handler = h.T, expr = true, fallback = false },
      { key = '[s', mode = { 'n', 'x', 'o' }, desc = 'Previous Misspelled Word', handler = h.previous_misspelled, expr = true, fallback = false },
      { key = ']s', mode = { 'n', 'x', 'o' }, desc = 'Next Misspelled Word', handler = h.next_misspelled, expr = true, fallback = false },
      { key = '[f', mode = { 'n', 'x', 'o' }, desc = 'Previous For Start', handler = h.previous_loop_start, expr = true, fallback = false },
      { key = ']f', mode = { 'n', 'x', 'o' }, desc = 'Next For Start', handler = h.next_loop_start, expr = true, fallback = false },
      { key = '[F', mode = { 'n', 'x', 'o' }, desc = 'Previous For End', handler = h.previous_loop_end, expr = true, fallback = false },
      { key = ']F', mode = { 'n', 'x', 'o' }, desc = 'Next For End', handler = h.next_loop_end, expr = true, fallback = false },
      { key = '[m', mode = { 'n', 'x', 'o' }, desc = 'Previous Method Start', handler = h.previous_function_start, expr = true, fallback = false },
      { key = ']m', mode = { 'n', 'x', 'o' }, desc = 'Next Method Start', handler = h.next_function_start, expr = true, fallback = false },
      { key = '[M', mode = { 'n', 'x', 'o' }, desc = 'Previous Method End', handler = h.previous_function_end, expr = true, fallback = false },
      { key = ']M', mode = { 'n', 'x', 'o' }, desc = 'Next Method End', handler = h.next_function_end, expr = true, fallback = false },
      { key = '[o', mode = { 'n', 'x', 'o' }, desc = 'Previous Call Start', handler = h.previous_call_start, expr = true, fallback = false },
      { key = ']o', mode = { 'n', 'x', 'o' }, desc = 'Next Call Start', handler = h.next_call_start, expr = true, fallback = false },
      { key = '[O', mode = { 'n', 'x', 'o' }, desc = 'Previous Call End', handler = h.previous_call_end, expr = true, fallback = false },
      { key = ']O', mode = { 'n', 'x', 'o' }, desc = 'Next Call End', handler = h.next_call_end, expr = true, fallback = false },
      -- By default "[t" and "]t" are mapped to ":tp" and ":tn"
      { key = '[t', mode = { 'n', 'x', 'o' }, desc = 'previous todo', handler = h.previous_todo, expr = true, fallback = false },
      { key = ']t', mode = { 'n', 'x', 'o' }, desc = 'next todo', handler = h.next_todo, expr = true, fallback = false },
      { key = '[[', mode = { 'n', 'x', 'o' }, desc = 'Previous Block Start', handler = h.previous_block_start, expr = true, fallback = false },
      { key = ']]', mode = { 'n', 'x', 'o' }, desc = 'Next Block Start', handler = h.next_block_start, expr = true, fallback = false },
      { key = '[]', mode = { 'n', 'x', 'o' }, desc = 'Previous Block End', handler = h.previous_block_end, expr = true, fallback = false },
      { key = '][', mode = { 'n', 'x', 'o' }, desc = 'Next Block End', handler = h.next_block_end, expr = true, fallback = false },

      -- Treesitter Text Object
      { key = 'af', mode = { 'o', 'x' }, desc = 'Around For', handler = h.around_loop, fallback = false },
      { key = 'if', mode = { 'o', 'x' }, desc = 'Inside For', handler = h.inside_loop, fallback = false },
      { key = 'am', mode = { 'o', 'x' }, desc = 'Around Method', handler = h.around_function, fallback = false },
      { key = 'im', mode = { 'o', 'x' }, desc = 'Inside Method', handler = h.inside_function, fallback = false },
      { key = 'ao', mode = { 'o', 'x' }, desc = 'Around Call', handler = h.around_call, fallback = false },
      { key = 'io', mode = { 'o', 'x' }, desc = 'Inside Call', handler = h.inside_call, fallback = false },

      -- Swap
      { key = '<m-s>pf', desc = 'Swap With Previous For', handler = h.swap_with_previous_loop, fallback = false },
      { key = '<m-s>nf', desc = 'Swap With Next For', handler = h.swap_with_next_loop, fallback = false },
      { key = '<m-s>po', desc = 'Swap With Previous Call', handler = h.swap_with_previous_call, fallback = false },
      { key = '<m-s>no', desc = 'Swap With Next Call', handler = h.swap_with_next_call, fallback = false },
      { key = '<m-s>pm', desc = 'Swap With Previous Method', handler = h.swap_with_previous_function, fallback = false },
      { key = '<m-s>nm', desc = 'Swap With Next Method', handler = h.swap_with_next_function, fallback = false },

      -- Completion
      -- By default <C-J> is an alias of <CR>
      { key = '<c-j>', mode = { 'i', 'c' }, desc = 'Select Next Completion Item', condition = cmvc, handler = h.next_completion_item, fallback = false },
      { key = '<c-k>', mode = { 'i', 'c' }, desc = 'Select Previous Completion Item', condition = cmvc, handler = h.previous_completion_item, fallback = false },
      { key = '<tab>', mode = 'i', desc = 'Snippet Forward', condition = sac, handler = h.snippet_forward },
      { key = '<s-tab>', mode = 'i', desc = 'Snippet Backward', condition = sac, handler = h.snippet_backward },
      { key = '<c-x><c-o>', mode = { 'i', 'c' }, desc = 'Show Completion', condition = cmnvc, handler = h.show_completion },
      { key = '<c-x><c-o>', mode = { 'i', 'c' }, desc = 'Hide Completion', condition = cmvc,  handler = h.hide_completion },
      { key = '<c-y>', mode = { 'i', 'c' }, desc = 'Accept Completion Item', condition = cisc, handler = h.accept_completion_item },
      { key = '<c-e>', mode = { 'i', 'c' }, desc = 'Cancel Completion', condition = cmvc, handler = h.cancel_completion },
      -- By default, "<c-u>" are used to delete content before
      { key = '<c-u>', mode = 'i', desc = 'Scroll Documentation Up', condition = dvc, handler = h.scroll_documentation_up, priority = 2 },
      { key = '<c-u>', mode = 'i', desc = 'Scroll Signature Up', condition = svc, handler = h.scroll_signature_up, priority = 1 },
      -- By default, "<c-d>" and "<c-t>" are used to delete or add indent in insert mode
      { key = '<c-d>', mode = 'i', desc = 'Scroll Documentation Down', condition = dvc, handler = h.scroll_documentation_down, priority = 2 },
      { key = '<c-d>', mode = 'i', desc = 'Scroll Signature Down', condition = svc, handler = h.scroll_signature_down, priority = 1 },
      { key = '<c-s>', mode = 'i', desc = 'Show Signature Help', condition = svc, handler = h.show_signature },
      { key = '<c-s>', mode = 'i', desc = 'Hide Signature Help', condition = svc, handler = h.hide_signature },

      -- Format
      -- We will format automatically on save, therefore this one is not used frequently.
      -- It will only be useful when the format on save occurs errors such as timeout
      { key = '<m-F>', desc = 'Async Format', handler = h.async_format },

      -- Autopair
      { key = '(', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('('), replace_keycodes = false },
      { key = ')', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap(')'), replace_keycodes = false },
      { key = '[', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('['), replace_keycodes = false },
      { key = ']', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap(']'), replace_keycodes = false },
      { key = '{', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('{'), replace_keycodes = false },
      { key = '}', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('}'), replace_keycodes = false },
      { key = '"', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('"'), replace_keycodes = false },
      { key = "'", mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap("'"), replace_keycodes = false },
      { key = '`', mode = 'i', desc = 'Autopair', handler = h.auto_pair_wrap('`'), replace_keycodes = false },
      { key = '<cr>', mode = 'i', desc = 'Autopair CR', handler = h.auto_pair_wrap('<cr>'), replace_keycodes = false },
      { key = '<bs>', mode = 'i', desc = 'Autopair BS', handler = h.auto_pair_wrap('<bs>'), replace_keycodes = false },
      { key = '<m-e>', mode = 'i', desc = 'Autopair Fastwarp', handler = h.auto_pair_wrap('<m-e>'), replace_keycodes = false },
      { key = '<m-E>', mode = 'i', desc = 'Autopair Reverse Fastwarp', handler = h.auto_pair_wrap('<m-E>'), replace_keycodes = false },
      { key = '<m-c>', mode = 'i', desc = 'Autopair Close', handler = h.auto_pair_wrap('<m-)>'), replace_keycodes = false },
      { key = '<tab>', mode = 'i', desc = 'Autopair Tabout', condition = snac_epc, handler = h.auto_pair_wrap('<m-tab>'), replace_keycodes = false },
      { key = '<space>', mode = 'i', desc = 'Autopair Space', handler = h.auto_pair_wrap('<space>'), replace_keycodes = false },

      -- Surround
      -- By default "s" and "S" in visual mode is an alias of "c"
      { key = 's', mode = 'x', desc = 'Surround', handler = h.surround_visual, count = true, fallback = false },
      { key = 'S', mode = 'x', desc = 'Surround Line Mode', handler = h.surround_visual_line, count = true, fallback = false },
      -- We use this tricky way to make "ys", "cs", "ds", "yS", "cS", "dS", "yss", "ysS", "ySs" and "ySS" work
      -- We do not recommend to update those mappings
      { key = 's', mode = 'o', desc = 'Surround Operation', condition = hsc, handler = h.hack_wrap(), fallback = false },
      { key = 'S', mode = 'o', desc = 'Surround Operation Line Mode', condition = hsc, handler = h.hack_wrap('_line'), fallback = false },
      -- Because we have an auto pair plugin, those two below are rarely used
      { key = '<c-g>s', mode = 'i', desc = 'Surround', handler = h.surround_insert },
      { key = '<c-g>S', mode = 'i', desc = 'Surround Line Mode', handler = h.surround_insert_line },

      -- Togglers
      { key = '<leader>tt', desc = 'Toggle Treesitter Highlight', condition = thac, handler = h.toggle_treesitter_highlight },
      { key = '<leader>ti', desc = 'Toggle Inlay Hint', condition = lac, handler = h.toggle_inlay_hint },
      { key = '<leader>te', desc = 'Toggle Expandtab', handler = h.toggle_expandtab },

      -- Indent
      { key = '[|', mode = { 'n', 'x', 'o' }, desc = 'Top of Indent', handler = r('<plug>(blink-indent-top)', '<plug>(blink-indent-bottom)', 1), expr = true },
      { key = ']|', mode = { 'n', 'x', 'o' }, desc = 'Bottom of Indent', handler = r('<plug>(blink-indent-top)', '<plug>(blink-indent-bottom)', 2), expr = true },
      { key = 'i|', mode = { 'n', 'o' }, desc = 'Inside Indent Line', handler = '<plug>(blink-indent-inside)', count = true, expr = true },
      { key = 'a|', mode = { 'n', 'o' }, desc = 'Around Indent Line', handler = '<plug>(blink-indent-around)', count = true, expr = true },
      { key = '<leader>ti', desc = 'Toggle Indent Line', handler = toggle_blink_indent },

      -- Picker
      { key = '<c-p>', desc = 'Serach Files', handler = h.picker_wrap('find_files') },
      -- We can't use "<c-r>" because it's used to redo in normal mode
      { key = '<m-r>', desc = 'Resume Last Picker', handler = h.picker_wrap('resume') },
      -- By default "<C-F>" is same with <PageDown>
      { key = '<c-f>', desc = 'Find', handler = h.picker_wrap('live_grep') },
      { key = '<c-f>', mode = 'x', desc = 'Grep Selected Word', handler = h.picker_wrap('grep_string') },
      { key = '<f1>', desc = 'Search Help', handler = h.picker_wrap('help_tags') },
      { key = '<leader>sb', desc = 'Search Buffer', handler = h.picker_wrap('buffers') },
      { key = '<leader>st', desc = 'Search Todo', handler = h.picker_wrap({ 'todo-comments', 'todo' }) },
      { key = '<leader>sw', desc = 'Grep Word under Cursor', handler = h.picker_wrap('grep_string') },
      -- By default, "[t" and "]t" are mapped to ":tabprevious" and ":tabnext"
      -- Those below do not support vim.v.count
      { key = '[t', mode = { 'n', 'x', 'o' }, desc = 'previous todo', handler = r(function() return require('todo-comments').jump_prev() end, function() return require('todo-comments').jump_next() end, 1) },
      { key = ']t', mode = { 'n', 'x', 'o' }, desc = 'next todo', handler = r(function() return require('todo-comments').jump_prev() end, function() return require('todo-comments').jump_next() end, 2) },

      -- Basic
      -- By default "<C-A>" is used to insert previously inserted text
      { key = '<c-a>', mode = 'i', 'Cursor to First Non-blank', condition = cnfnbc, handler = h.cursor_to_first_non_blank_insert },
      -- By default "<C-A>" is used to insert all commands
      -- whose names match the pattern before cursor of command mode
      { key = '<c-a>', mode = 'c', 'Cursor to BOL', condition = cnfnbc, handler = h.cursor_to_bol_command },
      { key = '<m-d>', mode = 'i', 'Delete to EOW', condition = cnec, handler = h.delete_to_eow_insert },
      -- By default, "<c-y>" and "<c-e>" are used to insert content above or below the cursor
      -- This hack will make it still work as default when the cusor is already at the end of the line in insert mode
      { key = '<c-e>', mode = 'i', desc = 'Cursor to EOL', condition = cmnvc_cnec, handler = h.cursor_to_eol_insert },
      -- By default, "<c-k>" is used to insert digraph, see ":help i_CTRL-K" and ":help c_CTRL-K"
      { key = '<c-k>', mode = 'i', desc = 'Delete to EOL', condition = cnec, handler = h.delete_to_eol_insert },
      { key = '<c-k>', mode = 'c', desc = 'Delete to EOL', condition = cnec, handler = h.delete_to_eol_command },
      -- Basic Text Object
      { key = 'ae', mode = { 'o', 'x' }, desc = 'Select Edit', handler = h.select_file },
      { key = 'ie', mode = { 'o', 'x' }, desc = 'Select Edit', handler = h.select_file },
      { key = '<tab>', mode = 'i', desc = 'Auto Indent', condition = snac_iltllc, handler = h.auto_indent },
      { key = '<leader>k', desc = 'Split Above', handler = h.split_above },
      { key = '<leader>j', desc = 'Split Below', handler = h.split_below },
      { key = '<leader>h', desc = 'Split Left', handler = h.split_left },
      { key = '<leader>l', desc = 'Split Right', handler = h.split_right },
      { key = '<leader>T', desc = 'Split Tab (Full Screen)', handler = h.split_tab },
      { key = '<c-k>', desc = 'Cursor to Above Window', handler = h.cursor_to_above_window },
      -- By default, "<C-J>" is an alias of "<CR>"
      { key = '<c-j>', desc = 'Cursor to Below Window', handler = h.cursor_to_below_window },
      { key = '<c-h>', desc = 'Cursor to Left Window', handler = h.cursor_to_left_window },
      { key = '<c-l>', desc = 'Cursor to Right Window', handler = h.cursor_to_right_window },
      -- This one is similar to "d" you and use "<m-x>d" to delete one line in normal mode
      { key = '<m-x>', mode = { 'n', 'x' }, desc = 'System Cut', handler = h.system_cut, count = true },
      { key = '<m-c>', mode = { 'n', 'x' }, desc = 'System Yank', handler = h.system_yank, count = true },
      { key = '<m-v>', mode = { 'n', 'x' }, desc = 'System Put', handler = h.system_put },
      { key = '<m-V>', desc = 'System Put Before', handler = h.system_put_before },
      { key = '<m-v>', mode = 'i', desc = 'System Put', handler = h.system_put_insert },
      { key = '<m-v>', mode = 'c', desc = 'System Put', handler = h.system_put_command },
    })
    -- stylua: ignore end
  end,
}
