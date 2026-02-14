return {
  'RRethy/nvim-treesitter-endwise',
  event = 'InsertEnter',
  config = function()
    -- This plugin is not loaded by setup function, we must call init manually
    local endwise = require('nvim-treesitter-endwise')
    endwise.init()
    -- Attach manually, since the plugin is lazy loaded and won't be attached on InsertEnter
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
      if not endwise.is_supported(lang) then return end
      require('nvim-treesitter.endwise').attach(buf)
    end
  end,
}
