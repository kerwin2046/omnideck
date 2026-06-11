-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>ob", function()
  vim.fn.jobstart({ "open", vim.fn.expand("%:p") }, { detach = true })
end, {
  desc = "Open current file in browser",
})

vim.keymap.set("n", "<leader>tt", function()
  Snacks.terminal(nil, {
    win = {
      style = "float",
      width = 0.9,
      height = 0.9,
      border = "rounded",
    },
  })
end, { desc = "Floating Terminal" })
