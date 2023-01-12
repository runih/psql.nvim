local M = {}

M.setup = function(opts)
  -- syntax color for the .pgpass file
  vim.cmd([[
    autocmd BufNewFile,BufRead .pgpass set filetype=pgpass
  ]])
end

return M
