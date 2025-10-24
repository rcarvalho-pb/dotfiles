return {

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

 

  on_attach = function(client, bufnr)

    -- Garante que o servidor suporte inlay hints

    if client.server_capabilities.inlayHintProvider then

      local ih = vim.lsp.inlay_hint

      ih.enable(true, { bufnr = bufnr })

 

      vim.keymap.set("n", "<leader>ih", function()

        local enabled = ih.is_enabled({ bufnr = bufnr })

        ih.enable(not enabled, { bufnr = bufnr })

        local msg = enabled and "Inlay hints desativados" or "Inlay hints ativados"

        vim.notify(msg, vim.log.levels.INFO, { title = "zls" })

      end, { buffer = bufnr, desc = "Toggle Inlay Hints (zls)" })

    end

  end,

}