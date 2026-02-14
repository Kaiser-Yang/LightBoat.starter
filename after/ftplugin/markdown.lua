local h = require('lightboat.handler')
local mappings = {
  -- Markdown insert mappings
  { 'i', '1', h.markdown_title(1), { desc = 'Insert Markdown Title 1' } },
  { 'i', '2', h.markdown_title(2), { desc = 'Insert Markdown Title 2' } },
  { 'i', '3', h.markdown_title(3), { desc = 'Insert Markdown Title 3' } },
  { 'i', '4', h.markdown_title(4), { desc = 'Insert Markdown Title 4' } },
  { 'i', 's', h.markdown_separate_line, { desc = 'Insert Markdown Separate Line' } },
  { 'i', 'm', h.markdown_math_inline_2, { desc = 'Insert Markdown Inline Math' } },
  { 'i', 't', h.markdown_code_line, { desc = 'Insert Markdown Code Line' } },
  { 'i', 'x', h.markdown_todo, { desc = 'Insert Markdown Todo' } },
  { 'i', 'a', h.markdown_link, { desc = 'Insert Markdown Link' } },
  { 'i', 'b', h.markdown_bold, { desc = 'Insert Markdown Bold Text' } },
  { 'i', 'd', h.markdown_delete_line, { desc = 'Insert Markdown Delete Line' } },
  { 'i', 'i', h.markdown_italic, { desc = 'Insert Markdown Italic Text' } },
  { 'i', 'M', h.markdown_math_block, { desc = 'Insert Markdown Math Block' } },
  { 'i', 'c', h.markdown_code_block, { desc = 'Insert Markdown Code Block' } },
  { 'i', 'f', h.markdown_goto_placeholder, { desc = 'Goto&Delete Markdown Placeholder' } },
}
for _, m in ipairs(mappings) do
  m[4].buffer = true
  vim.keymap.set(unpack(m))
end
