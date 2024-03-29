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
opt.hlsearch = false
opt.incsearch = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd[[
  colorscheme kanagawa-wave
  set mouse+=a
  set clipboard=unnamed
  set termguicolors
  set conceallevel=1
  set nohlsearch
]]

require("lualine").setup()
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()
require("luasnip").filetype_extend("all", { "_" })
require("nvim-tree").setup({
  view = {
    width = 40,
  }
})
require("primalivet.packer").init()

