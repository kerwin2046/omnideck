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
        layout = "float",
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
      { "<leader>ac", "<cmd>CopilotChat<cr>", desc = "AI Chat (Copilot)" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "Explain code" },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "Fix code" },
      { "<leader>ao", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize code" },
      { "<leader>ad", "<cmd>CopilotChatDoc<cr>", desc = "Generate doc" },
    },
  },
}

