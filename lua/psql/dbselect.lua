
local dbselect = {}

-- TODO
-- Copy password in to clipboard
-- Copy Connection String to clipboard


--  TODO Remove this section when done
package.loaded['psql'] = nil
package.loaded['psql.pgpass'] = nil

-- local psql = require('psql')
local pgpass = require('psql.pgpass')
-- Telescope support
local pickers = require("telescope.pickers")
local finder = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")




dbselect.open = function(opts)
  opts = opts or require("telescope.themes").get_dropdown({})
  local pgpass_entries = pgpass.read()

  pickers.new(opts, {
    prompt_title = "Databases",
    finder = finder.new_table {
      results = pgpass_entries,
      entry_maker = function (entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[1],
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function (prompt_bufnr, map)
      actions.select_default:replace(function ()
        actions.close(prompt_bufnr)
        local selected = action_state.get_selected_entry()
        dbselect.selected = selected.value
        return selected
      end)
      return true
    end,
  }):find()
end

return dbselect
