local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  playground = { enable = true },
  highlight = { 
    enable = true,
    disable = {}
  },
  indent = {
    enable = true, 
    disable = {} 
  },
  ensure_installed = {
    "tsx",
    "toml",
    "fish",
    "php",
    "json",
    "yaml",
    "swift",
    "css",
    "html",
    "lua"
  },
  autotag = { enable = true }, 
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  }
})
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

