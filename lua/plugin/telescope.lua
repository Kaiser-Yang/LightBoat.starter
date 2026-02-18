-- Known Issues:
-- https://github.com/nvim-telescope/telescope.nvim/issues/3621
-- https://github.com/nvim-telescope/telescope.nvim/pull/3392#issuecomment-3919322773
local u = require('lightboat.util')
local function find_command()
  local res = { 'rg', '--files', '--color', 'never', '-g', '!.git' }
  if u.in_config_dir() then table.insert(res, '--hidden') end
  return res
end
local additional_args = function()
  local res = { '-g', '!.git' }
  if u.in_config_dir() then table.insert(res, '--hidden') end
  return res
end
local function grep_with_input_wrap(name)
  return function()
    local line = vim.api.nvim_get_current_line()
    local opts = { default_text = line:sub(3) }
    require('telescope.builtin')[name](opts)
  end
end
local function smart_select_all(buffer)
  local picker = require('telescope.actions.state').get_current_picker(buffer)
  local all_selected = #picker:get_multi_selection() == picker.manager:num_results()
  local a = require('telescope.actions')
  if all_selected then
    a.drop_all(buffer)
  else
    a.select_all(buffer)
  end
end
return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      enabled = vim.fn.executable('make') == 1 and (vim.fn.executable('gcc') == 1 or vim.fn.executable('clang') == 1),
    },
  },
  cmd = { 'Telescope' },
  opts = {
    defaults = {
      dynamic_preview_title = true,
      sorting_strategy = 'ascending',
      default_mappings = {},
      layout_config = {
        horizontal = { prompt_position = 'top' },
        width = { padding = 0 },
        height = { padding = 0 },
      },
      cache_picker = { ignore_empty_prompt = true },
      mappings = { n = {}, i = {} },
    },
    pickers = {
      lsp_dynamic_workspace_symbols = { attach_mappings = function() return true end },
      find_files = {
        find_command = find_command,
      },
      live_grep = { additional_args = additional_args, attach_mappings = function() return true end },
      grep_string = { additional_args = additional_args },
    },
    extensions = {
      ['todo-comments'] = { todo = { additional_args = additional_args } },
    },
  },
  config = function(_, opts)
    local t = require('telescope')
    local a = require('telescope.actions')
    local ag = require('telescope.actions.generate')
    -- stylua: ignore start
    local insert_and_normal = {
      ['<c-c>'] = { a.close, type = 'action', opts = { desc = 'Close' } },
      ['<cr>'] = { a.select_default, type = 'action', opts = { desc = 'Select Default' } },
      ['<c-s>'] = { a.select_horizontal, type = 'action', opts = { desc = 'Select Horizontal' } },
      ['<c-v>'] = { a.select_vertical, type = 'action', opts = { desc = 'Select Vertical' } },
      ['<c-t>'] = { a.select_tab, type = 'action', opts = { desc = 'Select Tab' } },
      ['<c-u>'] = { a.preview_scrolling_up, type = 'action', opts = { desc = 'Preview Scroll Up' } },
      ['<c-d>'] = { a.preview_scrolling_down, type = 'action', opts = { desc = 'Preview Scroll Down' } },
      ['<tab>'] = { a.toggle_selection + a.move_selection_worse, type = 'action', opts = { desc = 'Toggle Selection' } },
      ['<s-tab>'] = { a.move_selection_better + a.toggle_selection, type = 'action', opts = { desc = 'Toggle Selection' }, },
      ['<m-a>'] = { smart_select_all, type = 'action', opts = { desc = 'Smart Select All' } },
      ['<leftmouse>'] = { a.mouse_click, type = 'action', opts = { desc = 'Mouse Click' } },
      ['<2-leftmouse>'] = { a.double_mouse_click, type = 'action', opts = { desc = 'Mouse Double Click' } },
      ['<f1>'] = { ag.which_key({ keybind_width = 14, max_height = 0.25 }), type = 'action', opts = { desc = 'Which Key' } },
      ['<c-q>'] = { a.send_selected_to_qflist + a.open_qflist, type = 'action', opts = { desc = 'Send Selected to Qflist' }, },
      ['<c-l>'] = { a.send_selected_to_loclist + a.open_loclist, type = 'action', opts = { desc = 'Send Selected to Loclist' }, },
      ['<c-p>'] = { grep_with_input_wrap('find_files'), type = 'action', opts = { desc = 'Search File with Input' } },
      ['<c-f>'] = { grep_with_input_wrap('live_grep'), type = 'action', opts = { desc = 'Search Content with Input' } },
      ['<m-p>'] = { a.cycle_history_prev, type = 'action', opts = { desc = 'Previous Search History' } },
      ['<m-n>'] = { a.cycle_history_next, type = 'action', opts = { desc = 'Next Search History' } },
    }
    opts.defaults.mappings.n = {
      ['<esc>'] = { a.close, type = 'action', opts = { desc = 'Close' } },
      ['q'] = { a.close, type = 'action', opts = { desc = 'Close' } },
      ['j'] = { a.move_selection_next, type = 'action', opts = { desc = 'Move Selection Next' } },
      ['k'] = { a.move_selection_previous, type = 'action', opts = { desc = 'Move Selection Previous' } },
      ['H'] = { a.move_to_top, type = 'action', opts = { desc = 'Move To Top' } },
      ['M'] = { a.move_to_middle, type = 'action', opts = { desc = 'Move To Middle' } },
      ['L'] = { a.move_to_bottom, type = 'action', opts = { desc = 'Move To Bottom' } },
      ['gg'] = { a.move_to_top, type = 'action', opts = { desc = 'Move To Top' } },
      ['G'] = { a.move_to_bottom, type = 'action', opts = { desc = 'Move To Bottom' } },
    }
    opts.defaults.mappings.i = {
      ['<c-j>'] = { a.move_selection_next, type = 'action', opts = { desc = 'Move Selection Next' } },
      ['<c-k>'] = { a.move_selection_previous, type = 'action', opts = { desc = 'Move Selection Previous' } },
      -- Used to delete one word before
      -- See https://github.com/nvim-telescope/telescope.nvim/issues/1579#issuecomment-989767519
      ['<c-w>'] = { '<c-s-w>', type = 'command' },
      ['<c-r><c-w>'] = { a.insert_original_cword, type = 'action', opts = { desc = 'Insert Cword' } },
      ['<c-r><c-a>'] = { a.insert_original_cWORD, type = 'action', opts = { desc = 'Insert CWORD' } },
      ['<c-r><c-f>'] = { a.insert_original_cfile, type = 'action', opts = { desc = 'Insert Cfile' } },
      ['<c-r><c-l>'] = { a.insert_original_cline, type = 'action', opts = { desc = 'Insert Cline' } },
    }
    -- stylua: ignore end
    opts.defaults.mappings.n = vim.tbl_deep_extend('error', opts.defaults.mappings.n, insert_and_normal)
    opts.defaults.mappings.i = vim.tbl_deep_extend('error', opts.defaults.mappings.i, insert_and_normal)
    t.setup(opts)
    if u.plugin_available('telescope-fzf-native.nvim') then t.load_extension('fzf') end
  end,
}
