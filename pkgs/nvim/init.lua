-- NOTE: this just gives nixCats global command a default value
-- so that it doesnt throw an error if you didnt install via nix.
-- usage of both this setup and the nixCats command is optional,
-- but it is very useful for passing info from nix to lua so you will likely use it at least once.
require('nixCatsUtils').setup {
  non_nix_value = true,
}

local function getNixifiedConfigPath()
  if require('nixCatsUtils').isNixCats and type(nixCats.settings.unwrappedCfgPath) == 'string' then
    return nixCats.settings.unwrappedCfgPath
  else
    return vim.fn.stdpath 'config'
  end
end

vim.g.lazyvim_json = getNixifiedConfigPath() .. '/lazyvim.json'

local lazyOptions = {
  lockfile = getNixifiedConfigPath() .. '/lazy-lock.json',

  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  },                -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "netrwPlugin",
        "tutor",
        -- "gzip",
        -- "tarPlugin",
        -- "zipPlugin",
        -- "matchit",
        -- "matchparen",
        -- "tohtml",
      },
    },
  },
}

-- NOTE: this the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require('nixCatsUtils.lazyCat').setup(nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' }, {
  { "LazyVim/LazyVim" },
  { import = "lazyvim.plugins.init" },
  { import = "lazyvim.plugins.coding" },
  { import = "lazyvim.plugins.editor" },
  { import = "lazyvim.plugins.treesitter" },
  { import = "lazyvim.plugins.ui" },
  { import = "lazyvim.plugins.util" },
  { import = "lazyvim.plugins.xtras" },

  -- Default Extra Plugins
  { import = "lazyvim.plugins.extras.ai.copilot" },
  { import = "lazyvim.plugins.extras.coding.blink" },
  { import = "lazyvim.plugins.extras.coding.mini-comment" },
  { import = "lazyvim.plugins.extras.coding.mini-surround" },
  { import = "lazyvim.plugins.extras.coding.yanky" },
  -- { import = "lazyvim.plugins.extras.dap.core" },
  -- { import = "lazyvim.plugins.extras.dap.nlua" },
  { import = "lazyvim.plugins.extras.editor.dial" },
  { import = "lazyvim.plugins.extras.editor.harpoon2" },
  { import = "lazyvim.plugins.extras.editor.inc-rename" },
  { import = "lazyvim.plugins.extras.editor.mini-move" },
  { import = "lazyvim.plugins.extras.editor.navic" },
  { import = "lazyvim.plugins.extras.editor.overseer" },
  { import = "lazyvim.plugins.extras.editor.refactoring" },
  { import = "lazyvim.plugins.extras.editor.snacks_explorer" },
  { import = "lazyvim.plugins.extras.editor.snacks_picker" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  -- { import = "lazyvim.plugins.extras.lang.clangd" },
  -- { import = "lazyvim.plugins.extras.lang.go" },
  -- { import = "lazyvim.plugins.extras.lang.java" },
  -- { import = "lazyvim.plugins.extras.lang.json" },
  -- { import = "lazyvim.plugins.extras.lang.kotlin" },
  -- { import = "lazyvim.plugins.extras.lang.markdown" },
  -- { import = "lazyvim.plugins.extras.lang.nix" },
  -- { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  -- { import = "lazyvim.plugins.extras.lang.tailwind" },
  -- { import = "lazyvim.plugins.extras.lang.typescript" },
  -- { import = "lazyvim.plugins.extras.lang.zig" },
  -- { import = "lazyvim.plugins.extras.test.core" },
  { import = "lazyvim.plugins.extras.ui.indent-blankline" },
  { import = "lazyvim.plugins.extras.ui.smear-cursor" },
  { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
  { import = "lazyvim.plugins.extras.util.octo" },
  { import = "lazyvim.plugins.extras.util.rest" },
  { import = "lazyvim.plugins.extras.util.startuptime" },

  -- disable mason.nvim while using nix
  -- precompiled binaries do not agree with nixos, and we can just make nix install this stuff for us.
  { 'mason-org/mason-lspconfig.nvim',                        enabled = require('nixCatsUtils').lazyAdd(true, false) },
  { 'mason-org/mason.nvim',                                  enabled = require('nixCatsUtils').lazyAdd(true, false) },
  {
    'nvim-treesitter/nvim-treesitter',
    build = require('nixCatsUtils').lazyAdd ':TSUpdate',
    opts_extend = require('nixCatsUtils').lazyAdd(nil, false),
    opts = {
      -- nix already ensured they were installed, and we would need to change the parser_install_dir if we wanted to use it instead.
      -- so we just disable install and do it via nix.
      ensure_installed = require('nixCatsUtils').lazyAdd(
        { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' }, false),
      auto_install = require('nixCatsUtils').lazyAdd(true, false),
    },
  },
  {
    'folke/lazydev.nvim',
    opts = {
      library = {
        { path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
      },
    },
  },
  -- import/override with your plugins
  { import = 'plugins' },
}, lazyOptions)
