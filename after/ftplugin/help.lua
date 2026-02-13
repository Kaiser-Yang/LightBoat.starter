local h = require('lightboat.handler')
local mapping = {
  { { 'n', 'x', 'o' }, '[]', h.previous_section_end, { desc = 'Previous Block End', buffer = true } },
  { { 'n', 'x', 'o' }, '][', h.next_section_end, { desc = 'Next Block End', buffer = true } },
  { { 'n', 'x', 'o' }, '[[', h.previous_section_start, { desc = 'Previous Section', buffer = true } },
  { { 'n', 'x', 'o' }, ']]', h.next_section_start, { desc = 'Next Section', buffer = true } },
}
for _, m in ipairs(mapping) do
  vim.keymap.set(unpack(m))
end
