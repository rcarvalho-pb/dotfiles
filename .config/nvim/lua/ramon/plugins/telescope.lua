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
        local actions = require('telescope.actions')
        local builtin = require("telescope.builtin")


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

        keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch [G]rep' })
        keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
        keymap.set('n', '<leader>ht', builtin.help_tags, { desc = '[H]elp [T]ags' })

    end
}
