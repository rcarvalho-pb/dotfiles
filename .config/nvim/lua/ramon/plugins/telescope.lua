return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
            },
        })

        telescope.load_extension("fzf")

        local keymap = vim.keymap

        keymap.set("n", "<leader>pf", "<cmd>Telescope find_files<cr>")
        keymap.set("n", "<leader>pr", "<cmd>Telescope oldfiles<cr>")
        keymap.set("n", "<leader>ps", "<cmd>Telescope live_grep<cr>")
        keymap.set("n", "<leader>pc", "<cmd>Telescope grep_string<cr>")
        keymap.set("n", "<C-p>", "<cmd>Telescope git_files<cr>")
    end
}
