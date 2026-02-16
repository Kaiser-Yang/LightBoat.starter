local function load_list_to_arglist(is_quickfix)
  local list = is_quickfix and vim.fn.getqflist() or vim.fn.getloclist(0)

  local function filename_from_item(item)
    if item.bufnr and item.bufnr > 0 then
      local name = vim.fn.bufname(item.bufnr)
      if name ~= '' then return name end
    end
    return item.filename or item.file or item.name or ''
  end

  local filenames = {}
  for _, item in ipairs(list) do
    local name = filename_from_item(item)
    if name and name ~= '' then table.insert(filenames, vim.fn.fnameescape(name)) end
  end

  local cmd_type = is_quickfix and 'Quickfix' or 'Location'
  if #filenames == 0 then
    vim.notify(cmd_type .. ' list is empty', vim.log.levels.WARN, { title = 'LightBoat' })
    return
  end

  vim.cmd('args ' .. table.concat(filenames, ' '))
  vim.notify('Successfully loaded ' .. cmd_type .. ' list into arglist', vim.log.levels.INFO, { title = 'LightBoat' })
end
local command = {
  Qargs = {
    callback = function() load_list_to_arglist(true) end,
    opt = { nargs = 0, bar = true },
  },
  Largs = {
    callback = function() load_list_to_arglist(false) end,
    opt = { nargs = 0, bar = true },
  },
}
for name, c in pairs(command) do
  vim.api.nvim_create_user_command(name, c.callback, c.opt)
end
