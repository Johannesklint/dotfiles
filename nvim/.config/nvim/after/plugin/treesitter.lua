local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  playground = { enable = true },
  highlight = { enable = true },
  indent = { enable = true },
  autotag = { enable = true }, 
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  }
})
