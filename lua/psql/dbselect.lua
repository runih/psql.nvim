local dbselect = {}

local pgpass = require("psql.pgpass")
-- Telescope support
local pickers = require("telescope.pickers")
local finder = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function copy_password()
  local selected = action_state.get_selected_entry()
  if selected then
    vim.fn.setreg("+", selected.value[2].password)
  end
end

local function copy_connection_string()
  local selected = action_state.get_selected_entry()
  if selected then
    local db = selected.value[2]
    local connectionstring = "Driver={PostgreSQL UNICODE}; Server="
        .. db.hostname
        .. "; Port="
        .. db.port
        .. "; Database="
        .. db.database
        .. "; Uid="
        .. db.username
        .. "; Pwd="
        .. db.password
        .. ";"
    vim.fn.setreg("+", connectionstring)
  end
end

local function create_psql_command()
  local selected = action_state.get_selected_entry()
  if selected then
    local db = selected.value[2]
    return 'PSQL_EDITOR="nvim" psql -h '
        .. db.hostname
        .. " -p "
        .. db.port
        .. " -U "
        .. db.username
        .. " "
        .. db.database
  end
end

local function copy_psql()
  local psql = create_psql_command()
  if psql then
    vim.fn.setreg("+", psql)
  end
end

local function run_psql()
  local psql = create_psql_command()
  if psql then
    vim.cmd("terminal! " .. psql)
  end
end

dbselect.open = function(opts)
  opts = opts or require("telescope.themes").get_dropdown({})
  local pgpass_entries = pgpass.read()
  pickers
      .new(opts, {
        prompt_title = "Databases",
        finder = finder.new_table({
          results = pgpass_entries,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry[1],
              ordinal = entry[1],
            }
          end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          map({ "n" }, "P", copy_password)
          map({ "n" }, "S", copy_connection_string)
          map({ "n" }, "c", copy_psql)
          map({ "n" }, "C", run_psql)
          map({ "i" }, "<C-C>", run_psql)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selected = action_state.get_selected_entry()
            dbselect.selected = selected.value
            return selected
          end)
          return true
        end,
      })
      :find()
end

return dbselect
