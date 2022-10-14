local actions = require('telescope.actions')

require("telescope").setup {
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        width = 0.95,  
        height = 0.95, 
      },
    },
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
    },
    buffers= {
      theme = "dropdown",
    },
    live_grep= {
      theme = "dropdown",
    },
    lsp_references= {
      theme = "dropdown",
    },
  },
}




