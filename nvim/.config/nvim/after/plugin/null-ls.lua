local null_ls = require("null-ls")

local root_has_file = function(files)
  return function(utils)
    return utils.root_has_file(files)
  end
end

local eslint_root_files = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintignore" }
local prettier_root_files = { ".prettierrc", ".prettierrc.js", ".prettierrc.json" }
local stylua_root_files = { "stylua.toml", ".stylua.toml" }
local elm_root_files = { "elm.json" }

local opts = {
  eslint_formatting = {
    condition = function(utils)
      local has_eslint = root_has_file(eslint_root_files)(utils)
      local has_prettier = root_has_file(prettier_root_files)(utils)
      return has_eslint and not has_prettier
    end,
  },
  eslint_diagnostics = {
    condition = root_has_file(eslint_root_files),
  },
  eslint_code_action = {
    condition = root_has_file(eslint_root_files),
  },
  prettier_formatting = {
    condition = root_has_file(prettier_root_files),
  },
  stylua_formatting = {
    condition = root_has_file(stylua_root_files),
  },
  elm_format_formatting = {
    condition = root_has_file(elm_root_files),
  },
}




-- format on save
local async_formatting = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  vim.lsp.buf_request(
  bufnr,
  "textDocument/formatting",
  vim.lsp.util.make_formatting_params({}),
  function(err, res, ctx)
    if err then
      local err_msg = type(err) == "string" and err or err.message
      -- you can modify the log message / level (or ignore it completely)
      vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
      return
    end

    -- don't apply results if buffer is unloaded or has been modified
    if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
      return
    end

    if res then
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd("silent noautocmd update")
      end)
    end
  end
  )
end


local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- format on save


local function on_attach(client, _)
  if client.resolved_capabilities.document_formatting then
    vim.cmd("command! -buffer Formatting lua vim.lsp.buf.formatting()")
    vim.cmd("command! -buffer FormattingSync lua vim.lsp.buf.formatting_sync()")

    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  end
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        async_formatting(bufnr)
      end,
    })
  end
end

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint_d.with(opts.eslint_diagnostics),
    null_ls.builtins.formatting.eslint_d.with(opts.eslint_formatting),
    null_ls.builtins.formatting.prettier.with(opts.prettier_formatting),
    null_ls.builtins.formatting.stylua.with(opts.stylua_formatting),
    null_ls.builtins.formatting.elm_format.with(opts.elm_format_formatting),
    null_ls.builtins.code_actions.eslint_d.with(opts.eslint_code_action),
  },
  on_attach = on_attach,
})
