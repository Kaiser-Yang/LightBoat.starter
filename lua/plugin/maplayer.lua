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
    local h = require('lightboat.handler')
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
      { key = 'ae', mode = { 'o', 'x' }, desc = 'Select Edit', handler = h.select_file, fallback = false },
      { key = 'ie', mode = { 'o', 'x' }, desc = 'Select Edit', handler = h.select_file, fallback = false },
      -- These two are similar to "d" and "y",
      -- you and use "<m-x>d" or "<m-x><m-x>" to delete one line in normal mode
      { key = '<m-x>', mode = 'o', desc = 'System Cut', handler = h.system_cut, expr = true, fallback = false },
      { key = '<m-x>', mode = { 'n', 'x' }, desc = 'System Cut', handler = h.system_cut, fallback = false },
      { key = '<m-c>', mode = 'o', desc = 'System Yank', handler = h.system_yank, expr = true, fallback = false },
      { key = '<m-c>', mode = { 'n', 'x' }, desc = 'System Yank', handler = h.system_yank, fallback = false },
      { key = '<m-v>', mode = { 'n', 'x' }, desc = 'System Put', handler = h.system_put, fallback = false },
      { key = '<m-v>', mode = 'i', desc = 'System Put', handler = h.system_put_insert, fallback = false },
      { key = '<m-v>', mode = 'c', desc = 'System Put', handler = h.system_put_command, fallback = false },
      { key = '<m-X>', desc = 'System Cut EOL', handler = h.system_cut_eol, fallback = false },
      { key = '<m-C>', desc = 'System Yank EOL', handler = h.system_yank_eol, fallback = false },
      { key = '<m-V>', desc = 'System Put Before', handler = h.system_put_before, fallback = false },
      -- Use "gc" to comment with motion
      { key = '<m-/>', desc = 'Comment Line', handler = h.comment_line, fallback = false },
      { key = '<m-/>', mode = 'i', desc = 'Comment Line', handler = h.comment_line_insert, fallback = false },
      { key = '<m-/>', mode = 'x', desc = 'Comment Selection', handler = h.comment_selection, fallback = false },
      { key = '<leader>ti', desc = 'Toggle Inlay Hint', handler = h.toggle_inlay_hint, fallback = false },
      { key = '<leader>ts', desc = 'Toggle Spell', handler = h.toggle_spell, fallback = false },
      { key = '<leader>tt', desc = 'Toggle Treesitter Highlight', handler = h.toggle_treesitter },

      -- Repmove Motion
      { key = ';', mode = { 'n', 'x' }, desc = 'Repeat Last Motion Forward', handler = h.semicolon, fallback = false },
      { key = ',', mode = { 'n', 'x' }, desc = 'Repeat Last Motion Backward', handler = h.comma, fallback = false },
      { key = 'f', mode = { 'n', 'x' }, desc = 'Find Next Character', handler = h.f, fallback = false },
      { key = 'F', mode = { 'n', 'x' }, desc = 'Find Previous Character', handler = h.F, fallback = false },
      { key = 't', mode = { 'n', 'x' }, desc = 'Till Next Character', handler = h.t, fallback = false },
      { key = 'T', mode = { 'n', 'x' }, desc = 'Till Previous Character', handler = h.T, fallback = false },
      { key = '[s', mode = { 'n', 'x' }, desc = 'Previous Misspelled Word', handler = h.previous_misspelled, fallback = false },
      { key = ']s', mode = { 'n', 'x' }, desc = 'Next Misspelled Word', handler = h.next_misspelled, fallback = false },
      { key = '[f', mode = { 'n', 'x', 'o' }, desc = 'Previous For Start', handler = h.previous_loop_start, fallback = false },
      { key = ']f', mode = { 'n', 'x' }, desc = 'Next For Start', handler = h.next_loop_start, fallback = false },
      { key = '[F', mode = { 'n', 'x' }, desc = 'Previous For End', handler = h.previous_loop_end, fallback = false },
      { key = ']F', mode = { 'n', 'x', 'o' }, desc = 'Next For End', handler = h.next_loop_end, fallback = false },
      { key = '[m', mode = { 'n', 'x', 'o' }, desc = 'Previous Method Start', handler = h.previous_function_start, fallback = false },
      { key = ']m', mode = { 'n', 'x' }, desc = 'Next Method Start', handler = h.next_function_start, fallback = false },
      { key = '[M', mode = { 'n', 'x' }, desc = 'Previous Method End', handler = h.previous_function_end, fallback = false },
      { key = ']M', mode = { 'n', 'x', 'o' }, desc = 'Next Method End', handler = h.next_function_end, fallback = false },
      { key = '[o', mode = { 'n', 'x' }, desc = 'Previous Call Start', handler = h.previous_call_start, fallback = false },
      { key = ']o', mode = { 'n', 'x' }, desc = 'Next Call Start', handler = h.next_call_start, fallback = false },
      { key = '[O', mode = { 'n', 'x' }, desc = 'Previous Call End', handler = h.previous_call_end, fallback = false },
      { key = ']O', mode = { 'n', 'x' }, desc = 'Next Call End', handler = h.next_call_end, fallback = false },
      -- By default "[t" and "]t" are mapped to ":tp" and ":tn"
      { key = '[t', mode = { 'n', 'x' }, desc = 'previous todo', handler = h.previous_todo, fallback = false },
      { key = ']t', mode = { 'n', 'x' }, desc = 'next todo', handler = h.next_todo, fallback = false },
      { key = '[[', mode = { 'n', 'x', 'o' }, desc = 'Previous Block Start', handler = h.previous_block_start, fallback = false },
      { key = ']]', mode = { 'n', 'x' }, desc = 'Next Block Start', handler = h.next_block_start, fallback = false },
      { key = '[]', mode = { 'n', 'x' }, desc = 'Previous Block End', handler = h.previous_block_end, fallback = false },
      { key = '][', mode = { 'n', 'x', 'o' }, desc = 'Next Block End', handler = h.next_block_end, fallback = false },

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
      { key = '<c-j>', mode = { 'i', 'c' }, desc = 'Select Next Completion Item', handler = h.next_completion_item },
      { key = '<s-tab>', mode = 'i', desc = 'Snippet Backward', handler = h.snippet_backward, fallback = false },
      { key = '<c-x><c-o>', mode = { 'i', 'c' }, desc = 'Show Completion', handler = h.show_completion, fallback = false },
      { key = '<c-y>', mode = { 'i', 'c' }, desc = 'Accept Completion Item', handler = h.accept_completion_item },
      { key = '<c-s>', mode = 'i', desc = 'Toggle Signature Help', handler = h.toggle_signature, fallback = false },

      -- Format
      -- We will format automatically on save, therefore this one is not used frequently.
      -- It will only be useful when the format on save occurs errors such as timeout
      { key = '<leader>f', desc = 'Async Format', handler = h.async_format, fallback = false },

      -- Surround
      -- By default "s" and "S" in visual mode is an alias of "c"
      { key = 's', mode = 'x', desc = 'Surround', handler = h.surround_visual, count = true, fallback = false },
      { key = 'S', mode = 'x', desc = 'Surround Line Mode', handler = h.surround_visual_line, count = true, fallback = false },
      -- We use this tricky way to make "ys", "cs", "ds", "yS", "cS", "dS", "yss", "ysS" work
      -- We do not recommend to update those mappings
      { key = 's', mode = 'o', desc = 'Surround Operation', handler = h.hack_wrap(), fallback = false },
      -- "yS" will be same with "ys$", if you want surround in line mode you can use "ysS" instead
      -- If you do not want this, you just need to remove the "true"
      { key = 'S', mode = 'o', desc = 'Surround Operation Line Mode', handler = h.hack_wrap('_line', true), fallback = false },
      -- Because we have an auto pair plugin, those two below are rarely used
      { key = '<c-g>s', mode = 'i', desc = 'Surround', handler = h.surround_insert, fallback = false },
      { key = '<c-g>S', mode = 'i', desc = 'Surround Line Mode', handler = h.surround_insert_line, fallback = false },

      -- Indent
      { key = '[|', mode = { 'n', 'x', 'o' }, desc = 'Top of Indent', handler = h.indent_top },
      { key = ']|', mode = { 'n', 'x', 'o' }, desc = 'Bottom of Indent', handler = h.indent_bottom },
      { key = 'i|', mode = { 'x', 'o' }, desc = 'Inside Indent Line', handler = h.inside_indent },
      { key = 'a|', mode = { 'x', 'o' }, desc = 'Around Indent Line', handler = h.around_indent },
      { key = '<leader>tI', desc = 'Toggle Indent Line', handler = h.toggle_indent_line },

      -- Picker
      { key = '<c-p>', desc = 'Serach Files', handler = h.picker_wrap('find_files') },
      -- By default "<C-F>" is same with <PageDown>
      { key = '<c-f>', mode = 'x', desc = 'Grep Selected Word', handler = h.picker_wrap('grep_string') },
      { key = '<f1>', desc = 'Search Help', handler = h.picker_wrap('help_tags') },
      { key = '<leader>sb', desc = 'Search Buffer', handler = h.picker_wrap('buffers') },
      { key = '<leader>st', desc = 'Search Todo', handler = h.picker_wrap({ 'todo-comments', 'todo' }) },
      -- By default, "[t" and "]t" are mapped to ":tabprevious" and ":tabnext"
      -- Those below do not support vim.v.count

      -- Key with Multi Functionalities
      { key = '<c-e>', mode = { 'i', 'c' }, desc = 'Cancel Completion', handler = h.cancel_completion },
      -- By default, "<c-e>" is used to insert content below the cursor
      -- This hack will make it still work as default when the cusor is already at the end of the line in insert mode
      { key = '<c-e>', mode = 'i', desc = 'Cursor to EOL', handler = h.cursor_to_eol_insert },
      { key = '<c-e>', mode = 'c', desc = 'Cursor to EOL', handler = h.cursor_to_eol_command, fallback = false },
      -- By default, "<c-u>" are used to delete content before
      { key = '<c-u>', mode = 'i', desc = 'Scroll Documentation Up', handler = h.scroll_documentation_up, priority = 2 },
      { key = '<c-u>', mode = 'i', desc = 'Scroll Signature Up', handler = h.scroll_signature_up, priority = 1 },
      -- By default, "<c-d>" and "<c-t>" are used to delete or add indent in insert mode
      { key = '<c-d>', mode = 'i', desc = 'Scroll Documentation Down', handler = h.scroll_documentation_down, priority = 2 },
      { key = '<c-d>', mode = 'i', desc = 'Scroll Signature Down', handler = h.scroll_signature_down, priority = 1 },
      { key = '<tab>', mode = 'i', desc = 'Snippet Forward', handler = h.snippet_forward },
      { key = '<tab>', mode = 'i', desc = 'Auto Indent', handler = h.auto_indent },
      -- By default, "<c-k>" is used to insert digraph, see ":help i_CTRL-K" and ":help c_CTRL-K"
      { key = '<c-k>', mode = { 'i', 'c' }, desc = 'Select Previous Completion Item', handler = h.previous_completion_item },
      { key = '<c-k>', mode = 'i', desc = 'Delete to EOL', handler = h.delete_to_eol_insert },
      { key = '<c-k>', mode = 'c', desc = 'Delete to EOL', handler = h.delete_to_eol_command },

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
  end,
}
