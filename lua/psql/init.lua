local M = {}

local dbselect = require('psql.dbselect')

M._databases = {}

local option = function(value, default_value)
  if value then
    return value
  end
  return default_value
end

M.setup = function(opts)
  -- Default mappings
  vim.keymap.set("i", "<C-e>", M.query, { desc = "[<C>]+[E]xecute current query" })
  vim.keymap.set("n", "<C-e>", M.query, { desc = "[<C>]+[E]xecute current query" })
  -- Default values
  M.limit = option(opts.limit, 100)
  M.offset = option(opts.offset, 0)
  M.command = option(opts.command, 'psql')


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

local statement = function(bufnr)
  local statement = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  return statement
end

M.set_limit = function(limit)
  local bufnr = vim.api.nvim_get_current_buf()
  M.buffers[bufnr].limit = limit
end

M.set_offset = function(offset)
  local bufnr = vim.api.nvim_get_current_buf()
  M.buffers[bufnr].offset = offset
end

local execute = function(bufnr)
  if not M.buffers[bufnr].output then
    M.buffers[bufnr].output = vim.api.nvim_create_buf(true, false)
  end
    vim.api.nvim_buf_set_lines(M.buffers[bufnr].output, 0, 0, false, { "" })
  for index, line in ipairs(M.buffers[bufnr].statement) do
    vim.api.nvim_buf_set_lines(M.buffers[bufnr].output, index - 1, -1, false, {
      line
    })
  end
end


M.query = function ()
  local bufnr = vim.api.nvim_get_current_buf()
  if not M.buffers then
    M.buffers = {}
  end
  if not M.buffers[bufnr] then
    M.buffers[bufnr] = {
      bufnr = bufnr,
    }
  end
  if not dbselect.selected then
    dbselect.open()
  end
  M.buffers[bufnr].statement = statement(bufnr)

  if not M.buffers[bufnr].limit then
    M.buffers[bufnr].limit = M.limit
  end

  if not M.buffers[bufnr].offset then
    M.buffers[bufnr].offset = M.offset
  end
  if not M.buffers[bufnr].statement then
    print("No real sql statement")
  else
    execute(bufnr)
  end
end

-- Set commands
vim.cmd("command! PGPASS lua require'psql.pgpass'.open()")

return M
