local M = {}

M._databases = {}

M.setup = function(opts)
  -- syntax color for the .pgpass file
  vim.cmd([[
    autocmd BufNewFile,BufRead .pgpass set filetype=pgpass
  ]])

  -- Set PostgreSQL to be the default sql language type
  vim.g.sql_type_default = 'postgresql'


  -- TODO build database tree
  table.insert(M._databases, {
    name = 'dbname',
    schemas = {
      tables = {},
      views = {},
      functions = {},
      sequences = {},
    }
  })
end

return M
