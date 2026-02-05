-- Delete the default keybindings for help buffers
vim.keymap.del('n', '[[', { buffer = true })
vim.keymap.del('n', ']]', { buffer = true })
