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
  use("akinsho/toggleterm.nvim")
  use("terrortylor/nvim-comment")
  use("numToStr/Comment.nvim")
  use('JoosepAlviste/nvim-ts-context-commentstring')
  use { "EdenEast/nightfox.nvim", tag = "v1.0.0" } -- Packer
  use { "haishanh/night-owl.vim" }
  use('folke/tokyonight.nvim')
  use('folke/lsp-colors.nvim')
  use('leafgarland/typescript-vim')
  use('peitalin/vim-jsx-typescript')
  use('pangloss/vim-javascript')
  use('HerringtonDarkholme/yats.vim')
  use('maxmellon/vim-jsx-pretty')
  use('jparise/vim-graphql')
  use('windwp/nvim-ts-autotag')
  use {
   'romgrk/barbar.nvim',
   requires = {'kyazdani42/nvim-web-devicons'}
  }
  use('kyazdani42/nvim-web-devicons')
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        position = "bottom", -- position of the list can be: bottom, top, left, right
        height = 10, -- height of the trouble list when position is top or bottom
        width = 150, -- width of the list when position is left or right
        icons = true, -- use devicons for filenames
        mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        group = true, -- group results by file
        padding = true, -- add an extra new line on top of the list
        action_keys = { -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        close = "q", -- close the list
        cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r", -- manually refresh
        jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
        open_split = { "<c-x>" }, -- open buffer in new split
        open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
        open_tab = { "<c-t>" }, -- open buffer in new tab
        jump_close = {"o"}, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small popup with the full multiline message
        preview = "p", -- preview the diagnostic location
        close_folds = {"zM", "zm"}, -- close all folds
        open_folds = {"zR", "zr"}, -- open all folds
        toggle_fold = {"zA", "za"}, -- toggle fold of current file
        previous = "k", -- previous item
        next = "j" -- next item
      },
      indent_lines = true, -- add an indent guide below the fold icons
      auto_open = false, -- automatically open the list when you have diagnostics
      auto_close = false, -- automatically close the list when you have no diagnostics
      auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      auto_fold = false, -- automatically fold a file trouble list at creation
      auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
      signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
      },
      use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
      }
    end
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
  use('mg979/vim-visual-multi')
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
  use({
    "junegunn/fzf",
    requires = { "junegunn/fzf.vim" },
    config = function()
      vim.g.fzf_layout = { down = "30%" }
      vim.g.fzf_preview_window = {}
      vim.g.fzf_action = { ["ctrl-x"] = "split", ["ctrl-v"] = "vsplit" }
    end,
  })
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
