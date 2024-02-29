return {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "neovim/nvim-lspconfig",
        'VonHeikemen/lsp-zero.nvim',
    },

    config = function()
        local mason = require('mason')
        local lspconfig = require('lspconfig')
        local lsp_zero = require('lsp-zero')
        local mason_lspconfig = require('mason-lspconfig')
        local mason_tool_installer = require('mason-tool-installer')
        local util = require('lspconfig/util')

        local servers = {
            "tsserver",
            "html",
            "cssls",
            "lua_ls",
            "graphql",
            "emmet_ls",
            "pyright",
            "gopls",
            "jdtls",
            "angular-language-server",
            "ruby-lsp",
        }

        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        local gopls = function()
            lspconfig['gopls'].setup({
                on_attach = lsp_zero.on_attach,
                capabilities = lsp_zero.capabilities,
                cmd = { 'gopls' },
                filetypes = { 'go', 'go', 'gomod', 'goimpl' },
                root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
                single_file_support = true,
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
        end

        local tsserver = function()
            lspconfig['tsserver'].setup({
                on_attach = lsp_zero.on_attach,
                capabilities = lsp_zero.capabilities,
                cmd = { "typescript-language-server", "--stdio" },
                filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
                init_options = { hostInfo = "neovim" },
                root_dir = util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
                single_file_support = true,
            })
        end

        local angularls = function()
            lspconfig['angularls'].setup({
                on_attach = lsp_zero.on_attach,
                capabilities = lsp_zero.capabilities,
                cmd = { "typescript-language-server", "--stdio" },
                filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
                init_options = { hostInfo = "neovim" },
                root_dir = util.root_pattern("angular.json", ".git"),
                single_file_support = true,
            })
        end

        local ruby_ls = function()
            lspconfig['ruby_ls'].setup({
                on_attach = lsp_zero.on_attach,
                capabilities = lsp_zero.capabilities,
                cmd = { 'ruby-lsp' },
                filetypes = { 'ruby' },
                init_options = { formatter = 'auto' },
                root_dir = util.root_pattern('Gemfile', '.git'),
                single_file_support = true,
            })
        end

        local templ = function()
            lspconfig['templ'].setup({
                on_attach = lsp_zero.on_attach,
                capabilities = lsp_zero.capabilities,
                cmd = { 'templ', 'lsp' },
                filetypes = { 'templ' },
                root_dir = util.root_pattern('go.work', 'go.mod', '.git'),

            })
        end

        local dockerls = function()
            lspconfig['dockerls'].setup({
                on_attach = lsp_zero.on_attach,
                capabilities = lsp_zero.capabilities,
                cmd = { "docker-langserver", "--stdio" },
                filetypes = { 'dockerfile' },
                root_dir = util.root_pattern('Dockerfile'),
                single_file_support = true,
            })
        end

        local lua_ls = function()
            lspconfig['lua_ls'].setup({
                on_init = function(client)
                    local path = client.workspace_folders[1].name
                    if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                            Lua = {
                                runtime = {
                                    -- Tell the language server which version of Lua you're using
                                    -- (most likely LuaJIT in the case of Neovim)
                                    version = 'LuaJIT'
                                },
                                -- Make the server aware of Neovim runtime files
                                workspace = {
                                    checkThirdParty = false,
                                    library = {
                                        vim.env.VIMRUNTIME
                                        -- Depending on the usage, you might want to add additional paths here.
                                        -- E.g.: For using `vim.*` functions, add vim.env.VIMRUNTIME/lua.
                                        -- "${3rd}/luv/library"
                                        -- "${3rd}/busted/library",
                                    }
                                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                    -- library = vim.api.nvim_get_runtime_file("", true)
                                }
                            }
                        })
                    end
                    return true
                end,
                on_attach = lsp_zero.on_attach,
                capabilities = lsp_zero.capabilities,
                cmd = { "lua-language-server" },
                filetypes = { 'lua' },
                log_level = 2,
                root_dir = util.root_pattern(".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml",
                    "selene.toml", "selene.yml", ".git"),
                single_file_support = true,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }

            })
        end

        local cssls = function()
            lspconfig['cssls'].setup({
                on_attach = lsp_zero.on_attach,
                capabilities = lsp_zero.capabilities,
                cmd = { "vscode-css-language-server", "--stdio" },
                filetypes = { 'css', 'scss', 'less' },
                init_options = { provideFormatter = true },
                root_dir = util.root_pattern("package.json", ".git"),
                single_file_support = true,
                settings = {
                    css = {
                        validate = true
                    },
                    less = {
                        validate = true
                    },
                    scss = {
                        validate = true
                    }
                }
            })
        end

        local docker_compose_language_service = function()
            lspconfig['docker_compose_language_service'].setup({
                on_attach = lsp_zero.on_attach,
                capabilities = lsp_zero.capabilities,
                cmd = { "docker-compose-langserver", "--stdio" },
                filetypes = { "yaml.docker-compose" },
                root_dir = util.root_pattern("docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml"),
                single_file_support = true,
            })
        end

        local emmet_language_server = function()
            lspconfig['emmet_language_server'].setup({
                on_attach = lsp_zero.on_attach,
                capabilities = lsp_zero.capabilities,
                cmd = { "emmet-language-server", "--stdio" },
                filetypes = { "css", "eruby", "html", "htmldjango", "javascriptreact", "less", "pug", "sass", "scss", "typescriptreact" },
                root_dir = util.root_pattern(".git"),
                single_file_support = true,
            })
        end

        local eslint = function()
            lspconfig['eslint'].setup({
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        command = "EslintFixAll",
                    })
                end,
                capabilities = lsp_zero.capabilities,
                cmd = { "vscode-eslint-language-server", "--stdio" },
                filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
                settings = {
                    codeAction = {
                        disableRuleComment = {
                            enable = true,
                            location = "separateLine"
                        },
                        showDocumentation = {
                            enable = true
                        }
                    },
                    codeActionOnSave = {
                        enable = false,
                        mode = "all"
                    },
                    experimental = {
                        useFlatConfig = false
                    },
                    format = true,
                    nodePath = "",
                    onIgnoredFiles = "off",
                    problems = {
                        shortenToSingleLine = false
                    },
                    quiet = false,
                    rulesCustomizations = {},
                    run = "onType",
                    useESLintClass = false,
                    validate = "on",
                    workingDirectory = {
                        mode = "location"
                    }
                },
            })
        end

        local pyright = function()
            lspconfig['pyright'].setup({
                on_attach = lsp_zero.on_attach,
                capabilities = lsp_zero.capabilities,
                cmd = { "pyright-langserver", "--stdio" },
                filetypes = { "python" },
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true
                        }
                    }
                },
                single_file_support = true,
            })
        end

        local yamlls = function()
            lspconfig['yamlls'].setup({
                on_attach = lsp_zero.on_attach,
                capabilities = lsp_zero.capabilities,
                cmd = { "yaml-language-server", "--stdio" },
                filetypes = { "yaml", "yaml.docker-compose" },
                root_dir = util.root_pattern('.git'),
                settings = {
                    redhat = {
                        telemetry = {
                            enabled = false
                        }
                    }
                },
                single_file_support = true,
            })
        end

        mason_lspconfig.setup({
            handlers = {
                jdtls = lsp_zero.noop,
                gopls = gopls,
                tsserver = tsserver,
                angularls = angularls,
                ruby_ls = ruby_ls,
                templ = templ,
                lua_ls = lua_ls,
                cssls = cssls,
                dockerls = dockerls,
                docker_compose_language_service = docker_compose_language_service,
                emmet_language_server = emmet_language_server,
                eslint = eslint,
                pyright = pyright,
                yamlls = yamlls,
            },

        })

        mason_tool_installer.setup({
            ensure_installed = servers,
        })
    end
}
