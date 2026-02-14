local p = 'telescope|'
local h = require('lightboat.handler')
local function grep_with_input_wrap(name)
  return function()
    local line = vim.api.nvim_get_current_line()
    h.picker_action_wrap('close')()
    h.picker_wrap(name, { default_text = line:sub(3) })()
  end
end
-- stylua: ignore start
local mapping = {
  { "i", "<c-j>", h.picker_action_wrap("move_selection_next"), { desc = p .. "Move Selection Next" } },
  { "i", "<c-k>", h.picker_action_wrap("move_selection_previous"), { desc = p .. "Move Selection Previous" } },
  { "i", "<c-r><c-w>", h.picker_action_wrap("insert_original_cword"), { desc = p .. "Insert Cword" } },
  { "i", "<c-r><c-a>", h.picker_action_wrap("insert_original_cWORD"), { desc = p .. "Insert CWORD" } },
  { "i", "<c-r><c-f>", h.picker_action_wrap("insert_original_cfile"), { desc = p .. "Insert Cfile" } },
  { "i", "<c-r><c-l>", h.picker_action_wrap("insert_original_cline"), { desc = p .. "Insert Cline" } },

  -- Picker normal-mode mappings
  { "n", "<esc>", h.picker_action_wrap("close"), { desc = p .. "Close" } },
  { "n", "q", h.picker_action_wrap("close"), { desc = p .. "Close" } },
  { "n", "j", h.picker_action_wrap("move_selection_next"), { desc = p .. "Move Selection Next" } },
  { "n", "k", h.picker_action_wrap("move_selection_previous"), { desc = p .. "Move Selection Previous" } },
  { "n", "H", h.picker_action_wrap("move_to_top"), { desc = p .. "Move To Top" } },
  { "n", "M", h.picker_action_wrap("move_to_middle"), { desc = p .. "Move To Middle" } },
  { "n", "L", h.picker_action_wrap("move_to_bottom"), { desc = p .. "Move To Bottom" } },
  { "n", "gg", h.picker_action_wrap("move_to_top"), { desc = p .. "Move To Top" } },
  { "n", "G", h.picker_action_wrap("move_to_bottom"), { desc = p .. "Move To Bottom" } },

  -- Picker mappings for both normal and insert mode
  { { "n", "i" }, "<c-c>", h.picker_action_wrap("close"), { desc = p .. "Close" } },
  { { "n", "i" }, "<cr>", h.picker_action_wrap("select_default"), { desc = p .. "Select Default" } },
  { { "n", "i" }, "<c-s>", h.picker_action_wrap("select_horizontal"), { desc = p .. "Select Horizontal" } },
  { { "n", "i" }, "<c-v>", h.picker_action_wrap("select_vertical"), { desc = p .. "Select Vertical" } },
  { { "n", "i" }, "<c-t>", h.picker_action_wrap("select_tab"), { desc = p .. "Select Tab" } },
  { { "n", "i" }, "<c-u>", h.picker_action_wrap("preview_scrolling_up"), { desc = p .. "Preview Scroll Up" } },
  { { "n", "i" }, "<c-d>", h.picker_action_wrap("preview_scrolling_down"), { desc = p .. "Preview Scroll Down" } },
  { { "n", "i" }, "<tab>", h.picker_action_wrap("toggle_selection", "move_selection_worse"), { desc = p .. "Toggle Selection" } },
  { { "n", "i" }, "<s-tab>", h.picker_action_wrap("move_selection_better", "toggle_selection"), { desc = p .. "Toggle Selection" } },
  { { "n", "i" }, "<m-a>", h.picker_action_wrap("smart_select_all"), { desc = p .. "Smart Select All" } },
  { { "n", "i" }, "<leftmouse>", h.picker_action_wrap("mouse_click"), { desc = p .. "Mouse Click" } },
  { { "n", "i" }, "<2-leftmouse>", h.picker_action_wrap("double_mouse_click"), { desc = p .. "Mouse Double Click" } },
  { { "n", "i" }, "<f1>", h.picker_action_wrap("which_key"), { desc = p .. "Which Key" } },
  { { "n", "i" }, "<c-q>", h.picker_action_wrap("send_selected_to_qflist", "open_qflist"), { desc = p .. "Send Selected to Qflist" } },
  { { "n", "i" }, "<c-l>", h.picker_action_wrap("send_selected_to_loclist", "open_loclist"), { desc = p .. "Send Selected to Loclist" } },
  { { "n", "i" }, "<c-p>", grep_with_input_wrap("find_files"), { desc = p .. "Search Files with Input" } },
  { { "n", "i" }, "<c-f>", grep_with_input_wrap("live_grep"), { desc = p .. "Find with Input" } },
}
-- stylua: ignore end

for _, m in ipairs(mapping) do
  m[4].buffer = true
  vim.keymap.set(unpack(m))
end
