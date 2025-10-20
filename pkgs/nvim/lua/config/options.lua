-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use latest Blink Commit
vim.g.lazyvim_blink_main = true

-- Disable this check since we don't use all LazyVim plugins
vim.g.lazyvim_check_order = false

-- I handle autoformatting myself in ./autocmds.lua
vim.g.autoformat = false
