require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,       
    },
  },
  buffers = {
    follow_current_file = false,
  },
})
