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
				ensure_installed = { "lua_ls", "rust_analyzer", "tsserver", "csharp_ls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- setting up lsp clients
			-- setting up lsp completion features
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
			})
			require("lspconfig").tsserver.setup({
				capabilities = capabilities,
			})
			require("lspconfig").csharp_ls.setup({
				capabilities = capabilities,
			})

			-- setting up lsp clients keybinds
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
