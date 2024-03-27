
local platform = jit.os

local plugins = {
  {
    "Olical/aniseed",
  },
  {
    "jlesquembre/nterm.nvim",
    lazy = false,
    config = function()
      local nterm_config = {
        maps = true, -- load default mappings
        size = 4,
        direction = "horizontal", -- horizontal or vertical
        popup = 2000, -- Number of milliseconds to show the info about the command. 0 to disable
        popup_pos = "SE", --  one of "NE" "SE" "SW" "NW"
        autoclose = 2000, -- If command is successful, close the terminal after that number of milliseconds. 0 to disable
      }

      if platform == "Windows" then
        nterm_config.shell = "powershell.exe"
      elseif platform == "OSX" then
        nterm_config.shell = "zsh"
      else
        nterm_config.shell = "zsh"
      end

      require("nterm.main").init(nterm_config)

      -- Optional, if you want to use the telescope extension
    end,
  },
  -- other plugins
}

return plugins
