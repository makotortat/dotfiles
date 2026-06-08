local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
})
-- -- PowerShell help mappings
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "ps1",
--   callback = function()
--
--     local word = "<cword>"
--
--     -- PowerShell help
--     vim.keymap.set("n", "gp",
--       ':!pwsh -NoProfile -Command "Get-Help ' .. word .. '"<CR>',
--       {buffer=true})
--
--     -- examples
--     vim.keymap.set("n", "gP",
--       ':!pwsh -NoProfile -Command "Get-Help ' .. word .. ' -Examples"<CR>',
--       {buffer=true})
--
--     -- conceptual help
--     vim.keymap.set("n", "gh",
--       ':!pwsh -NoProfile -Command "Get-Help about_' .. word .. '"<CR>',
--       {buffer=true})
--
--     -- man fallback
--     vim.keymap.set("n", "gm",
--       ':Man ' .. word .. '<CR>',
--       {buffer=true})
--
--     -- open online docs
--     vim.keymap.set("n", "gK",
--       ':!pwsh -NoProfile -Command "Get-Help ' .. word .. ' -Online"<CR>',
--       {buffer=true})
--
--   end
-- })
