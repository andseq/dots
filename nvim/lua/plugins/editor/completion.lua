return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local kind_icons = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "",
      Event = "",
      Operator = "",
      TypeParameter = "",
    }

    -- vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    end

    local on_tab = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end

    local on_shift_tab = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end

    cmp.setup({
      completion = { autocomplete = false, completeopt = "menu,menuone,noinsert", keyword_length = 1 },
      -- completion = { completeopt = "menu,menuone,noinsert" },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = {
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping { i = cmp.mapping.close(), c = cmp.mapping.close() },
        ["<CR>"] = cmp.mapping {
          i = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
          c = function(fallback)
            if cmp.visible() then
              cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
            else
              fallback()
            end
          end,
        },
        ["<Tab>"] = cmp.mapping(on_tab, { "i", "s", "c", }),
        ["<S-Tab>"] = cmp.mapping(on_shift_tab , { "i", "s", "c" }),
      },

      sources = {
        { name = "nvim_lsp" },
        { name = "treesitter" },
        { name = "buffer" },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "path" },
      },

      formatting = {
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
          -- Source
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            buffer = "[Buffer]",
            luasnip = "[Snip]",
            nvim_lua = "[Lua]",
            treesitter = "[Treesitter]",
            path = "[Path]",
            nvim_lsp_signature_help = "[Signature]",
          })[entry.source.name]

          return vim_item
        end,
      },
      experimental = {
        native_menu = false,
        ghost_text = false
      },
    })

  end,
}
