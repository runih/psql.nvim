local pgpass = {}

local pgpass_file = vim.fn.expand("~/.pgpass")

local split = function(s, delimiter)
  local result = {}
  local columns = {
    "hostname",
    "port",
    "database",
    "username",
    "password"
  }
  local index = 1
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
     result[columns[index]] = match

     index = index + 1
  end
  result.get_name =  function()
    if result.name then
      return result.name
    end
    return result.hostname .. ":" .. result.database .. ":" .. result.username
  end
  return result;
end

local all_trim = function(s)
   return s:match( "^%s*(.-)%s*$" )
end


pgpass.open = function ()
  -- Edit ~/.pgpass, create a new file if it does not exists
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("pgpass", { clear = true }),
    pattern = pgpass_file,
    callback = function ()
      os.execute("chmod go-rwx " .. pgpass_file)
    end
  })
  local file = io.open(pgpass_file, 'r')
  if file then
    io.close(file)
    vim.api.nvim_command('edit ' .. pgpass_file)
  else
    vim.api.nvim_command('edit ' .. pgpass_file)

    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
      "# Format for this file is:",
      "#   hostname:port:database:username:password",
      "# Make sure only the OWNER has access to this file!",
      "# In *nix this can be done by running the following command: 'chmod go-rwx ~/.pgpass'",
      "localhost:5432:my_database:my_user:my_password"
    })
  end
end

pgpass.read = function ()
  local dbconnections = {}
  local name = nil
  local f = io.open(pgpass_file, "r")
  if f then
    repeat
      local line = f:read()
      if line then
        local comment = string.sub(all_trim(line), 1, 1) == '#'
        if comment then
          name = line:match"%s+[Nn][Aa][Mm][Ee]:%s+(.*)"
        else
          local dbc = split(line, ':')
          if name then
            dbc.name = name
            name = nil
          end
          table.insert(dbconnections, dbc)
        end
      end
    until not line
    io.close(f)
  end
  return dbconnections
end

return pgpass
