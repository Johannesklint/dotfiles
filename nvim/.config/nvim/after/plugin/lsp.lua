local nvim_lsp = require("lspconfig")
local rusttools = require("rust-tools")
local lsp_ts_utils = require("nvim-lsp-ts-utils")

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function on_attach(client, _)
  -- Disable LSP formatting for all language server
  -- In most cases I tend to use null-ls for formatting and linting, as
  -- they are generally better to configure with widley used tools such
  -- as prettier and eslint.
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.document_range_formatting = false

  if client.name == "rust_analyzer" then
    -- For rust, we do want to use the LSP formatting though as it's
    -- widley accepted.
    client.server_capabilities.documentFormattingProvider= true
    client.server_capabilities.document_range_formatting = true
  end

  if client.name == "tsserver" then
    -- For Typescript (javascript) we do use some extra tools built ontop
    -- of nvim-lsp to get us smarter code actions around imports, types etc.
    lsp_ts_utils.setup({
      auto_inlay_hints = false,
      always_organize_imports = false,
      filter_out_diagnostics_by_severity = { "hint" },
    })
    lsp_ts_utils.setup_client(client)
  end
end

nvim_lsp.elmls.setup({
  capabilities = capabilities,
})

nvim_lsp.cssls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

nvim_lsp.hls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

rusttools.setup({
  server = { on_attach = on_attach },
})

nvim_lsp.tsserver.setup({
  capabilities = capabilities,
  init_options = lsp_ts_utils.init_options,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
  on_attach = on_attach,
})

nvim_lsp.lua_ls.setup({ -- Lua
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
})
