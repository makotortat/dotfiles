local M = {}

-- mode
-- auto  : 全部順番に試す
-- lsp   : LSPのみ
-- shell : PowerShell help
-- vim   : vim help
M.mode = vim.g.help_dispatch_mode or "auto"

local function word()
  return vim.fn.expand("<cword>")
end


-- LSP hover
local function try_lsp()
  local clients = vim.lsp.get_clients({bufnr=0})
  if #clients > 0 then
    vim.lsp.buf.hover()
    return true
  end
  return false
end


-- PowerShell help
local function try_pwsh()
  if vim.bo.filetype ~= "ps1" then
    return false
  end

  local cmd = string.format(
    "pwsh -NoProfile -Command \"Get-Help %s\"",
    -- "powershell -NoProfile -Command \"Get-Help %s\"",
    word()
  )

  vim.cmd("split | terminal " .. cmd)
  return true
end


-- Vim help
local function try_vimhelp()

  local topic = word()

  local ok = pcall(vim.cmd, "help " .. topic)

  if ok then
    return true
  end

  return false
end


-- man
local function try_man()

  local ok = pcall(vim.cmd, "Man " .. word())

  if ok then
    return true
  end

  return false
end


-- web
local function open_web()

  local query = word()

  local url =
    "https://www.google.com/search?q=" .. query

  vim.fn.jobstart({
    "cmd",
    "/c",
    "start",
    url
  }, {detach=true})

end


function M.dispatch()

  if M.mode == "lsp" then
    try_lsp()
    return
  end

  if M.mode == "shell" then
    try_pwsh()
    return
  end

  if M.mode == "vim" then
    try_vimhelp()
    return
  end


  -- auto mode

  if try_lsp() then return end
  if try_pwsh() then return end
  if try_vimhelp() then return end
  if try_man() then return end

  open_web()

end


return M
