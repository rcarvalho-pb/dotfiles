return {
	"ray-x/go.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},

	keys = {
		{ "<leader>gfi", ":GoIfErr<cr>", noremap = true, desc = "Go: Autofill If-err block" },
		{ "<leader>gfs", ":GoFillStruct<cr>", noremap = true, desc = "Go: Autofill Struct with fields" },
		{ "<leader>gfw", ":GoFillSwitch<cr>", noremap = true, desc = "Go: Autofill Switch with cases" },
		{
			"<leader>gfp",
			"GoFixPlurals",
			noremap = true,
			desc = "Go: Auto collate plural params with same type",
		},
	},
	opts = {
		gofmt = "gofumpt",
		lsp_gofumpt = true,
		lsp_keymaps = false,
		lsp_inlay_hints = { enable = false },
		lsp_cfg = true,
	},
	event = "CmdlineEnter",
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()',
}
