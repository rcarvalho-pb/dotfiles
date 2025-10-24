return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    'nvim-telescope/telescope-file-browser.nvim',
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")

    -- or create your custom action
    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        trouble.toggle("quickfix")
      end,
    })

    telescope.setup({
      defaults = {
        layout_strategy = 'vertical',
        layout_config = {
          height = 0.95,
          width = 0.95,
          prompt_position = 'top',
        },
        selection_caret = " ",
        sorting_strategy = 'ascending',
        prompt_prefix = "🔍 ",
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-t>"] = trouble_telescope.open,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find todos" })
  
    vim.keymap.set("n", "<leader>e", function()
      require("telescope.builtin").find_files({
        cwd = vim.loop.cwd(),        -- usa o diretório atual
        hidden = true,               -- mostra arquivos ocultos
        no_ignore = false,           -- respeita .gitignore
        prompt_title = "📂 Arquivos",
        layout_strategy = "vertical",
        layout_config = {
          height = 0.95,
          width = 0.95,
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
      })
    end, { desc = "Abrir explorador (Telescope)" })

    -- vim.keymap.set("n", "<leader>n", function()
    --   local cwd = vim.loop.cwd()
    --   local filename = vim.fn.input("📄 Nome do novo arquivo: ", "", "file")
    --   if filename ~= "" then
    --     local path = cwd .. "/" .. filename
    --     vim.cmd("edit " .. path)
    --   end
    -- end, { desc = "Criar novo arquivo" })

    vim.api.nvim_create_autocmd("VimEnter", {
    callback = function(data)
      if vim.fn.isdirectory(data.file) == 1 then
        vim.cmd.cd(data.file)
        require("telescope.builtin").find_files({
          cwd = data.file,
          hidden = true,
          prompt_title = "📂 Arquivos",
          layout_strategy = "vertical",
          layout_config = {
            height = 0.95,
            width = 0.95,
            prompt_position = "top",
          },
        })
      end
    end,
  })
  end,
}