return {
    'folke/trouble.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
        local keymap = vim.keymap
        local trouble = require('trouble')

        keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<cr>')
    end
}
