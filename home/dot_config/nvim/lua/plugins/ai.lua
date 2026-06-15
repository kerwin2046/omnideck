return {

  -- 🧠 Copilot 主插件
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = false,
        auto_refresh = false,
      },
      suggestion = {
        enabled = false, -- 不直接启用内联提示（交由 copilot-cmp 接管）
        auto_trigger = true,
        keymap = {
          accept = "<C-l>", -- 接受建议
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        markdown = true,
        help = true,
        lua = true,
        javascript = true,
        typescript = true,
        vue = true,
        python = true,
        json = true,
        html = true,
        css = true,
        ["*"] = true, -- ✅ 所有文件类型都启用
      },
    },
  },

  -- 🧩 Copilot 集成 nvim-cmp
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- ⚙️ Codeium 智能补全 + Chat（与 Copilot 共存，单一 spec 入口）
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
        enable_chat = true,
        enable_cmp_source = true,
      })
    end,
    keys = {
      { "<leader>aC", "<cmd>Codeium Chat<cr>", desc = "AI Chat (Codeium)" },
    },
  },

  -- 🧰 nvim-cmp 主补全插件（确保启用）
  {
    "hrsh7th/nvim-cmp",
    enabled = true, -- 确保没被禁用
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "zbirenbaum/copilot-cmp", -- Copilot 集成
      "Exafunction/codeium.nvim", -- Codeium 集成
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
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "codeium" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
