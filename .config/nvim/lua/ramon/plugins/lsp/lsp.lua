return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "mason-org/mason.nvim",
      lazy = false,
      opts = {
        ui = {
          check_outdated_packages_on_open = true,
          auto_update_packages = true,
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      },
    },
    {
      "mason-org/mason-lspconfig.nvim",
      lazy = false,
      opts = {
        ensure_installed = {},
        automatic_installation = false,
        automatic_setup = false,
        automatic_enable = false,
        handlers = nil,
      },
    },
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local mason_tool_installer = require("mason-tool-installer")

    mason_tool_installer.setup({
      ensure_installed = {
        "golangci-lint",
        "bash-language-server",
        "gopls",
        "lua-language-server",
        "vim-language-server",
        "stylua",
        "gofumpt",
        "golines",
        "gomodifytags",
        "gotests",
        "json-to-struct",
        "luacheck",
        "misspell",
        "revive",
        "vint",
        "jdtls",
        { "zls", version = "0.14.0" },
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 5,
      integrations = {
        ["mason-lspconfig"] = true,
      },
    })

    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )

    local servers = {
      lua_ls = {},
      kotlin_language_server = {},
      gopls = {
        settings = {
          gopls = {
            analyses = {
              shadow = true,
              unusedwrite = true,
              unusedvariable = true,
            },
            staticcheck = true,
            gofumpt = true,
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
    }

    local function enable_inlay_hints(client, bufnr)
      if client.server_capabilities.inlayHintProvider then
        local inlay_hint = vim.lsp.inlay_hint
        if type(inlay_hint) == "function" then
          inlay_hint(bufnr, true)
        end
      end
    end

    local on_attach = function(client, bufnr)
      enable_inlay_hints(client, bufnr)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map("n", "gd", vim.lsp.buf.definition, "[lsp][G]oto [D]efinition")
      map("n", "gD", vim.lsp.buf.declaration, "[lsp][G]oto [D]eclaration")
      map("n", "K", vim.lsp.buf.hover, "[lsp]Hover Documentation")
      map("n", "gr", vim.lsp.buf.references, "[lsp][G]oto [R]eferences")
      map("n", "gi", vim.lsp.buf.implementation, "[lsp][G]oto [I]mplementation")
      map("n", "<leader>rn", vim.lsp.buf.rename, "[lsp][R]e[n]ame")
      map("n", "<leader>ca", vim.lsp.buf.code_action, "[lsp][C]ode [A]ction")
      map("n", "<C-k>", vim.lsp.buf.signature_help, "[lsp] [S]ignature [H]elp")
      map("n", "<space>gt", vim.lsp.buf.type_definition, "[lsp] [T]ype [D]efinition")
      map("n", "<leader>gs", vim.lsp.buf.document_symbol, "[lsp] [D]oc [S]yms")
      map("n", "[d", function() vim.diagnostic.jump({ count = 1 }) end, "Prev Diagnostic")
      map("n", "]d", function() vim.diagnostic.jump({ count = -1 }) end, "Next Diagnostic")
      map("n", "<leader>gl", vim.diagnostic.setloclist, "[diag] [G]et diag [L]oclist")
      map("n", "<leader>co", vim.diagnostic.open_float, "[diag] hover line")
      map("n", "<leader>ih", function()
        local inlay_hint = vim.lsp.inlay_hint
        if type(inlay_hint) == "function" then
          inlay_hint(bufnr, true) -- toggle manually if needed
        end
      end, "[lsp] Toggle Inlay Hints")
    end

    vim.keymap.set("n", "<space>cwl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end)

    vim.keymap.set("n", "<leader>td", function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, { silent = true, noremap = true, desc = "[lsp] diag ON|OFF" })

    vim.keymap.set("n", "<leader>cf", function()
      vim.lsp.buf.format({
        filter = function(client)
          return client.name == "null-ls"
        end,
      })
    end, { desc = "Format with none-ls" })

    -- new API
    for server_name, server_opts in pairs(servers) do
      vim.lsp.config(server_name, vim.tbl_deep_extend("force", {
        on_attach = on_attach,
        capabilities = capabilities,
      }, server_opts))
      vim.lsp.enable(server_name)
    end
  end,
}
