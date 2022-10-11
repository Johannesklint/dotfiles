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
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Det är den här jäveln som gör det! 
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
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
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        buffer = "[buffer]",
        nvim_lsp = "[lsp]",
        luasnip = "[snippet]",
        nvim_lua = "[nvimlua]",
        path = "[path]",
        nvim_lsp_signature_help = "[signature]",
        rg = "[rg]",
      })[entry.source.name]
      return vim_item
    end,
  },
})
