return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},

	config = function()
		local mason = require("mason")

		local mason_lspconfig = require("mason-lspconfig")

		local lspconfig = require("lspconfig")

		local lsp_zero = require("lsp-zero")

		local mason_tool_installer = require("mason-tool-installer")

		local util = require("lspconfig/util")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			handlers = {
				jdtls = lsp_zero.noop,
				lsp_zero.on_attach,
				gopls = function()
					lspconfig["gopls"].setup({
						on_attach = lsp_zero.on_attach,
						capabilities = lsp_zero.capabilities,
						cmd = { "gopls" },
						filetypes = { "go", "gomod", "gowork", "gotmpl" },
						root_dir = util.root_pattern("go.work", "go.mod", ".git"),
						settings = {
							gopls = {
								completeUnimported = true,
								usePlaceholders = true,
								analyses = {
									unusedparams = true,
								},
							},
						},
					})
				end,
				lua_ls = function()
					lspconfig["lua_ls"].setup({
						capabilities = lsp_zero.capabilities,
						on_attach = lsp_zero.on_attach,
						settings = { -- custom settings for lua
							Lua = {
								-- make the language server recognize "vim" global
								diagnostics = {
									globals = { "vim" },
								},
								workspace = {
									-- make language server aware of runtime files
									library = {
										[vim.fn.expand("$VIMRUNTIME/lua")] = true,
										[vim.fn.stdpath("config") .. "/lua"] = true,
									},
								},
							},
						},
					})
				end,
				html = function()
					lspconfig["html"].setup({
						on_attach = lsp_zero.on_attach,
					})
				end,
				tsserver = function()
					lspconfig["tsserver"].setup({
						on_attach = lsp_zero.on_attach,
						cmd = { "tsserver" },
						filetypes = { "js", "ts", "tsx" },
						root_dir = util.root_pattern("package.json", "node_modules", ".git"),
						settings = {
							tsserver = {
								completeUnimported = true,
								usePlaceholders = true,
								analyses = {
									unusedparams = true,
								},
							},
						},
					})
				end,
				graphql = function()
					lspconfig["graphql"].setup({
						on_attach = lsp_zero.on_attach,
						filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
					})
				end,
				emmet_ls = function()
					lspconfig["emmet_ls"].setup({
						on_attach = lsp_zero.on_attach,
						filetypes = {
							"html",
							"typescriptreact",
							"javascriptreact",
							"css",
							"sass",
							"scss",
							"less",
							"svelte",
						},
					})
				end,
				pyright = function()
					lspconfig["pyright"].setup({
						on_attach = lsp_zero.on_attach,
					})
				end,
				tailwindcss = function()
					lspconfig["tailwindcss"].setup({
						lsp_zero.on_attach,
					})
				end,
			},
			ensure_installed = {
				"tsserver",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"gopls",
				"jdtls",
			},
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installer = {
				"prettier",
				"stylua",
				"isort",
				"black",
				"pylint",
				"eslint_d",
			},
		})
	end,
}
