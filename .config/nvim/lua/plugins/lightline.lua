return {
  "itchyny/lightline.vim",
  init = function()
    vim.g.lightline = {
      active = {
        left = {
          { "mode", "paste" },
          { "readonly", "absolutepath", "modified" },
        },
      },
    }
  end,
}
