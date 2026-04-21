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
    end,
  },
}
