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

M.pgpass = function ()
  -- Edit ~/.pgpass, create a new file if it does not exists
  local filename = vim.fn.expand('~/.pgpass')
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("pgpass", { clear = true }),
    pattern = filename,
    callback = function ()
      os.execute("chmod go-rwx " .. filename)
    end
  })
  local pgpass_file = io.open(filename, 'r')
  if pgpass_file then
    io.close(pgpass_file)
    vim.api.nvim_command('edit ' .. filename)
  else
    vim.api.nvim_command('edit ' .. filename)

    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
      "# Format for this file is:",
      "#   <hostname>:<port>:<database>:<username>:<password>",
      "# Make sure only the OWNER has access to this file!",
      "# In *nix this can be done by running the following command: 'chmod go-rwx ~/.pgpass'",
      "localhost:5432:my_database:my_user:my_password"
    })
  end
end

return M
