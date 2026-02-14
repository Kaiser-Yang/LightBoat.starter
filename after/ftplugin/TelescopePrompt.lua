local p = 'telescope|'
local h = require('lightboat.handler')
-- stylua: ignore start
local mapping = {
  { "i", "<c-j>", h.picker_action_wrap("move_selection_next"), { desc = p .. "Move Selection Next", buffer = true } },
  { "i", "<c-k>", h.picker_action_wrap("move_selection_previous"), { desc = p .. "Move Selection Previous", buffer = true } },
  { "i", "<c-r><c-w>", h.picker_action_wrap("insert_original_cword"), { desc = p .. "Insert Cword", buffer = true } },
  { "i", "<c-r><c-a>", h.picker_action_wrap("insert_original_cWORD"), { desc = p .. "Insert CWORD", buffer = true } },
  { "i", "<c-r><c-f>", h.picker_action_wrap("insert_original_cfile"), { desc = p .. "Insert Cfile", buffer = true } },
  { "i", "<c-r><c-l>", h.picker_action_wrap("insert_original_cline"), { desc = p .. "Insert Cline", buffer = true } },

  -- Picker normal-mode mappings
  { "n", "<esc>", h.picker_action_wrap("close"), { desc = p .. "Close", buffer = true } },
  { "n", "q", h.picker_action_wrap("close"), { desc = p .. "Close", buffer = true } },
  { "n", "j", h.picker_action_wrap("move_selection_next"), { desc = p .. "Move Selection Next", buffer = true } },
  { "n", "k", h.picker_action_wrap("move_selection_previous"), { desc = p .. "Move Selection Previous", buffer = true } },
  { "n", "H", h.picker_action_wrap("move_to_top"), { desc = p .. "Move To Top", buffer = true } },
  { "n", "M", h.picker_action_wrap("move_to_middle"), { desc = p .. "Move To Middle", buffer = true } },
  { "n", "L", h.picker_action_wrap("move_to_bottom"), { desc = p .. "Move To Bottom", buffer = true } },
  { "n", "gg", h.picker_action_wrap("move_to_top"), { desc = p .. "Move To Top", buffer = true } },
  { "n", "G", h.picker_action_wrap("move_to_bottom"), { desc = p .. "Move To Bottom", buffer = true } },

  -- Picker mappings for both normal and insert mode
  { { "n", "i" }, "<c-c>", h.picker_action_wrap("close"), { desc = p .. "Close", buffer = true } },
  { { "n", "i" }, "<cr>", h.picker_action_wrap("select_default"), { desc = p .. "Select Default", buffer = true } },
  { { "n", "i" }, "<c-s>", h.picker_action_wrap("select_horizontal"), { desc = p .. "Select Horizontal", buffer = true } },
  { { "n", "i" }, "<c-v>", h.picker_action_wrap("select_vertical"), { desc = p .. "Select Vertical", buffer = true } },
  { { "n", "i" }, "<c-t>", h.picker_action_wrap("select_tab"), { desc = p .. "Select Tab", buffer = true } },
  { { "n", "i" }, "<c-u>", h.picker_action_wrap("preview_scrolling_up"), { desc = p .. "Preview Scroll Up", buffer = true } },
  { { "n", "i" }, "<c-d>", h.picker_action_wrap("preview_scrolling_down"), { desc = p .. "Preview Scroll Down", buffer = true } },
  { { "n", "i" }, "<tab>", h.picker_action_wrap("toggle_selection", "move_selection_worse"), { desc = p .. "Toggle Selection", buffer = true } },
  { { "n", "i" }, "<s-tab>", h.picker_action_wrap("move_selection_better", "toggle_selection"), { desc = p .. "Toggle Selection", buffer = true } },
  { { "n", "i" }, "<m-a>", h.picker_action_wrap("smart_select_all"), { desc = p .. "Smart Select All", buffer = true } },
  { { "n", "i" }, "<leftmouse>", h.picker_action_wrap("mouse_click"), { desc = p .. "Mouse Click", buffer = true } },
  { { "n", "i" }, "<2-leftmouse>", h.picker_action_wrap("double_mouse_click"), { desc = p .. "Mouse Double Click", buffer = true } },
  { { "n", "i" }, "<f1>", h.picker_action_wrap("which_key"), { desc = p .. "Which Key", buffer = true } },
  { { "n", "i" }, "<c-q>", h.picker_action_wrap("send_selected_to_qflist", "open_qflist"), { desc = p .. "Send Selected to Qflist", buffer = true } },
  { { "n", "i" }, "<c-l>", h.picker_action_wrap("send_selected_to_loclist", "open_loclist"), { desc = p .. "Send Selected to Loclist", buffer = true } },
}
-- stylua: ignore end

for _, m in ipairs(mapping) do
  vim.keymap.set(unpack(m))
end
