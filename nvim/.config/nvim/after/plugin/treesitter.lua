local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  playground = { enable = true },
  highlight = { enable = true },
  indent = { enable = true },
  autotag = { enable = true }, 
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
