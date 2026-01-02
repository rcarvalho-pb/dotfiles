return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = {
            "ts_ls",
            "gopls",
            "zls",
            "lua_ls",
            "pyright",
            "eslint",
            "html",
            "cssls",
            "graphql",
            "emmet_ls",
            "templ",
        },
    },
    dependencies = {
        {
            "mason-org/mason.nvim", opts = {
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            },
        },
        "neovim/nvim-lspconfig",
    },
}
