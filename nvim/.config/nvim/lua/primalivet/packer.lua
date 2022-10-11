local M = {}

local function initialize_packer()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    -- Bootstrap (installs packer, requires restart after execution)
    print("Installing packer, you have to restart neovim")
    vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    return nil
  end
  local packer = require("packer")
  local use = packer.use
  packer.init()
  return use
end

function M.init()
  local use = initialize_packer()

  if use == nil then
    print("Packer not available, you might have to restart Neovim")
    return
  end

  use('prettier/vim-prettier')
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  }
  use("terrortylor/nvim-comment")
  use("numToStr/Comment.nvim")
  use('JoosepAlviste/nvim-ts-context-commentstring')
  use { "EdenEast/nightfox.nvim", tag = "v1.0.0" } 
  use { "haishanh/night-owl.vim" }
  use('folke/tokyonight.nvim')
  use('folke/lsp-colors.nvim')
  use('windwp/nvim-ts-autotag')
  use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  } -- tabs
  use('kyazdani42/nvim-web-devicons')
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  }
use {
  'rmagatti/auto-session',
  config = function()
    require("auto-session").setup {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
    }
  end
}
use('mg979/vim-visual-multi') -- select next word -> CTRL-n
use({
  "windwp/nvim-autopairs",
  config = function() require("nvim-autopairs").setup {} end
})
use {
  'nvim-telescope/telescope.nvim', tag = '0.1.0',
  requires = { {'nvim-lua/plenary.nvim'} }
}
use { "nvim-telescope/telescope-file-browser.nvim" }
use "nvim-lua/plenary.nvim"
use("wbthomason/packer.nvim")
use("editorconfig/editorconfig-vim")
use("tpope/vim-fugitive")
use("tpope/vim-surround")

-- use({
--    "junegunn/fzf",
--    requires = { "junegunn/fzf.vim" },
--    config = function()
--      vim.g.fzf_layout = { down = "30%" }
--      vim.g.fzf_preview_window = {}
--      vim.g.fzf_action = { ["ctrl-x"] = "split", ["ctrl-v"] = "vsplit" }
--    end,
--  })

use("rafamadriz/friendly-snippets")
use("hrsh7th/vim-vsnip-integ")
use({
  "hrsh7th/nvim-cmp",
  requires = {
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "lukas-reineke/cmp-rg",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },
})
use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })
use({
  "nvim-treesitter/nvim-treesitter",
  requires = { "nvim-treesitter/playground" },
  run = ":TSUpdate",
})
use({
  "neovim/nvim-lspconfig",
  requires = { "hrsh7th/nvim-cmp", "jose-elias-alvarez/nvim-lsp-ts-utils", "simrat39/rust-tools.nvim" },
})
use({ "jose-elias-alvarez/null-ls.nvim" })
end

return M
