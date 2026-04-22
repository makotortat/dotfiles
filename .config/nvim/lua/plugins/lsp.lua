return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("clangd", {
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_markers = { "compile_commands.json", ".git" },
      })
      vim.lsp.enable("clangd")

      local function qf(method, extra_arg)
        return function()
          local fn = vim.lsp.buf[method]
          if extra_arg == nil then
            fn({
              on_list = function(items)
                vim.fn.setqflist({}, " ", items)
                vim.cmd("botright copen")
              end,
            })
          else
            fn(extra_arg, {
              on_list = function(items)
                vim.fn.setqflist({}, " ", items)
                vim.cmd("botright copen")
              end,
            })
          end
        end
      end

      vim.keymap.set("n", "<C-]>", qf("definition"),   { desc = "Definition list" })
      vim.keymap.set("n", "gD",   qf("declaration"),  { desc = "Declaration list" })
      vim.keymap.set("n", "gi",   qf("implementation"), { desc = "Implementation list" })
      vim.keymap.set("n", "gr",   qf("references"),   { desc = "References list" })
      vim.keymap.set("n", "K",    vim.lsp.buf.hover,  { desc = "Hover" })
    end,
  },
}
