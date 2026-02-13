return {
  'Kaiser-Yang/maplayer.nvim',
  -- We lazy load which-key, make sure this is loaded before which-key
  priority = 1000,
  event = 'VeryLazy',
  config = function()
    -- We have provide another key binding for commenting current line
    vim.api.nvim_del_keymap('n', 'gcc')
    -- When all key bindings has no overlapping,
    -- you can set "timeoutlen" with zero
    -- The default satisfy the requirement.
    -- When you update key bindings, be careful to check if there is any overlapping,
    -- if there is, you should set "timeoutlen" with a proper value such as 300 or 500
    -- which-key.nvim can not be used in vscode neovim extension,
    -- so we must set "timeoutlen" with a proper value to make it work
    vim.o.timeoutlen = vim.g.vscode and 300 or 0
    local c = require('lightboat.condition')
    local h = require('lightboat.handler')
    local r = h.repmove_wrap
    local u = require('lightboat.util')
    local toggle_blink_indent = function()
      local indent = require('blink.indent')
      local status = indent.is_enabled() == false
      u.toggle_notify('Indent Line', status, { title = 'Blink Indent' })
      indent.enable(status)
      return true
    end
    -- The option "spell" is on
    local sc = c():add(function() return vim.wo.spell end)
    -- cwd or current buffer is in a git repository path
    local igrc = c():is_git_repository()
    -- There are some conflicts in cwd or current buffer
    local hcc = c():has_conflict()
    -- The treesitter parser supports highlight
    local thac = c():treesitter_highlight_available()
    -- The nvim-treesitter-textobjects is installed
    local ttac = c():treesitter_textobject_available()
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
    -- Snippet is not active and cursor is after indentation
    local snac_epc = snac:add(function()
      local line = vim.api.nvim_get_current_line()
      local cursor_column = vim.api.nvim_win_get_cursor(0)[2]
      local content_before_cursor = line:sub(1, cursor_column)
      return not content_before_cursor:match('^%s*$')
    end)
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
    -- "delta" is executable
    local dec = c():add(function() return vim.fn.executable('delta') == 1 end)
    -- Conflicts found and "delta" is executable
    local hcc_dec = hcc:add(dec)
    -- Used for "ys", "ds", "cs"...
    local hsc = c():add(
      function()
        return vim.tbl_contains({ 'y', 'd', 'c' }, vim.v.operator)
          or vim.v.operator == 'g@' and vim.o.operatorfunc:find('nvim%-surround')
      end
    )
    -- Snippet is not active and current line's indentation is less than last line's
    local snac_iltllc = snac:add(function()
      local lnum, col = unpack(vim.api.nvim_win_get_cursor(0))
      local content_before_cursor = vim.api.nvim_get_current_line():sub(1, col)
      if not content_before_cursor:match('^%s*$') or lnum == 1 then return false end
      local last_line_indent = vim.fn.indent(vim.fn.line('.') - 1)
      local current_line_indent = vim.fn.indent(vim.fn.line('.'))
      return last_line_indent > current_line_indent
    end)
    -- stylua: ignore start
    require('maplayer').setup({
      -- Basic Motion
      { key = ';', mode = { 'n', 'x' }, desc = 'Repeat Last Motion Forward', handler = h.semicolon, count = true },
      { key = ',', mode = { 'n', 'x' }, desc = 'Repeat Last Motion Backward', handler = h.comma, count = true },
      { key = 'f', mode = { 'n', 'x' }, desc = 'Find Next Character', handler = h.f, count = true },
      { key = 'F', mode = { 'n', 'x' }, desc = 'Find Previous Character', handler = h.F, count = true },
      { key = 't', mode = { 'n', 'x' }, desc = 'Till Next Character', handler = h.t, count = true },
      { key = 'T', mode = { 'n', 'x' }, desc = 'Till Previous Character', handler = h.T, count = true },
      { key = '[s', mode = { 'n', 'x', 'o' }, desc = 'Previous Misspelled Word', condition = sc, handler = h.previous_misspelled, count = true, expr = true },
      { key = '[s', mode = { 'n', 'x', 'o' }, desc = 'Previous Misspelled Word', condition = sc, handler = h.previous_misspelled, count = true, expr = true },

      -- Treesitter Motion
      -- By deafault, "[a" and "]a" are mapped to ":prevvious" and ":next"
      { key = '[a', mode = { 'n', 'x', 'o' }, desc = 'Previous Argument Start', condition = ttac, handler = h.previous_parameter_start, fallback = false },
      { key = ']a', mode = { 'n', 'x', 'o' }, desc = 'Next Argument Start', condition = ttac, handler = h.next_parameter_start, fallback = false },
      -- By deafault, "[A" and "]A" are mapped to ":rewind" and ":last"
      { key = '[A', mode = { 'n', 'x', 'o' }, desc = 'Previous Argument End', condition = ttac, handler = h.previous_parameter_end, fallback = false },
      { key = ']A', mode = { 'n', 'x', 'o' }, desc = 'Next Argument End', condition = ttac, handler = h.next_parameter_end, fallback = false },
      -- By default, "[i", "]i", "[I", and "]I" are used to show information of keywords under cursor
      { key = '[i', mode = { 'n', 'x', 'o' }, desc = 'Previous If Start', condition = ttac, handler = h.previous_conditional_start, fallback = false },
      { key = ']i', mode = { 'n', 'x', 'o' }, desc = 'Next If Start', condition = ttac, handler = h.next_conditional_start, fallback = false },
      { key = '[I', mode = { 'n', 'x', 'o' }, desc = 'Previous If End', condition = ttac, handler = h.previous_conditional_end, fallback = false },
      { key = ']I', mode = { 'n', 'x', 'o' }, desc = 'Next If End', condition = ttac, handler = h.next_conditional_end, fallback = false },
      -- By default, "[f", "]f" are aliases of "gf"
      { key = '[f', mode = { 'n', 'x', 'o' }, desc = 'Previous For Start', condition = ttac, handler = h.previous_loop_start, fallback = false },
      { key = ']f', mode = { 'n', 'x', 'o' }, desc = 'Next For Start', condition = ttac, handler = h.next_loop_start, fallback = false },
      { key = '[F', mode = { 'n', 'x', 'o' }, desc = 'Previous For End', condition = ttac, handler = h.previous_loop_end, fallback = false },
      { key = ']F', mode = { 'n', 'x', 'o' }, desc = 'Next For End', condition = ttac, handler = h.next_loop_end, fallback = false },
      -- By default "[r" and "]r" are used to search "rare" words
      { key = '[r', mode = { 'n', 'x', 'o' }, desc = 'Previous Return Start', condition = ttac, handler = h.previous_return_start, fallback = false },
      { key = ']r', mode = { 'n', 'x', 'o' }, desc = 'Next Return Start', condition = ttac, handler = h.next_return_start, fallback = false },
      { key = '[R', mode = { 'n', 'x', 'o' }, desc = 'Previous Return End', condition = ttac, handler = h.previous_return_end, fallback = false },
      { key = ']R', mode = { 'n', 'x', 'o' }, desc = 'Next Return End', condition = ttac, handler = h.next_return_end, fallback = false },
      -- By default, "[c" and "]c" are used to navigate changes in the buffer. In most caes, we cant use "[g" and "]g" to navigate between git hunks
      { key = '[c', mode = { 'n', 'x', 'o' }, desc = 'Previous Class Start', condition = ttac, handler = h.previous_class_start, fallback = false },
      { key = ']c', mode = { 'n', 'x', 'o' }, desc = 'Next Class Start', condition = ttac, handler = h.next_class_start, fallback = false },
      { key = '[C', mode = { 'n', 'x', 'o' }, desc = 'Previous Class End', condition = ttac, handler = h.previous_class_end, fallback = false },
      { key = ']C', mode = { 'n', 'x', 'o' }, desc = 'Next Class End', condition = ttac, handler = h.next_class_end, fallback = false },
      -- Those mappings below behavior like the default ones
      { key = '[m', mode = { 'n', 'x', 'o' }, desc = 'Previous Method Start', condition = ttac, handler = h.previous_function_start, fallback = false },
      { key = ']m', mode = { 'n', 'x', 'o' }, desc = 'Next Method Start', condition = ttac, handler = h.next_function_start, fallback = false },
      { key = '[M', mode = { 'n', 'x', 'o' }, desc = 'Previous Method End', condition = ttac, handler = h.previous_function_end, fallback = false },
      { key = ']M', mode = { 'n', 'x', 'o' }, desc = 'Next Method End', condition = ttac, handler = h.next_function_end, fallback = false },
      { key = '[]', mode = { 'n', 'x', 'o' }, desc = 'Previous Block End', condition = ttac, handler = h.previous_block_end, fallback = false },
      { key = '][', mode = { 'n', 'x', 'o' }, desc = 'Next Block End', condition = ttac, handler = h.next_block_end, fallback = false },
      { key = '[[', mode = { 'n', 'x', 'o' }, desc = 'Previous Block Start', condition = ttac, handler = h.previous_block_start, fallback = false },
      { key = ']]', mode = { 'n', 'x', 'o' }, desc = 'Next Block Start', condition = ttac, handler = h.next_block_start, fallback = false },

      -- Treesitter Text Object
      { key = 'aa', mode = { 'o', 'x' }, desc = 'Around Argument', condition = ttac, handler = h.around_parameter, fallback = false },
      { key = 'ia', mode = { 'o', 'x' }, desc = 'Inside Argument', condition = ttac, handler = h.inside_parameter, fallback = false },
      { key = 'am', mode = { 'o', 'x' }, desc = 'Around Method', condition = ttac, handler = h.around_function, fallback = false },
      { key = 'im', mode = { 'o', 'x' }, desc = 'Inside Method', condition = ttac, handler = h.inside_function, fallback = false },
      -- By default, "ab", "aB", "ib" and "iB" are aliases of "a(", "a{", "i(" and "i{" respectively
      { key = 'ab', mode = { 'o', 'x' }, desc = 'Around Block', condition = ttac, handler = h.around_block, fallback = false },
      { key = 'ib', mode = { 'o', 'x' }, desc = 'Inside Block', condition = ttac, handler = h.inside_block, fallback = false },
      { key = 'ai', mode = { 'o', 'x' }, desc = 'Around If', condition = ttac, handler = h.around_conditional, fallback = false },
      { key = 'ii', mode = { 'o', 'x' }, desc = 'Inside If', condition = ttac, handler = h.inside_conditional, fallback = false },
      { key = 'af', mode = { 'o', 'x' }, desc = 'Around For', condition = ttac, handler = h.around_loop, fallback = false },
      { key = 'if', mode = { 'o', 'x' }, desc = 'Inside For', condition = ttac, handler = h.inside_loop, fallback = false },
      { key = 'ar', mode = { 'o', 'x' }, desc = 'Around Return', condition = ttac, handler = h.around_return, fallback = false },
      { key = 'ir', mode = { 'o', 'x' }, desc = 'Inside Return', condition = ttac, handler = h.inside_return, fallback = false },
      { key = 'ac', mode = { 'o', 'x' }, desc = 'Around Class', condition = ttac, handler = h.around_class, fallback = false },
      { key = 'ic', mode = { 'o', 'x' }, desc = 'Inside Class', condition = ttac, handler = h.inside_class, fallback = false },

      -- Swap
      { key = '<m-s>pa', desc = 'Swap With Previous Argument', condition = ttac, handler = h.swap_with_previous_parameter, fallback = false },
      { key = '<m-s>na', desc = 'Swap With Next Argument', condition = ttac, handler = h.swap_with_next_parameter, fallback = false },
      { key = '<m-s>pb', desc = 'Swap With Previous Block', condition = ttac, handler = h.swap_with_previous_block, fallback = false },
      { key = '<m-s>nb', desc = 'Swap With Next Block', condition = ttac, handler = h.swap_with_next_block, fallback = false },
      { key = '<m-s>pc', desc = 'Swap With Previous Class', condition = ttac, handler = h.swap_with_previous_class, fallback = false },
      { key = '<m-s>nc', desc = 'Swap With Next Class', condition = ttac, handler = h.swap_with_next_class, fallback = false },
      { key = '<m-s>pi', desc = 'Swap With Previous If', condition = ttac, handler = h.swap_with_previous_conditional, fallback = false },
      { key = '<m-s>ni', desc = 'Swap With Next If', condition = ttac, handler = h.swap_with_next_conditional, fallback = false },
      { key = '<m-s>pf', desc = 'Swap With Previous For', condition = ttac, handler = h.swap_with_previous_loop, fallback = false },
      { key = '<m-s>nf', desc = 'Swap With Next For', condition = ttac, handler = h.swap_with_next_loop, fallback = false },
      { key = '<m-s>pm', desc = 'Swap With Previous Method', condition = ttac, handler = h.swap_with_previous_function, fallback = false },
      { key = '<m-s>nm', desc = 'Swap With Next Method', condition = ttac, handler = h.swap_with_next_function, fallback = false },
      { key = '<m-s>pr', desc = 'Swap With Previous Return', condition = ttac, handler = h.swap_with_previous_return, fallback = false },
      { key = '<m-s>nr', desc = 'Swap With Next Return', condition = ttac, handler = h.swap_with_next_return, fallback = false },

      -- Completion
      { key = '<c-n>', mode = { 'i', 'c' }, desc = 'Select Next Completion Item', condition = cmvc, handler = h.next_completion_item, fallback = false },
      { key = '<c-p>', mode = { 'i', 'c' }, desc = 'Select Previous Completion Item', condition = cmvc, handler = h.previous_completion_item, fallback = false },
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

      -- Git
      -- WARN: This motion only works in normal mode and visual mode
      { key = '[g', mode = { 'n', 'x' }, desc = 'Previous Git Hunk', condition = igrc, handler = h.previous_hunk, fallback = false },
      { key = ']g', mode = { 'n', 'x' }, desc = 'Next Git Hunk', condition = igrc, handler = h.next_hunk, fallback = false },
      { key = 'ah', mode = { 'x', 'o' }, desc = 'Select Hunk', condition = igrc, handler = h.select_hunk, fallback = false },
      { key = 'ih', mode = { 'x', 'o' }, desc = 'Select Hunk', condition = igrc, handler = h.select_hunk, fallback = false },
      { key = '<leader>ga', desc = 'Stage Hunk', condition = igrc, handler = h.stage_hunk, fallback = false },
      { key = '<leader>ga', mode = 'x', desc = 'Stage Selection', condition = igrc, handler = h.stage_selection, fallback = false },
      { key = '<leader>gA', desc = 'Stage Buffer', condition = igrc, handler = h.stage_buffer, fallback = false },
      { key = '<leader>gu', desc = 'Undo Stage Hunk', condition = igrc, handler = h.undo_stage_hunk, fallback = false },
      { key = '<leader>gU', desc = 'Unstage Buffer', condition = igrc, handler = h.unstage_buffer, fallback = false },
      { key = '<leader>gr', desc = 'Reset Hunk', condition = igrc, handler = h.reset_hunk, fallback = false },
      { key = '<leader>gr', mode = 'x', desc = 'Reset Selection', condition = igrc, handler = h.reset_selection, fallback = false },
      { key = '<leader>gR', desc = 'Reset Buffer', condition = igrc, handler = h.reset_buffer, fallback = false },
      { key = '<leader>gd', desc = 'Hunk Diff Inline', condition = igrc, handler = h.preview_hunk_inline, fallback = false },
      { key = '<leader>gD', desc = 'Hunk Diff', condition = igrc, handler = h.preview_hunk, fallback = false },
      { key = '<leader>gb', desc = 'Blame Line', condition = igrc, handler = h.blame_line, fallback = false },
      { key = '<leader>gt', desc = 'Diff this', condition = igrc, handler = h.diff_this, fallback = false },
      { key = '<leader>gq', desc = 'Quickfix All Hunk', condition = igrc, handler = h.quickfix_all_hunk, fallback = false },
      { key = '<leader>tb', desc = 'Toggle Blame', condition = igrc, handler = h.toggle_current_line_blame, fallback = false },
      { key = '<leader>tw', desc = 'Toggle Word Diff', condition = igrc, handler = h.toggle_word_diff, fallback = false },
      { key = '[x', mode = { 'n', 'x', 'o' }, desc = 'Previous Git Conflict', condition = hcc, handler = h.previous_conflict, count = true, fallback = false, expr = true },
      { key = ']x', mode = { 'n', 'x', 'o' }, desc = 'Next Git Conflict', condition = hcc, handler = h.next_conflict, count = true, fallback = false, expr = true },
      { key = '<leader>xc', desc = 'Choose Current Conflict', condition = hcc, handler = h.choose_current_conflict, fallback = false },
      { key = '<leader>xi', desc = 'Choose Incoming Conflict', condition = hcc, handler = h.choose_incoming_conflict, fallback = false },
      { key = '<leader>xb', desc = 'Choose Both Conflict', condition = hcc, handler = h.choose_both_conflict, fallback = false },
      { key = '<leader>xB', desc = 'Choose Both Reverse Conflict', condition = hcc, handler = h.choose_both_reverse_conflict, fallback = false },
      { key = '<leader>xn', desc = 'Choose None Conflict', condition = hcc, handler = h.choose_none_conflict, fallback = false },
      { key = '<leader>xa', desc = 'Choose Ancestor Conflict', condition = hcc, handler = h.choose_ancestor_conflict, fallback = false },
      { key = '<leader>xl', desc = 'List Conflict in Quickfix', condition = hcc, handler = h.list_conflict, fallback = false },
      { key = '<leader>xdi', desc = 'Diff Incoming Conflict', condition = hcc_dec, handler = h.diff_incoming_conflict, fallback = false },
      { key = '<leader>xdc', desc = 'Diff Current Conflict', condition = hcc_dec, handler = h.diff_current_conflict, fallback = false },
      { key = '<leader>xdb', desc = 'Diff Both Conflict', condition = hcc_dec, handler = h.diff_both_conflict, fallback = false },
      { key = '<leader>xdv', desc = 'Diff Current V.S. Incoming Conflict', condition = hcc_dec, handler = h.diff_current_incoming_conflict, fallback = false },
      { key = '<leader>xdV', desc = 'Diff Incoming V.S. Current Conflict', condition = hcc_dec, handler = h.diff_incoming_current_conflict, fallback = false },

      -- Picker
      { key = '<leader>st', desc = 'Search Todo', handler = h.todo_picker },

      -- Comment
      { key = '<m-/>', desc = 'Comment Line', handler = h.comment_line, count = true },
      { key = '<m-/>', mode = 'i', desc = 'Comment Line', handler = h.comment_line_insert },
      { key = '<m-/>', mode = 'x', desc = 'Comment Selection', handler = h.comment_selection },

      -- Togglers
      { key = '<leader>tt', desc = 'Toggle Treesitter Highlight', condition = thac, handler = h.toggle_treesitter_highlight },
      { key = '<leader>ti', desc = 'Toggle Inlay Hint', condition = lac, handler = h.toggle_inlay_hint },
      { key = '<leader>ts', desc = 'Toggle Spell', handler = h.toggle_spell },
      { key = '<leader>te', desc = 'Toggle Expandtab', handler = h.toggle_expandtab },

      -- Indent
      { key = '[|', mode = { 'n', 'x', 'o' }, desc = 'Top of Indent', handler = r('<plug>(blink-indent-top)', '<plug>(blink-indent-bottom)', 1), expr = true },
      { key = ']|', mode = { 'n', 'x', 'o' }, desc = 'Bottom of Indent', handler = r('<plug>(blink-indent-top)', '<plug>(blink-indent-bottom)', 2), expr = true },
      { key = 'i|', mode = { 'n', 'o' }, desc = 'Inside Indent Line', handler = '<plug>(blink-indent-inside)', count = true, expr = true },
      { key = 'a|', mode = { 'n', 'o' }, desc = 'Around Indent Line', handler = '<plug>(blink-indent-around)', count = true, expr = true },
      { key = '<leader>ti', desc = 'Toggle Indent Line', handler = toggle_blink_indent },

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
    })
    -- stylua: ignore end
  end,
}
