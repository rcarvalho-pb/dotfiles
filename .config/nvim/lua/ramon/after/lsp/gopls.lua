return {

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

 

  on_attach = function(client, bufnr)

    -- Apenas ativa se o servidor suportar inlay hints

    if client.server_capabilities.inlayHintProvider then

      local ih = vim.lsp.inlay_hint

      -- Ativa por padrão

      ih.enable(true, { bufnr = bufnr })

 

      -- Cria um toggle local para o buffer

      vim.keymap.set("n", "<leader>ih", function()

        local enabled = ih.is_enabled({ bufnr = bufnr })

        ih.enable(not enabled, { bufnr = bufnr })

        local msg = enabled and "Inlay hints desativados" or "Inlay hints ativados"

        vim.notify(msg, vim.log.levels.INFO, { title = "gopls" })

      end, { buffer = bufnr, desc = "Toggle Inlay Hints (gopls)" })

    end

  end,

}