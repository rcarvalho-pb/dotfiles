return {

	"VonHeikemen/lsp-zero.nvim",
	branch = "v3.x",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
	},

	config = function()
		local lsp_zero = require("lsp-zero")

		local lspconfig = require("lspconfig")

		local util = require("lspconfig/util")

		lsp_zero.set_sign_icons({
			error = '✘',
			warn = '▲',
			hint = '⚑',
			info = '»'
		  })

		lsp_zero.on_attach(function(client, bufnr)
			local opts = {buffer = bufnr, remap = false}
			lsp_zero.default_keymaps({ buffer = bufnr })
			vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
			vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
			vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
			vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
			vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
			vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
			vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
			vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
			vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
			vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
		  end)

		lsp_zero.setup()

		vim.diagnostic.config({
			virtual_text = true
		})

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

		lspconfig["gopls"].setup({
			on_attach = lsp_zero.on_attach,
			-- capabilities = lspconfig.capabilities,
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

		lspconfig["html"].setup({
			on_attach = lsp_zero.on_attach,
		  })
	  
		  -- configure typescript server with plugin
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
	  
		  -- configure css server
		  lspconfig["cssls"].setup({
			on_attach = lsp_zero.on_attach,
		  })
	  
		  -- configure tailwindcss server
		  lspconfig["tailwindcss"].setup({
			lsp_zero.on_attach		  })
	  
		  -- configure svelte server
		  lspconfig["svelte"].setup({
			on_attach = function(client, bufnr)
			  on_attach(client, bufnr)
	  
			  vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "*.js", "*.ts" },
				callback = function(ctx)
				  if client.name == "svelte" then
					client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
				  end
				end,
			  })
			end,
		  })
	  
		  -- configure prisma orm server
		  lspconfig["prismals"].setup({
			on_attach = lsp_zero.on_attach,
		  })
	  
		  -- configure graphql language server
		  lspconfig["graphql"].setup({
			on_attach = lsp_zero.on_attach,
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		  })
	  
		  -- configure emmet language server
		  lspconfig["emmet_ls"].setup({
			on_attach = lsp_zero.on_attach,
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		  })
	  
		  -- configure python server
		  lspconfig["pyright"].setup({
			on_attach = lsp_zero.on_attach,
		  })
	end,
}
