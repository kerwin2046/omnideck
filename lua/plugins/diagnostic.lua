return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,

    opts = {
      preset = "powerline",

      options = {
        show_source = {
          enabled = true,
        },

        severity = {
          vim.diagnostic.severity.ERROR,
          vim.diagnostic.severity.WARN,
        },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
      },
    },
  },
}
