vim.api.nvim_create_autocmd('InsertEnter', {
  group = vim.api.nvim_create_augroup('LightBoatNoHLSearch', {}),
  callback = vim.schedule_wrap(function() vim.cmd('nohlsearch') end),
})
local mason_loaded = false
local blink_cmp_loaded = false
vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('LightBoatLsp', {}),
  pattern = 'LazyLoad',
  callback = function(args)
    if args.data == 'blink.cmp' then blink_cmp_loaded = true end
    if args.data == 'mason.nvim' then mason_loaded = true end
    if mason_loaded and blink_cmp_loaded then vim.lsp.enable({ 'lua_ls', 'gopls', 'clangd', 'pyright', 'bashls' }) end
  end,
})
vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('LightBoatMason', {}),
  pattern = 'LazyLoad',
  callback = function(args)
    if args.data ~= 'mason.nvim' then return end
    local ensure_installed = {}
    if vim.fn.executable('go') == 1 then
      table.insert(ensure_installed, 'gopls')
      table.insert(ensure_installed, 'goimports')
    end
    if vim.fn.executable('lua') == 1 then
      table.insert(ensure_installed, 'lua-language-server')
      table.insert(ensure_installed, 'stylua')
    end
    if vim.fn.executable('python') == 1 then
      table.insert(ensure_installed, 'pyright')
      table.insert(ensure_installed, 'black')
    end
    if vim.fn.executable('bash') == 1 then
      table.insert(ensure_installed, 'bash-language-server')
      table.insert(ensure_installed, 'shellharden')
    end
    if
      vim.fn.executable('g++') == 1
      or vim.fn.executable('gcc') == 1
      or vim.fn.executable('clang') == 1
      or vim.fn.executable('clang++') == 1
      or vim.fn.executable('cl') == 1
    then
      table.insert(ensure_installed, 'clangd')
      table.insert(ensure_installed, 'clang-format')
    end
    local mason_registry = require('mason-registry')
    local installed = mason_registry.get_installed_package_names()
    local not_installed = vim.tbl_filter(
      function(pack) return not vim.tbl_contains(installed, pack) end,
      ensure_installed
    )
    if #not_installed == 0 then return end
    for _, pack in ipairs(mason_registry.get_all_packages()) do
      if vim.tbl_contains(not_installed, pack.name) then pack:install() end
    end
  end,
})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('LightBoatFormat', {}),
  callback = function(args)
    if vim.b.format_on_save == false or vim.b.format_on_save == nil and vim.g.format_on_save == false then return end
    require('conform').format({ bufnr = args.buf })
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('LightBoatTreeSitter', {}),
  callback = function()
    local tac = require('lightboat.condition')():treesitter_available()
    if not tac() then return end
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.treesitter.start()
  end,
})
