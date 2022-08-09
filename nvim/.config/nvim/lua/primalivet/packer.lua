local M = {}
local fn = vim.fn

function M.init()
  -- Bootstrap
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  end

  local packer = require("packer")
  local use = packer.use
  -- Initialize
  packer.init()

  -- Load packages
  use("nvim-lua/plenary.nvim")
  use("wbthomason/packer.nvim")
  use("editorconfig/editorconfig-vim")
  use("tpope/vim-commentary")
  use("tpope/vim-surround")
  use("tpope/vim-repeat")
  use("gerw/vim-HiLinkTrace")
  use("rafcamlet/nvim-luapad")
  use("tpope/vim-fugitive")

  use({
    "junegunn/fzf",
    requires = { "junegunn/fzf.vim" },
    config = function()
      vim.g.fzf_layout = { down = "30%" }
      vim.g.fzf_preview_window = {}
      vim.g.fzf_action = {
        ["ctrl-x"] = "split",
        ["ctrl-v"] = "vsplit",
      }
    end,
  })

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
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lua" },
        }, {
          { name = "path" },
          { name = "buffer" },
          { name = "rg" },
          { name = "emoji" },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              nvim_lua = "[NvimLua]",
              path = "[Path]",
              calc = "[Calc]",
              nvim_lsp_signature_help = "[Signature]",
              rg = "[Ripgrep]",
              emoji = "[Emoji]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })
    end,
  })

  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "±" },
        },
      })
    end,
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    requires = { "nvim-treesitter/playground" },
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        playground = {
          enable = true,
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  })

  use({
    "neovim/nvim-lspconfig",
    requires = { "jose-elias-alvarez/nvim-lsp-ts-utils" },
    config = function()
      local nvim_lsp = require("lspconfig")

      do
        local method_name = "textDocument/publishDiagnostics"
        local default_handler = vim.lsp.handlers[method_name]
        vim.lsp.handlers[method_name] = function(err, method, result, client_id, bufnr, config)
          default_handler(err, method, result, client_id, bufnr, config)
          vim.diagnostic.setloclist({ open = false })
        end
      end
      --
      -- Generic "On attach" function for all language servers
      --
      local function on_attach(client)
        -- Disable formatting for any language server
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        -- vim.cmd([[
        -- augroup PRIMA_CURSOR_HOLD
        -- autocmd CursorHold * lua vim.lsp.buf.document_highlight()
        -- autocmd CursorMoved * lua vim.lsp.buf.clear_references()
        -- augroup END
        -- ]])

        if client.name == "tsserver" then
          local ts_utils = require("nvim-lsp-ts-utils")
          ts_utils.setup({
            auto_inlay_hints = false,
            always_organize_imports = false,
            filter_out_diagnostics_by_severity = { "hint" },
          })
          ts_utils.setup_client(client)
        end
      end

      -- LSP Setups

      local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      nvim_lsp.elmls.setup({ capabilities = capabilities }) -- Elm
      nvim_lsp.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
      nvim_lsp.hls.setup({ capabilities = capabilities, on_attach = on_attach }) -- Haskell
      nvim_lsp.tsserver.setup({
        capabilities = capabilities,
        init_options = require("nvim-lsp-ts-utils").init_options,
        on_attach = on_attach,
      })

      -- Sumneko LSP
      if vim.fn.has("mac") == 1 or vim.fn.has("linux") == 1 then
        -- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
        USER = vim.fn.expand("$USER")

        local sumneko_root_path = ""
        local sumneko_binary = ""

        if vim.fn.has("mac") == 1 then
          sumneko_root_path = "/Users/" .. USER .. "/.local/src/lua-language-server"
          sumneko_binary = "/Users/" .. USER .. "/.local/src/lua-language-server/bin/lua-language-server"
        elseif vim.fn.has("unix") == 1 then
          sumneko_root_path = "/home/" .. USER .. "/.local/src/lua-language-server"
          sumneko_binary = "/home/" .. USER .. "/.local/src/lua-language-server/bin/lua-language-server"
        end

        nvim_lsp.sumneko_lua.setup({
          cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
          settings = {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = vim.split(package.path, ";"),
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
              },
            },
          },
        })
      end
    end,
  })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      local opts = {
        -- Run eslint (formatting) if no prettier config exists but
        -- eslint config does exist
        eslint_formatting = {
          condition = function(utils)
            local has_eslint = utils.root_has_file({ ".eslintrc", ".eslintrc.js", ".eslintrc.json" })
            local has_prettier = utils.root_has_file({
              ".prettierrc",
              ".prettierrc.js",
              ".prettierrc.json",
            })

            return has_eslint and not has_prettier
          end,
        },
        -- Run eslint if eslint config file exists
        eslint_diagnostics = {
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc", ".eslintrc.js", ".eslintrc.json" })
          end,
        },
        -- Run prettier if prettier config exitst
        prettier_formatting = {
          condition = function(utils)
            return utils.root_has_file({ ".prettierrc", ".prettierrc.js", ".prettierrc.json" })
          end,
        },
        stylua_formatting = {
          condition = function(utils)
            return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
          end,
        },
        elm_format_formatting = {
          condition = function(utils)
            return utils.root_has_file({ "elm.json" })
          end,
        },
      }

      require("null-ls").setup({
        sources = {
          null_ls.builtins.diagnostics.eslint_d.with(opts.eslint_diagnostics),
          null_ls.builtins.formatting.eslint_d.with(opts.eslint_formatting),
          null_ls.builtins.formatting.prettier.with(opts.prettier_formatting),
          null_ls.builtins.formatting.stylua.with(opts.stylua_formatting),
          null_ls.builtins.formatting.elm_format.with(opts.elm_format_formatting),
        },
        on_attach = function(client)
          if client.resolved_capabilities.document_formatting then
            vim.cmd("command! -buffer Formatting lua vim.lsp.buf.formatting()")
            vim.cmd("command! -buffer FormattingSync lua vim.lsp.buf.formatting_sync()")
          end
        end,
      })
    end,
  })

  use({
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({ icons = false })
    end,
  })

  use({
    "~/Code/OSS/cabin.nvim",
    condition = function()
      vim.fn.isdirectory("~/Code/OSS/cabin.nvim")
    end,
    config = function()
      require("cabin").setup()
      vim.cmd([[colorscheme cabin]])
    end,
  })

  use({
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.set_log_level("TRACE")
      dap.adapters = {
        node2 = {
          type = "executable",
          command = "node",
          -- Download at: https://github.com/microsoft/vscode-node-debug2/tags
          args = { os.getenv("HOME") .. "/.local/bin/vscode-node-debug2/out/src/nodeDebug.js" },
        },
        -- chrome = {
        -- 	type = "executable",
        -- 	command = "node",
        -- 	Download at: https://github.com/microsoft/vscode-chrome-debug/releases
        -- 	args = { os.getenv("HOME") .. "/path/to/vscode-chrome-debug/out/src/chromeDebug.js" },
        -- },
      }

      dap.configurations = {
        javascript = {
          {
            name = "Launch",
            type = "node2",
            request = "launch",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
          },
          {
            -- For this to work you need to make sure the node process is started with the `--inspect` flag.
            name = "Attach to process",
            type = "node2",
            request = "attach",
            processId = require("dap.utils").pick_process,
          },
        },
        -- javascriptreact = {
        -- 	{
        -- 		type = "chrome",
        -- 		request = "attach",
        -- 		program = "${file}",
        -- 		cwd = vim.fn.getcwd(),
        -- 		sourceMaps = true,
        -- 		protocol = "inspector",
        -- 		port = 9222,
        -- 		webRoot = "${workspaceFolder}",
        -- 	},
        -- },
        -- typescriptreact = {
        -- 	{
        -- 		type = "chrome",
        -- 		request = "attach",
        -- 		program = "${file}",
        -- 		cwd = vim.fn.getcwd(),
        -- 		sourceMaps = true,
        -- 		protocol = "inspector",
        -- 		port = 9222,
        -- 		webRoot = "${workspaceFolder}",
        -- 	},
        -- },
      }
    end,
  })
end

return M
