return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      },
      pickers = {
        find_files = {
          initial_mode = "normal",
        },
        grep_string = {
          initial_mode = "normal",
        },
        live_grep = {
          initial_mode = "insert",
        },
      },
    })

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader><leader><leader>", builtin.grep_string, { desc = "Grep word under cursor" })
  end,
}
