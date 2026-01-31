-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Format on save
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local bufnr = args.buf

    if client.supports_method and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end,
      })
    end
  end,
})

-- LSP Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local keymaps = {
      { "<leader>cl", function() Snacks.picker.lsp_config() end,          desc = "Lsp Info" },
      { "gd",         vim.lsp.buf.definition,                             desc = "Goto Definition",            has = "definition" },
      { "gr",         vim.lsp.buf.references,                             desc = "References",                 nowait = true },
      { "gI",         vim.lsp.buf.implementation,                         desc = "Goto Implementation" },
      { "gy",         vim.lsp.buf.type_definition,                        desc = "Goto T[y]pe Definition" },
      { "gD",         vim.lsp.buf.declaration,                            desc = "Goto Declaration" },
      { "K",          function() return vim.lsp.buf.hover() end,          desc = "Hover" },
      { "gK",         function() return vim.lsp.buf.signature_help() end, desc = "Signature Help",             has = "signatureHelp" },
      { "<c-k>",      function() return vim.lsp.buf.signature_help() end, mode = "i",                          desc = "Signature Help", has = "signatureHelp" },
      { "<leader>ca", vim.lsp.buf.code_action,                            desc = "Code Action",                mode = { "n", "x" },     has = "codeAction" },
      { "<leader>cc", vim.lsp.codelens.run,                               desc = "Run Codelens",               mode = { "n", "x" },     has = "codeLens" },
      { "<leader>cC", vim.lsp.codelens.refresh,                           desc = "Refresh & Display Codelens", mode = { "n" },          has = "codeLens" },
      { "<leader>cR", function() Snacks.rename.rename_file() end,         desc = "Rename File",                mode = { "n" },          has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
      { "<leader>cr", vim.lsp.buf.rename,                                 desc = "Rename",                     has = "rename" },
      { "<leader>cA", LazyVim.lsp.action.source,                          desc = "Source Action",              has = "codeAction" },
      {
        "]]",
        function() Snacks.words.jump(vim.v.count1) end,
        has = "documentHighlight",
        desc = "Next Reference",
        enabled = function()
          return
              Snacks.words.is_enabled()
        end
      },
      {
        "[[",
        function() Snacks.words.jump(-vim.v.count1) end,
        has = "documentHighlight",
        desc = "Prev Reference",
        enabled = function()
          return
              Snacks.words.is_enabled()
        end
      },
      {
        "<a-n>",
        function() Snacks.words.jump(vim.v.count1, true) end,
        has = "documentHighlight",
        desc = "Next Reference",
        enabled = function()
          return
              Snacks.words.is_enabled()
        end
      },
      {
        "<a-p>",
        function() Snacks.words.jump(-vim.v.count1, true) end,
        has = "documentHighlight",
        desc = "Prev Reference",
        enabled = function()
          return
              Snacks.words.is_enabled()
        end
      },
    }

    -- Register keymaps
    for _, map in ipairs(keymaps) do
      if not map.enabled or map.enabled() then
        local opts = { buffer = args.buf, desc = map.desc }
        local modes = type(map.mode) == "table" and map.mode or { map.mode or "n" }
        for _, mode in ipairs(modes) do
          vim.keymap.set(mode, map[1], map[2], opts)
        end
      end
    end
  end,
})
