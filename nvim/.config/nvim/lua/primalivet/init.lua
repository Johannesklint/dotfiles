local opt = vim.opt
vim.g.mapleader = " "

opt.autoindent = true
opt.backup = false
opt.completeopt = "menu,menuone,noselect"
opt.diffopt = "internal,filler,closeoff,vertical"
opt.expandtab = true
opt.fileformats = "unix"
opt.fileignorecase = true
opt.fillchars = "vert:|"
opt.grepformat:append("%f:%l:%c:%m,%f:%l:%m")
opt.grepprg = "rg --vimgrep --no-heading --hidden"
opt.hidden = true -- dont unload abandoned buffers, just hide em
opt.ignorecase = true
opt.laststatus = 1
opt.listchars = "tab:>--,space:·,trail:·,eol:¶" -- chars in :list mode
opt.number = true
opt.path:append("**,bin/.local/**,nvim/.config/**,vim/.vim/**,tmux/.**")
opt.relativenumber = true
opt.scrolloff = 5
opt.shiftround = true
opt.shiftwidth = 2
opt.showcmd = true
opt.sidescrolloff = 5
opt.signcolumn = "yes:1"
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = 2
opt.swapfile = false
opt.termguicolors = false
opt.timeoutlen = 500 --timeout for mappings
opt.undofile = true -- uses the default undodir "~/.local/share/nvim/undo
opt.updatetime = 100 --updatetime for events
opt.wildignore = "*/node_modules/**,*/elm-stuff/**"
opt.wildmenu = true
opt.wildmode = "lastused:list:full"
opt.wrap = false

vim.cmd("colorscheme nightfox")
vim.cmd("set mouse+=a")
vim.cmd("set clipboard=unnamed")
vim.cmd("set termguicolors")

local telescope = require("telescope")
telescope.load_extension "file_browser"

-- Set barbar's options
require'bufferline'.setup {
  -- Enable/disable animations
  animation = true,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enable/disable close button
  closable = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Excludes buffers from the tabline
  exclude_ft = {'javascript'},
  exclude_name = {'package.json'},

  -- Enable/disable icons
  -- if set to 'numbers', will show buffer index in the tabline
  -- if set to 'both', will show buffer index and icons in the tabline
  icons = true,

  -- If set, the icon color will follow its corresponding buffer
  -- highlight group. By default, the Buffer*Icon group is linked to the
  -- Buffer* group (see Highlighting below). Otherwise, it will take its
  -- default value as defined by devicons.
  icon_custom_colors = false,

  -- Configure icons on the bufferline.
  icon_separator_active = '▎',
  icon_separator_inactive = '▎',
  icon_close_tab = '',
  icon_close_tab_modified = '●',
  icon_pinned = '車',

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
}
local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

telescope.setup {
  defaults = {
    layout_config = {
      vertical = { width = 160, preview_cutoff = 10 }
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
require('nvim-treesitter.configs').setup {
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  }
} 
require("nvim_comment").setup({
  hook = function()
    require("ts_context_commentstring.internal").update_commentstring()
  end,
})
require('nvim-treesitter.configs').setup {
   autotag = {
    enable = true,
  }, 
  highlight = {
    enabled = true
  }
}
require("lualine").setup()
require("primalivet.packer").init()
