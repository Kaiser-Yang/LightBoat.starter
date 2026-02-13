local h = require('lightboat.handler')
local mappings = {
  -- Markdown insert mappings
  { 'i', '1', h.markdown_title(1), { desc = 'Insert Markdown Title 1', buffer = true } },
  { 'i', '2', h.markdown_title(2), { desc = 'Insert Markdown Title 2', buffer = true } },
  { 'i', '3', h.markdown_title(3), { desc = 'Insert Markdown Title 3', buffer = true } },
  { 'i', '4', h.markdown_title(4), { desc = 'Insert Markdown Title 4', buffer = true } },
  { 'i', 's', h.markdown_separate_line, { desc = 'Insert Markdown Separate Line', buffer = true } },
  { 'i', 'm', h.markdown_math_inline_2, { desc = 'Insert Markdown Inline Math', buffer = true } },
  { 'i', 't', h.markdown_code_line, { desc = 'Insert Markdown Code Line', buffer = true } },
  { 'i', 'x', h.markdown_todo, { desc = 'Insert Markdown Todo', buffer = true } },
  { 'i', 'a', h.markdown_link, { desc = 'Insert Markdown Link', buffer = true } },
  { 'i', 'b', h.markdown_bold, { desc = 'Insert Markdown Bold Text', buffer = true } },
  { 'i', 'd', h.markdown_delete_line, { desc = 'Insert Markdown Delete Line', buffer = true } },
  { 'i', 'i', h.markdown_italic, { desc = 'Insert Markdown Italic Text', buffer = true } },
  { 'i', 'M', h.markdown_math_block, { desc = 'Insert Markdown Math Block', buffer = true } },
  { 'i', 'c', h.markdown_code_block, { desc = 'Insert Markdown Code Block', buffer = true } },
  { 'i', 'f', h.markdown_goto_placeholder, { desc = 'Goto&Delete Markdown Placeholder', buffer = true } },
}
for _, m in ipairs(mappings) do
  vim.keymap.set(unpack(m))
end
