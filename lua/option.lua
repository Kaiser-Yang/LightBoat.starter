--- @class LightBoat.Opt
vim.g.lightboat_opt = {
  --- @type string[]
  treesitter_ensure_installed = { 'lua' },
  --- @type string[]
  mason_ensure_installed = { 'lua-language-server', 'stylua' },
}
vim.g.blink_cmp_unique_priority = function(ctx)
  if ctx.mode == 'cmdline' then
    return { 'cmdline', 'path', 'buffer' }
  else
    return { 'snippets', 'lsp', 'ripgrep', 'dictionary', 'buffer' }
  end
end
vim.g.highlight_on_yank = true
vim.g.highlight_on_yank_limit = 1024 -- 1 KB
vim.g.highlight_on_yank_duration = 300
vim.g.conform_on_save = true
vim.g.conform_on_save_reguess_indent = true
vim.g.conform_formatexpr_auto_set = true
vim.g.treesitter_indentexpr_auto_set = true
vim.g.treesitter_highlight_auto_start = true
vim.g.treesitter_foldexpr_auto_set = true
vim.g.nohlsearch_auto_run = true
vim.g.big_file_limit = 1024 * 1024 -- 1 MB
vim.g.big_file_average_every_line = 200
local original = {}
vim.g.big_file_callback = function(data)
  if not original[data.buffer] then original[data.buffer] = {} end
  if
    not original[data.buffer].indentexpr
    and vim.bo.indentexpr ~= ''
    and vim.bo.indentexpr ~= "v:lua.require'nvim-treesitter'.indentexpr()"
  then
    original[data.buffer].indentexpr = vim.bo.indentexpr
  end
  if data.old_status == data.new_status then return end
  if data.new_status then
    vim.b.conform_on_save = false
    vim.b.treesitter_foldexpr_auto_set = false
    vim.b.treesitter_indentexpr_auto_set = false
    vim.b.treesitter_highlight_auto_start = false
    vim.bo.indentexpr = original[data.buffer].indentexpr or ''
    local treesitter_attached = nil
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == data.buffer then
        if vim.wo[win][0].foldexpr == "v:lua.require'nvim-treesitter'.foldexpr()" then treesitter_attached = true end
        vim.wo[win][0].foldmethod = 'manual'
        vim.wo[win][0].foldexpr = '0'
        vim.api.nvim_set_current_win(win)
      end
    end
    for _, client in pairs(vim.lsp.get_clients({ bufnr = data.buffer })) do
      vim.lsp.buf_detach_client(data.buffer, client.id)
    end
    if vim.treesitter.highlighter.active[data.buffer] ~= nil then vim.treesitter.stop(data.buffer) end
    if vim.bo.filetype == '' and vim.bo.buftype == '' then
      -- This is a tricky way to disable lsp attaching
      -- Since lsp won't attach to buffers with buftype set to nonempty value
      vim.bo.buftype = 'acwrite'
      vim.api.nvim_create_autocmd('FileType', {
        buffer = data.buffer,
        once = true,
        callback = function() vim.bo.buftype = '' end,
      })
    end
    if _G.plugin_loaded['nvim-treesitter-endwise'] then require('nvim-treesitter.endwise').detach(data.buffer) end
    if _G.plugin_loaded['nvim-treesitter-context'] then require('treesitter-context').enable() end
  else
    vim.b.conform_on_save = nil
    vim.b.treesitter_foldexpr_auto_set = nil
    vim.b.treesitter_indentexpr_auto_set = nil
    vim.b.treesitter_highlight_auto_start = nil
    -- Trigger the FileType autocommand to let lsp attach, indentexpr, endwise and foldexpr set up
    if vim.bo.filetype ~= '' then vim.api.nvim_set_option_value('filetype', vim.bo.filetype, { buf = data.buffer }) end
    if _G.plugin_loaded['nvim-treesitter-context'] then require('treesitter-context').enable() end
  end
end

-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

-- We use another explore instead of netrw, so disable it
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.o.numberwidth = 1
vim.o.winborder = 'rounded'
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes:1'
vim.o.jumpoptions = 'stack'
vim.o.termguicolors = true
vim.o.scrolloff = 5
vim.o.colorcolumn = '100'
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = 'tab:»-,trail:·,lead:·'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.foldopen = 'block,mark,percent,quickfix,search,tag,undo'
vim.o.foldlevel = 99999
vim.o.foldcolumn = '1'
vim.o.fillchars = 'fold: ,foldopen:,foldclose:,foldsep: '
vim.o.splitright = true
vim.o.autowriteall = true

vim.filetype.add({ pattern = { ['.*.bazelrc'] = 'bazelrc' } })

vim.treesitter.language.register('objc', { 'objcpp' })
vim.o.splitbelow = false
