return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- 启用 Copilot 建议
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
    end,
  },
}

