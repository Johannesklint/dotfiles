local actions = require('telescope.actions')

require("telescope").setup {
  pickers = {
    find_files = {
      theme = "ivy",
    },
    buffers= {
      theme = "ivy",
    },
    live_grep= {
      theme = "ivy",
    },
    lsp_references= {
      theme = "ivy",
    },
  },
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
}




