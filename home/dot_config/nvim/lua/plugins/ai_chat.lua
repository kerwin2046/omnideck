return {
  -- === Copilot Chat ===
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      debug = false,
      window = {
        layout = "float", -- 浮动窗口
        relative = "editor",
        width = 0.8,
        height = 0.8,
        border = "rounded",
      },
      prompts = {
        Explain = "Explain how the code works.",
        Fix = "Propose a fix for this code.",
        Optimize = "Suggest performance improvements.",
        Doc = "Add documentation comments.",
      },
    },
    keys = {
      { "<leader>ac", ":CopilotChat<CR>", desc = "AI Chat (Copilot)" },
      { "<leader>ae", ":CopilotChatExplain<CR>", desc = "Explain code" },
      { "<leader>af", ":CopilotChatFix<CR>", desc = "Fix code" },
      { "<leader>ao", ":CopilotChatOptimize<CR>", desc = "Optimize code" },
      { "<leader>ad", ":CopilotChatDoc<CR>", desc = "Generate doc" },
    },
  },

  -- === Codeium Chat（可选）===
  {
    "Exafunction/codeium.nvim",
    event = "BufEnter",
    config = function()
      require("codeium").setup({
        enable_chat = true,
      })
    end,
    keys = {
      { "<leader>ai", ":Codeium Chat<CR>", desc = "AI Chat (Codeium)" },
    },
  },
}

