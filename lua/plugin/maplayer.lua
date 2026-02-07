return {
  'Kaiser-Yang/maplayer.nvim',
  event = 'VeryLazy',
  config = function()
    local c = require('lightboat.condition')
    local h = require('lightboat.handler')
    local mc = c():filetype('markdown'):last_key(',')
    local sc = c():add(function() return vim.wo.spell end)
    local igrc = c():is_git_repository()
    local hcc = c():has_conflict()
    local tac = c():treesitter_available()
    local hc = c():filetype('help')
    local nhc = c():not_filetype('help')
    local cmvc = c():completion_menu_visible()
    local cmnvc = c():completion_menu_not_visible()
    local cisc = c():completion_item_selected()
    local sac = c():snippet_active()
    local dvc = c():documentation_visible()
    local svc = c():signature_visible()
    require('maplayer').setup({
      -- stylua: ignore start
      -- Markdown Quick Insert
      { key = '1', mode = 'i', desc = 'Insert Markdown Title 1', condition = mc, handler = h.markdown_title(1) },
      { key = '2', mode = 'i', desc = 'Insert Markdown Title 2', condition = mc, handler = h.markdown_title(2) },
      { key = '3', mode = 'i', desc = 'Insert Markdown Title 3', condition = mc, handler = h.markdown_title(3) },
      { key = '4', mode = 'i', desc = 'Insert Markdown Title 4', condition = mc, handler = h.markdown_title(4) },
      { key = 's', mode = 'i', desc = 'Insert Markdown Separate Line', condition = mc, handler = h.markdown_separate_line },
      { key = 'm', mode = 'i', desc = 'Insert Markdown Inline Math', condition = mc, handler = h.markdown_math_inline_2 },
      { key = 't', mode = 'i', desc = 'Insert Markdown Code Line', condition = mc, handler = h.markdown_code_line },
      { key = 'x', mode = 'i', desc = 'Insert Markdown Todo', condition = mc, handler = h.markdown_todo },
      { key = 'a', mode = 'i', desc = 'Insert Markdown Link', condition = mc, handler = h.markdown_link },
      { key = 'b', mode = 'i', desc = 'Insert Markdown Bold Text', condition = mc, handler = h.markdown_bold },
      { key = 'd', mode = 'i', desc = 'Delete Current Line', condition = mc, handler = h.markdown_delete_line },
      { key = 'i', mode = 'i', desc = 'Insert Markdown Italic Text', condition = mc, handler = h.markdown_italic },
      { key = 'M', mode = 'i', desc = 'Insert Markdown Math Block', condition = mc, handler = h.markdown_math_block },
      { key = 'c', mode = 'i', desc = 'Insert Markdown Code Block', condition = mc, handler = h.markdown_code_block },
      { key = 'f', mode = 'i', desc = 'Markdown Goto Placeholder', condition = mc, handler = h.markdown_goto_placeholder },

      -- Motion
      -- NOTE: If you do not use repeatable move, just remove these two lines below
      { key = ';', mode = { 'n', 'x' }, desc = 'Repeat Last Motion Forward', handler = h.semicolon },
      { key = ',', mode = { 'n', 'x' }, desc = 'Repeat Last Motion Backward', handler = h.comma },
      { key = 'f', mode = { 'n', 'x' }, desc = 'Find Next Character', handler = h.f },
      { key = 'F', mode = { 'n', 'x' }, desc = 'Find Previous Character', handler = h.F },
      { key = 't', mode = { 'n', 'x' }, desc = 'Till Next Character', handler = h.t },
      { key = 'T', mode = { 'n', 'x' }, desc = 'Till Previous Character', handler = h.T },
      { key = '[s', mode = { 'n', 'x', 'o' }, desc = 'Previous Misspelled Word', condition = sc, handler = h.previous_misspelled },
      { key = ']s', mode = { 'n', 'x', 'o' }, desc = 'Next Misspelled Word', condition = sc, handler = h.next_misspelled },
      -- NOTE: By deafault, "[a" and "]a" are mapped to ":prevvious" and ":next"
      { key = '[a', mode = { 'n', 'x', 'o' }, desc = 'Previous Argument Start', condition = tac, handler = h.previous_parameter_start },
      { key = ']a', mode = { 'n', 'x', 'o' }, desc = 'Next Argument Start', condition = tac, handler = h.next_parameter_start },
      -- NOTE: By deafault, "[A" and "]A" are mapped to ":rewind" and ":last"
      { key = '[A', mode = { 'n', 'x', 'o' }, desc = 'Previous Argument End', condition = tac, handler = h.previous_parameter_end },
      { key = ']A', mode = { 'n', 'x', 'o' }, desc = 'Next Argument End', condition = tac, handler = h.next_parameter_end },
      -- NOTE: By default, "[i", "]i", "[I", and "]I" are used to show information of keywords under cursor
      { key = '[i', mode = { 'n', 'x', 'o' }, desc = 'Previous If Start', condition = tac, handler = h.rempove_previous_conditional_start },
      { key = ']i', mode = { 'n', 'x', 'o' }, desc = 'Next If Start', condition = tac, handler = h.rempove_next_conditional_start },
      { key = '[I', mode = { 'n', 'x', 'o' }, desc = 'Previous If End', condition = tac, handler = h.rempove_previous_conditional_end },
      { key = ']I', mode = { 'n', 'x', 'o' }, desc = 'Next If End', condition = tac, handler = h.rempove_next_conditional_end },
      -- NOTE: By default, "[f", "]f" are alias of "gf"
      { key = '[f', mode = { 'n', 'x', 'o' }, desc = 'Previous For Start', condition = tac, handler = h.previous_loop_start },
      { key = ']f', mode = { 'n', 'x', 'o' }, desc = 'Next For Start', condition = tac, handler = h.next_loop_start },
      { key = '[F', mode = { 'n', 'x', 'o' }, desc = 'Previous For End', condition = tac, handler = h.previous_loop_end },
      { key = ']F', mode = { 'n', 'x', 'o' }, desc = 'Next For End', condition = tac, handler = h.next_loop_end },
      -- NOTE: By default "[r" and "]r" are used to search "rare" words
      { key = '[r', mode = { 'n', 'x', 'o' }, desc = 'Previous Return Start', condition = tac, handler = h.previous_return_start },
      { key = ']r', mode = { 'n', 'x', 'o' }, desc = 'Next Return Start', condition = tac, handler = h.next_return_start },
      { key = '[R', mode = { 'n', 'x', 'o' }, desc = 'Previous Return End', condition = tac, handler = h.previous_return_end },
      { key = ']R', mode = { 'n', 'x', 'o' }, desc = 'Next Return End', condition = tac, handler = h.next_return_end },
      -- NOTE: By default, "[c" and "]c" are used to navigate changes in the buffer
      { key = '[c', mode = { 'n', 'x', 'o' }, desc = 'Previous Class Start', condition = tac, handler = h.previous_class_start },
      { key = ']c', mode = { 'n', 'x', 'o' }, desc = 'Next Class Start', condition = tac, handler = h.next_class_start },
      { key = '[C', mode = { 'n', 'x', 'o' }, desc = 'Previous Class End', condition = tac, handler = h.previous_class_end },
      { key = ']C', mode = { 'n', 'x', 'o' }, desc = 'Next Class End', condition = tac, handler = h.next_class_end },
      -- NOTE: Those ten mappings below behavior like the default ones
      { key = '[m', mode = { 'n', 'x', 'o' }, desc = 'Previous Method Start', condition = tac, handler = h.previous_function_start },
      { key = ']m', mode = { 'n', 'x', 'o' }, desc = 'Next Method Start', condition = tac, handler = h.next_function_start },
      { key = '[M', mode = { 'n', 'x', 'o' }, desc = 'Previous Method End', condition = tac, handler = h.previous_function_end },
      { key = ']M', mode = { 'n', 'x', 'o' }, desc = 'Next Method End', condition = tac, handler = h.next_function_end },
      { key = '[]', mode = { 'n', 'x', 'o' }, desc = 'Previous Block End', condition = tac, handler = h.previous_block_end },
      { key = '][', mode = { 'n', 'x', 'o' }, desc = 'Next Block End', condition = tac, handler = h.next_block_end },
      { key = '[[', mode = { 'n', 'x', 'o' }, desc = 'Previous Block Start', condition = tac:add(nhc), handler = h.previous_block_start },
      { key = '[[', mode = { 'n', 'x', 'o' }, desc = 'Previous Section', condition = tac:add(hc), handler = h.previous_section },
      { key = ']]', mode = { 'n', 'x', 'o' }, desc = 'Next Block Start', condition = tac:add(nhc), handler = h.next_block_start },
      { key = ']]', mode = { 'n', 'x', 'o' }, desc = 'Next Section', condition = tac:add(hc), handler = h.next_section },
      -- HACK: This motion only works in normal mode and visual mode
      { key = '[g', mode = { 'n', 'x' }, desc = 'Previous Git Hunk', condition = igrc, handler = h.previous_hunk },
      { key = ']g', mode = { 'n', 'x' }, desc = 'Next Git Hunk', condition = igrc, handler = h.next_hunk },
      { key = 'yi', desc = 'Separate Key', handler = h.separate_key_wrap('yi') },
      { key = 'ya', desc = 'Separate Key', handler = h.separate_key_wrap('ya') },
      { key = 'y[', desc = 'Separate Key', handler = h.separate_key_wrap('y[') },
      { key = 'y]', desc = 'Separate Key', handler = h.separate_key_wrap('y]') },
      { key = 'di', desc = 'Separate Key', handler = h.separate_key_wrap('di') },
      { key = 'da', desc = 'Separate Key', handler = h.separate_key_wrap('da') },
      { key = 'd[', desc = 'Separate Key', handler = h.separate_key_wrap('d[') },
      { key = 'd]', desc = 'Separate Key', handler = h.separate_key_wrap('d]') },
      { key = 'ci', desc = 'Separate Key', handler = h.separate_key_wrap('ci') },
      { key = 'ca', desc = 'Separate Key', handler = h.separate_key_wrap('ca') },
      { key = 'c[', desc = 'Separate Key', handler = h.separate_key_wrap('c[') },
      { key = 'c]', desc = 'Separate Key', handler = h.separate_key_wrap('c]') },

      -- Text Object
      { key = 'aa', mode = { 'o', 'x' }, desc = 'Around Argument', condition = tac, handler = h.around_parameter },
      { key = 'ia', mode = { 'o', 'x' }, desc = 'Inside Argument', condition = tac, handler = h.inside_parameter },
      { key = 'am', mode = { 'o', 'x' }, desc = 'Around Method', condition = tac, handler = h.around_function },
      { key = 'im', mode = { 'o', 'x' }, desc = 'Inside Method', condition = tac, handler = h.inside_function },
      -- NOTE: By default, "ab", "aB", "ib" and "iB" are aliases of "a(", "a{", "i(" and "i{" respectively
      { key = 'ab', mode = { 'o', 'x' }, desc = 'Around Block', condition = tac, handler = h.around_block },
      { key = 'ib', mode = { 'o', 'x' }, desc = 'Inside Block', condition = tac, handler = h.inside_block },
      { key = 'ai', mode = { 'o', 'x' }, desc = 'Around If', condition = tac, handler = h.around_conditional },
      { key = 'ii', mode = { 'o', 'x' }, desc = 'Inside If', condition = tac, handler = h.inside_conditional },
      { key = 'af', mode = { 'o', 'x' }, desc = 'Around For', condition = tac, handler = h.around_loop },
      { key = 'if', mode = { 'o', 'x' }, desc = 'Inside For', condition = tac, handler = h.inside_loop },
      { key = 'ar', mode = { 'o', 'x' }, desc = 'Around Return', condition = tac, handler = h.around_return },
      { key = 'ir', mode = { 'o', 'x' }, desc = 'Inside Return', condition = tac, handler = h.inside_return },
      { key = 'ac', mode = { 'o', 'x' }, desc = 'Around Class', condition = tac, handler = h.around_class },
      { key = 'ic', mode = { 'o', 'x' }, desc = 'Inside Class', condition = tac, handler = h.inside_class },
      { key = 'ah', mode = { 'x', 'o' }, desc = 'Select Hunk', condition = igrc, handler = h.select_hunk },
      { key = 'ih', mode = { 'x', 'o' }, desc = 'Select Hunk', condition = igrc, handler = h.select_hunk },
      { key = 'ae', mode = { 'o', 'x' }, desc = 'Select Edit', handler = h.select_file },
      { key = 'ie', mode = { 'o', 'x' }, desc = 'Select Edit', handler = h.select_file },

      -- Swap
      { key = '<m-s>pa', mode = 'n', desc = 'Swap With Previous Argument', condition = tac, handler = h.swap_with_previous_parameter },
      { key = '<m-s>na', mode = 'n', desc = 'Swap With Next Argument', condition = tac, handler = h.swap_with_next_parameter },
      { key = '<m-s>pb', mode = 'n', desc = 'Swap With Previous Block', condition = tac, handler = h.swap_with_previous_block },
      { key = '<m-s>nb', mode = 'n', desc = 'Swap With Next Block', condition = tac, handler = h.swap_with_next_block },
      { key = '<m-s>pc', mode = 'n', desc = 'Swap With Previous Class', condition = tac, handler = h.swap_with_previous_class },
      { key = '<m-s>nc', mode = 'n', desc = 'Swap With Next Class', condition = tac, handler = h.swap_with_next_class },
      { key = '<m-s>pi', mode = 'n', desc = 'Swap With Previous If', condition = tac, handler = h.swap_with_previous_conditional },
      { key = '<m-s>ni', mode = 'n', desc = 'Swap With Next If', condition = tac, handler = h.swap_with_next_conditional },
      { key = '<m-s>pf', mode = 'n', desc = 'Swap With Previous For', condition = tac, handler = h.swap_with_previous_loop },
      { key = '<m-s>nf', mode = 'n', desc = 'Swap With Next For', condition = tac, handler = h.swap_with_next_loop },
      { key = '<m-s>pm', mode = 'n', desc = 'Swap With Previous Method', condition = tac, handler = h.swap_with_previous_function },
      { key = '<m-s>nm', mode = 'n', desc = 'Swap With Next Method', condition = tac, handler = h.swap_with_next_function },
      { key = '<m-s>pr', mode = 'n', desc = 'Swap With Previous Return', condition = tac, handler = h.swap_with_previous_return },
      { key = '<m-s>nr', mode = 'n', desc = 'Swap With Next Return', condition = tac, handler = h.swap_with_next_return },

      -- Completion
      -- NOTE: By default, "<c-j>" is same with "<cr>"
      { key = '<c-j>', mode = { 'i', 'c' }, desc = 'Select Next Completion Item', condition = cmvc, handler = h.next_completion_item },
      -- NOTE: By default, "<c-k>" is used to insert digraph, see ":help i_CTRL-K" and ":help c_CTRL-K"
      { key = '<c-k>', mode = { 'i', 'c' }, desc = 'Select Previous Completion Item', condition = cmvc, handler = h.previous_completion_item },
      { key = '<c-k>', mode = { 'i', 'c' }, desc = 'Delete Content After Cursor', condition = cmnvc, handler = h.delete_content_after_cursor },
      { key = '<tab>', mode = 'i', desc = 'Snippet Forward', condition = sac, handler = h.snippet_forward },
      { key = '<s-tab>', mode = 'i', desc = 'Snippet Backward', condition = sac, handler = h.snippet_backward },
      -- NOTE: Those four below behaviour like the default ones
      { key = '<c-x><c-o>', mode = { 'i', 'c' }, desc = 'Show Completion', condition = cmnvc, handler = h.show_completion },
      { key = '<c-x><c-o>', mode = { 'i', 'c' }, desc = 'Hide Completion', condition = cmvc,  handler = h.hide_completion },
      { key = '<c-y>', mode = { 'i', 'c' }, desc = 'Accept Completion Item', condition = cisc, handler = h.accept_completion_item },
      { key = '<c-e>', mode = { 'i', 'c' }, desc = 'Cancel Completion', condition = cmvc, handler = h.cancel_completion },
      -- NOTE: By default, "<c-u>" are used to delete content before
      { key = '<c-u>', mode = 'i', desc = 'Scroll Documentation Up', condition = dvc, handler = h.scroll_documentation_up, priority = 2 },
      { key = '<c-u>', mode = 'i', desc = 'Scroll Signature Up', condition = svc, handler = h.scroll_signature_up, priority = 1 },
      -- NOTE: By default, "<c-d>" and "<c-t>" are used to delete or add indent in insert mode
      { key = '<c-d>', mode = 'i', desc = 'Scroll Documentation Down', condition = dvc, handler = h.scroll_documentation_down, priority = 2 },
      { key = '<c-d>', mode = 'i', desc = 'Scroll Signature Down', condition = svc, handler = h.scroll_signature_down, priority = 1 },
      -- NOTE: By default, "<c-s>" is binded by vim.lsp to signature help
      { key = '<c-s>', mode = 'i', desc = 'Show Signature Help', condition = svc, handler = h.show_signature },
      { key = '<c-s>', mode = 'i', desc = 'Hide Signature Help', condition = svc, handler = h.hide_signature },

      -- Format
      { key = '<leader>f', mode = 'n', desc = 'Async Format', handler = h.async_format },
      { key = '<leader>f', mode = 'v', desc = 'Format Selection', handler = h.async_format_selection },

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
      { key = '<space>', mode = 'i', desc = 'Autopair Space', handler = h.auto_pair_wrap('<space>'), replace_keycodes = false },

      -- Surround
      -- NOTE: By default "s" and "S" in visual mode is an alias of "c"
      { key = 's', mode = 'x', desc = 'Surround', handler = h.surround_visual },
      { key = 'S', mode = 'x', desc = 'Surround Line Mode', handler = h.surround_visual_line },
      { key = 'cs', mode = 'n', desc = 'Change Surround', handler = h.surround_change },
      { key = 'cS', mode = 'n', desc = 'Change Surround Line Mode', handler = h.surround_change_line },
      { key = 'ds', mode = 'n', desc = 'Delete Surround', handler = h.surround_delete },
      { key = 'ys', mode = 'n', desc = 'Add Surround', handler = h.surround_normal },
      { key = 'yss', mode = 'n', desc = 'Add Surround Current', handler = h.surround_normal_cur },
      { key = 'yS', mode = 'n', desc = 'Add Surround Line Mode', handler = h.surround_normal_line },
      { key = 'ySS', mode = 'n', desc = 'Add Surround Current Line Mode', handler = h.surround_normal_cur_line },
      -- NOTE: Because we have an auto pair plugin, those two below are rarely used
      { key = '<c-g>s', mode = 'i', desc = 'Surround', handler = h.surround_insert },
      { key = '<c-g>S', mode = 'i', desc = 'Surround Line Mode', handler = h.surround_insert_line },
      -- NOTE:
      -- Those two below is to make sure "ys", "yS", "yss", "ySS", "ySs" and "ysS" work when you type them slowly
      -- You should note that "ySs" will become "yss" and "ysS" will become "ySS" when you type the third "s" or "S" with a long delay
      -- Actually, without those two below, "ySs" and "ysS" will do nothing no matter how you type
      -- If you bind surround with other keys like "yx", "cx", "dx", "yY" and "cY",
      -- you should use h.hack_s_wrap('x') and h.hack_S_wrap('Y') instead
      { key = 's', mode = 'o', desc = 'Hack', handler = h.hack_s_wrap('s') },
      { key = 'S', mode = 'o', desc = 'Hack', handler = h.hack_S_wrap('S') },

      -- Git
      { key = '<leader>ga', mode = 'n', desc = 'Stage Hunk', condition = igrc, handler = h.stage_hunk },
      { key = '<leader>ga', mode = 'v', desc = 'Stage Selection', condition = igrc, handler = h.stage_selection },
      { key = '<leader>gA', mode = 'n', desc = 'Stage Buffer', condition = igrc, handler = h.stage_buffer },
      { key = '<leader>gu', mode = 'n', desc = 'Undo Stage Hunk', condition = igrc, handler = h.undo_stage_hunk },
      { key = '<leader>gU', mode = 'n', desc = 'Unstage Buffer', condition = igrc, handler = h.unstage_buffer },
      { key = '<leader>gr', mode = 'n', desc = 'Reset Hunk', condition = igrc, handler = h.reset_hunk },
      { key = '<leader>gr', mode = 'v', desc = 'Reset Selection', condition = igrc, handler = h.reset_selection },
      { key = '<leader>gR', mode = 'n', desc = 'Reset Buffer', condition = igrc, handler = h.reset_buffer },
      { key = '<leader>gp', mode = 'n', desc = 'Preview Hunk Inline', condition = igrc, handler = h.preview_hunk_inline },
      { key = '<leader>gP', mode = 'n', desc = 'Preview Hunk', condition = igrc, handler = h.preview_hunk },
      { key = '<leader>gb', mode = 'n', desc = 'Blame Line', condition = igrc, handler = h.blame_line },
      -- TODO: check if we should use <leader>tgb and <leader>tgw
      { key = '<leader>tb', mode = 'n', desc = 'Toggle Current Line Blame', condition = igrc, handler = h.toggle_current_line_blame },
      { key = '<leader>tw', mode = 'n', desc = 'Toggle Word Diff', condition = igrc, handler = h.toggle_word_diff },
      { key = '[x', desc = 'Previous Git Conflict', condition = hcc, handler = h.previous_conflict },
      { key = ']x', desc = 'Next Git Conflict', condition = hcc, handler = h.next_conflict },
      -- stylua: ignore end
    })
  end,
}
