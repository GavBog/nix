-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "U", "<cmd>redo<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").jump() end)
vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })
