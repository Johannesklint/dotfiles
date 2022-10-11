local telescope = require("telescope")
telescope.load_extension "file_browser"

local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

telescope.setup {
  defaults = {
    layout_config = {
      vertical = { width = 161, preview_cutoff = 10 }
    },
    mappings = {
      i = { ["<c-t>"] = trouble.open_with_trouble },
      n = { 
        ["<c-t>"] = trouble.open_with_trouble,
        ["<c-d>"] = actions.delete_buffer
      },
    },
  },
}
