return {
  {
    "williamboman/mason.nvim",
    config = function()
      -- setting mason
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      -- setting mason lsp config
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "tsserver", "csharp_ls", "clangd", "biome" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "VonHeikemen/lsp-zero.nvim",
    },
    config = function()
      -- setting up lsp clients
      -- setting up lsp completion features
      local lsp_zero = require('lsp-zero')
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lsp_attach = function (client, bufnr)
        local opts = {buffer = bufnr, remap = false}

        -- setting up lsp clients keybinds
        -- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
        -- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
        vim.keymap.set("n", "gd", function () vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function () vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function () vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function () vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function () vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function () vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function () vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function () vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function () vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<C-h>", function () vim.lsp.buf.signature_help() end, opts)
      end

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = capabilities
      })

      require("lspconfig").lua_ls.setup({
        capabilities = capabilities,
      })
      require("lspconfig").tsserver.setup({
        capabilities = capabilities,
      })
      require("lspconfig").csharp_ls.setup({
        capabilities = capabilities,
      })
      require("lspconfig").clangd.setup({
        capabilities = capabilities,
      })
      require("lspconfig").biome.setup({
        capabilities = capabilities,
      })
    end,
  },
}
