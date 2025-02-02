local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim
    { "LazyVim/LazyVim" },
    -- import any plugins that need to be added before Lazy
    { import = "lazyvim.plugins.init" },
    -- import any extras modules here
    { import = "lazyvim.plugins.coding" },
    { import = "lazyvim.plugins.editor" },
    { import = "lazyvim.plugins.treesitter" },
    { import = "lazyvim.plugins.ui" },
    { import = "lazyvim.plugins.util" },
    { import = "lazyvim.plugins.xtras" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
  },
  checker = { enabled = true, notify = false }, -- automatically check for plugin updates
})
