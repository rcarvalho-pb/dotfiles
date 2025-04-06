return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"folke/neodev.nvim",
		"nvimtools/none-ls.nvim",
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"gopls",
				"zls",
				"pyright",
				"eslint",
				"ts_ls",
			},
		})

		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local on_attach = function(_, bufnr)
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			local nmap = function(keys, func, desc)
				if desc then
					desc = "LSP: " .. desc
				end
				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
			end

			nmap("gd", vim.lsp.buf.definition, "Go to Definition")
			nmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
			nmap("gr", vim.lsp.buf.references, "Go to References")
			nmap("gi", vim.lsp.buf.implementation, "Go to Implementation")
			nmap("K", vim.lsp.buf.hover, "Hover Documentation")
			nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
			nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
			nmap("<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, "Format")
			nmap("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
			nmap("]d", vim.diagnostic.goto_next, "Next Diagnostic")
			nmap("gl", vim.diagnostic.open_float, "Show Line Diagnostic")
		end

		local servers = {
			gopls = {
				settings = {
					gopls = {
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			},
			zls = {
				settings = {
					zls = {
						enableInlayHints = true,
						inlayHints = {
							parameterNames = true,
							types = true,
							chainingHints = true,
						},
					},
				},
			},
			pyright = {},
			eslint = {},
			ts_ls = {
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayVariableTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayVariableTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			},
		}

		for server, config in pairs(servers) do
			if config then
				lspconfig[server].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = config.settings,
				})
			end
		end
	end,
}
