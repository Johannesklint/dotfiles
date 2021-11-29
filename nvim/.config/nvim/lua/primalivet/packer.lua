local M = {}
local fn = vim.fn

function M.init()
    -- Bootstrap
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    end

    local packer = require "packer"
    local use = packer.use

    -- Initialize
    packer.init()

    -- Load packages
    use "wbthomason/packer.nvim"
    use "editorconfig/editorconfig-vim"
    use "tpope/vim-commentary"
    use "tpope/vim-surround"
    use "tpope/vim-repeat"
    use "tpope/vim-fugitive"
    use "simrat39/symbols-outline.nvim"
    use "windwp/nvim-ts-autotag"

    use {
        "nvim-telescope/telescope.nvim",
        requires = {"nvim-lua/plenary.nvim", {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}},
        config = function()
            require "telescope".load_extension "fzf"
        end
    }

    use {
        "ray-x/lsp_signature.nvim",
        requires = {"neovim/nvim-lspconfig"}
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/vim-vsnip",
            "hrsh7th/vim-vsnip-integ",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-emoji",
            "onsails/lspkind-nvim"
        },
        config = function()
            require "cmp".setup {
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end
                },
                formatting = {
                    format = require "lspkind".cmp_format({with_text = true, maxwidth = 50})
                },
                sources = {
                    {name = "buffer"},
                    {name = "path"},
                    {name = "nvim_lsp"},
                    {name = "nvim_lua"},
                    {name = "emoji"}
                }
            }
        end
    }

    use {
        "lewis6991/gitsigns.nvim",
        requires = {"nvim-lua/plenary.nvim"},
        config = function()
            require "gitsigns".setup {
                signs = {
                    add = {text = "+"},
                    change = {text = "~"},
                    delete = {text = "_"},
                    topdelete = {text = "‾"},
                    changedelete = {text = "±"}
                }
            }
            vim.cmd "command! GitsignsResetHunk exe 'Gitsigns reset_hunk'"
            vim.cmd "command! GitsignsNextHunk exe 'Gitsigns next_hunk'"
            vim.cmd "command! GitsignsPrevHunk exe 'Gitsigns prev_hunk'"
            vim.cmd "command! GitsignsPreviewHunk exe 'Gitsigns preview_hunk'"
        end
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require "nvim-treesitter.configs".setup {
                ensure_installed = "maintained",
                highlight = {enable = true},
                indent = {enable = true}
            }
        end
    }

    use {
        "windwp/nvim-autopairs",
        requires = "nvim-treesitter/nvim-treesitter",
        config = function()
            require "nvim-autopairs".setup {}
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))
        end
    }

    use {
        "neovim/nvim-lspconfig",
        config = function()
            local nvim_lsp = require "lspconfig"
            --
            -- Integrate quickfix list with the nvim lsp
            --
            do
                local lsp_method = "textDocument/publishDiagnostics"
                local default_handler = vim.lsp.handlers[lsp_method]
                vim.lsp.handlers[lsp_method] = function(err, method, result, client_id, bufnr, config)
                    default_handler(err, method, result, client_id, bufnr, config)
                    local diagnostics = vim.lsp.diagnostic.get_all()
                    local items = vim.lsp.util.diagnostics_to_items(diagnostics)
                    -- TODO: consider filtering out diagnostics with typescript source
                    vim.lsp.util.set_loclist(items)
                end
            end

            --
            -- Generic "On attach" function for all language servers
            --
            local function on_attach(client)
                -- Disable formatting for any language server
                client.resolved_capabilities.document_formatting = false
                client.resolved_capabilities.document_range_formatting = false

                local lsp_signature = require("lsp_signature")
                lsp_signature.on_attach()
            end

            --
            -- LSP Setups
            --

            -- CSS, JSON and YAML LSP
            -- Capabilities are not resolved in on_attach as that is the servers
            -- capabilities, here we need to set neovims capabilities.
            -- Please tell me why it is this way???
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            nvim_lsp.tsserver.setup {on_attach = on_attach}
            nvim_lsp.gopls.setup {}
            nvim_lsp.vimls.setup {}

            nvim_lsp.cssls.setup {
                capabilities = capabilities
            }

            nvim_lsp.jsonls.setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    json = {
                        schemas = {
                            {
                                description = "TypeScript compiler configuration file",
                                fileMatch = {"tsconfig.json", "tsconfig.*.json"},
                                url = "http://json.schemastore.org/tsconfig"
                            },
                            {
                                description = "ESLint config",
                                fileMatch = {".eslintrc.json", ".eslintrc"},
                                url = "http://json.schemastore.org/eslintrc"
                            },
                            {
                                description = "Prettier config",
                                fileMatch = {".prettierrc", ".prettierrc.json", "prettier.config.json"},
                                url = "http://json.schemastore.org/prettierrc"
                            }
                        }
                    }
                }
            }

            nvim_lsp.yamlls.setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    yaml = {
                        schemas = {
                            {
                                description = "Docker Compose config",
                                fileMatch = {"docker-compose.yml", "docker-compose.yaml"},
                                url = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"
                            }
                        }
                    }
                }
            }

            -- Sumneko LSP
            if vim.fn.has("mac") == 1 or vim.fn.has("linux") == 1 then
                -- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
                USER = vim.fn.expand("$USER")

                local sumneko_root_path = ""
                local sumneko_binary = ""

                if vim.fn.has("mac") == 1 then
                    sumneko_root_path = "/Users/" .. USER .. "/.local/lua-language-server"
                    sumneko_binary = "/Users/" .. USER .. "/.local/lua-language-server/bin/macOS/lua-language-server"
                elseif vim.fn.has("unix") == 1 then
                    sumneko_root_path = "/home/" .. USER .. "/.local/lua-language-server"
                    sumneko_binary = "/home/" .. USER .. "/.local/lua-language-server/bin/Linux/lua-language-server"
                end

                nvim_lsp.sumneko_lua.setup {
                    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
                    settings = {
                        Lua = {
                            runtime = {
                                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                                version = "LuaJIT",
                                -- Setup your lua path
                                path = vim.split(package.path, ";")
                            },
                            diagnostics = {
                                -- Get the language server to recognize the `vim` global
                                globals = {"vim"}
                            },
                            workspace = {
                                -- Make the server aware of Neovim runtime files
                                library = {
                                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                                }
                            }
                        }
                    }
                }
            end
        end
    }

    use {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require "null-ls"
            local helpers = require "null-ls.helpers"

            local eslint_options = {
                condition = function(utils)
                    return utils.root_has_file ".eslintrc" or utils.root_has_file(".eslintrc.json")
                end,
                command = "./node_modules/.bin/eslint"
            }

            local prettier_options = {
                condition = function(utils)
                    return utils.root_has_file ".prettierrc" or utils.root_has_file ".prettierrc.json"
                end,
                command = "./node_modules/.bin/prettier"
            }

            local source_luafmt = {
                method = null_ls.methods.FORMATTING,
                filetypes = {"lua"},
                name = "luafmt",
                generator = helpers.formatter_factory {
                    command = "luafmt",
                    args = {"--stdin"}, -- go with luafmt defaults, it does not support a per project config as for now.
                    to_stdin = true
                }
            }

            local sources = {
                null_ls.builtins.formatting.eslint_d.with(eslint_options),
                null_ls.builtins.diagnostics.eslint_d.with(eslint_options),
                null_ls.builtins.formatting.prettier.with(prettier_options),
                source_luafmt
            }

            null_ls.config {
                debug = true,
                sources = sources
            }

            require "lspconfig"["null-ls"].setup {
                on_attach = function(client)
                    client.resolved_capabilities.document_formatting = true
                    vim.cmd("command -buffer Formatting lua vim.lsp.buf.formatting()")
                    vim.cmd("command -buffer FormattingSync lua vim.lsp.buf.formatting_sync()")

                    vim.cmd [[
                                        augroup PRIMALIVET_FORMATTING
                                        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
                                        augroup END
                                        ]]
                end
            }
        end
    }
end

return M
