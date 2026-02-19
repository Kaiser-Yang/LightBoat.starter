-- BUG:
-- https://github.com/nvim-telescope/telescope.nvim/issues/3621
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
local function get_input() return require('telescope.actions.state').get_current_line() end
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
local function toggle_frecency(buffer)
  local input = get_input()
  local picker = require('telescope.actions.state').get_current_picker(buffer)
  local is_frecency = picker.prompt_title:match('Find File Frecency') ~= nil
  require('telescope.actions').close(buffer)
  if is_frecency then
    require('telescope.builtin').find_files({ default_text = input })
  else
    require('telescope').extensions.frecency.frecency({ default_text = input })
  end
end
local function toggle_live_grep_frecency(buffer)
  local input = get_input()
  local picker = require('telescope.actions.state').get_current_picker(buffer)
  local is_frecency = picker.prompt_title:match('Live Grep Frecency') ~= nil
  require('telescope.actions').close(buffer)
  if is_frecency then
    require('telescope').extensions.live_grep_args.live_grep_args({ default_text = input })
  else
    _G.live_grep_frecency({ default_text = input })
  end
end
return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-frecency.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
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
      registers = {
        initial_mode = 'normal',
        theme = 'cursor',
        attach_mappings = function(buffer, map)
          vim.keymap.del({ 'i', 'n' }, '<c-e>', { buffer = buffer })
          local r = { '"', '-', '#', '=', '/', '*', '+', ':', '.', '%' }
          for i = 0, 9 do
            table.insert(r, tostring(i))
          end
          for _, key in ipairs(r) do
            map('n', key, {
              function()
                vim.schedule_wrap(u.key.feedkeys)('<cr>', 'm')
                return 'i' .. key
              end,
              type = 'command',
            }, { expr = true })
          end
          return true
        end,
      },
      lsp_dynamic_workspace_symbols = {
        attach_mappings = function(buffer)
          vim.keymap.del('i', '<c-space>', { buffer = buffer })
          return true
        end,
      },
      find_files = { prompt_title = 'Find File', find_command = find_command },
      live_grep = {
        additional_args = additional_args,
        attach_mappings = function(buffer)
          vim.keymap.del('i', '<c-space>', { buffer = buffer })
          return true
        end,
      },
      grep_string = { additional_args = additional_args },
    },
    extensions = {
      live_grep_args = { additional_args = additional_args, prompt_title = 'Live Grep' },
      frecency = {
        previewer = false,
        layout_config = { anchor = 'N', anchor_padding = 0 },
        prompt_title = 'Find File Frecency',
        -- HACK:
        -- https://github.com/nvim-telescope/telescope-frecency.nvim/issues/335
        workspace_scan_cmd = find_command(),
        -- BUG:
        -- https://github.com/nvim-telescope/telescope-frecency.nvim/pull/334
        matcher = 'fuzzy',
        db_version = 'v2',
        preceding = 'opened',
        hide_current_buffer = true,
        show_filter_column = false,
        ignore_register = function(buffer) return not vim.bo[buffer].buflisted or vim.bo[buffer].buftype ~= '' end,
        workspaces = {
          cwd = vim.fn.getcwd(),
          lazy = u.lazy_path(),
          conf = vim.fn.stdpath('config'),
        },
      },
    },
  },
  config = function(_, opts)
    local t = require('telescope')
    local a = require('telescope.actions')
    local ag = require('telescope.actions.generate')
    -- stylua: ignore start
    local insert_and_normal = {
      ['<cr>'] = { a.select_default, type = 'action', opts = { desc = 'Select Default' } },
      ['<c-c>'] = { a.close, type = 'action', opts = { desc = 'Close' } },
      ['<c-s>'] = { a.select_horizontal, type = 'action', opts = { desc = 'Select Horizontal' } },
      ['<c-v>'] = { a.select_vertical, type = 'action', opts = { desc = 'Select Vertical' } },
      ['<c-t>'] = { a.select_tab, type = 'action', opts = { desc = 'Select Tab' } },
      ['<c-u>'] = { a.preview_scrolling_up, type = 'action', opts = { desc = 'Preview Scroll Up' } },
      ['<c-d>'] = { a.preview_scrolling_down, type = 'action', opts = { desc = 'Preview Scroll Down' } },
      ['<c-j>'] = { a.move_selection_next, type = 'action', opts = { desc = 'Move Selection Next' } },
      ['<c-k>'] = { a.move_selection_previous, type = 'action', opts = { desc = 'Move Selection Previous' } },
      ['<c-q>'] = { a.send_selected_to_qflist + a.open_qflist, type = 'action', opts = { desc = 'Send Selected to Qflist' }, },
      ['<c-l>'] = { a.send_selected_to_loclist + a.open_loclist, type = 'action', opts = { desc = 'Send Selected to Loclist' }, },
      ['<c-f>'] = { toggle_live_grep_frecency, type = 'action', opts = { desc = 'Toggle Live Grep Frecency' } },
      ['<c-p>'] = { toggle_frecency, type = 'action', opts = { desc = 'Toggle Find File Frecency' } },
      ['<tab>'] = { a.toggle_selection + a.move_selection_worse, type = 'action', opts = { desc = 'Toggle Selection' } },
      ['<s-tab>'] = { a.move_selection_better + a.toggle_selection, type = 'action', opts = { desc = 'Toggle Selection' }, },
      ['<f1>'] = { ag.which_key({ keybind_width = 14, max_height = 0.25 }), type = 'action', opts = { desc = 'Which Key' } },
      ['<leftmouse>'] = { a.mouse_click, type = 'action', opts = { desc = 'Mouse Click' } },
      ['<2-leftmouse>'] = { a.double_mouse_click, type = 'action', opts = { desc = 'Mouse Double Click' } },
      ['<m-a>'] = { smart_select_all, type = 'action', opts = { desc = 'Smart Select All' } },
      ['<m-p>'] = { a.cycle_history_prev, type = 'action', opts = { desc = 'Previous Search History' } },
      ['<m-n>'] = { a.cycle_history_next, type = 'action', opts = { desc = 'Next Search History' } },
    }
    opts.defaults.mappings.n = {
      ['<esc>'] = { a.close, type = 'action', opts = { desc = 'Close' } },
      ['q'] = { a.close, type = 'action', opts = { desc = 'Close' } },
      ['j'] = { a.move_selection_next, type = 'action', opts = { desc = 'Move Selection Next' } },
      ['k'] = { a.move_selection_previous, type = 'action', opts = { desc = 'Move Selection Previous' } },
      ['H'] = { a.move_to_top, type = 'action', opts = { desc = 'Move to Top' } },
      ['M'] = { a.move_to_middle, type = 'action', opts = { desc = 'Move to Middle' } },
      ['L'] = { a.move_to_bottom, type = 'action', opts = { desc = 'Move to Bottom' } },
      ['G'] = { a.move_to_bottom, type = 'action', opts = { desc = 'Move to Bottom' } },
      ['gg'] = { a.move_to_top, type = 'action', opts = { desc = 'Move to Top' } },
    }
    opts.defaults.mappings.i = {
      -- INFO:
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
    opts.extensions.frecency = require('telescope.themes').get_dropdown(opts.extensions.frecency)
    t.setup(opts)
    if u.plugin_available('telescope-fzf-native.nvim') then t.load_extension('fzf') end
    if u.plugin_available('telescope-frecency.nvim') then t.load_extension('frecency') end
    if u.plugin_available('telescope-live-grep-args.nvim') then t.load_extension('live_grep_args') end
  end,
}
