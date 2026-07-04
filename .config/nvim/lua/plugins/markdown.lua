return {
  {
    "godlygeek/tabular",
  },
  {
    "preservim/vim-markdown",
    branch = "master",
    dependencies = {
      "godlygeek/tabular",
    },
    ft = {
      "markdown",
    },
    init = function()
      vim.g.vim_markdown_follow_anchor = 1
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_conceal = 0
      vim.g.vim_markdown_conceal_code_blocks = 0
    end,
  },
}
