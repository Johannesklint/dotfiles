local actions = require('telescope.actions')

require("telescope").setup {
  defaults = {
    path_display = { "tail" },
    layout_strategy = "horizontal",
    layout_config = {
        width = 0.95,  
        height = 0.95, 
    },
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
}

