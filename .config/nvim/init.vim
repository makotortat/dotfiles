" init.vim
source ~/work/dotfiles/.config/nvim/common.vim

if has('nvim')
  " Neovim: lazy.nvim 側へ
  let s:dotfiles = fnamemodify(expand('~/work/dotfiles/.config/nvim'), ':p')
  let s:dotfiles = substitute(s:dotfiles, '\', '/', 'g')

  if !isdirectory(s:dotfiles)
    echoerr 'dotfiles dir not found: ' . s:dotfiles
    finish
  endif
  
  execute 'set runtimepath^=' . s:dotfiles
  
  if empty(nvim_get_runtime_file('lua/config/lazy.lua', v:true))
    echoerr 'lua/config/lazy.lua not found under runtimepath: ' . s:dotfiles
    finish
  endif

  lua require("config.lazy")
  execute 'set runtimepath^=' . s:dotfiles
  lua require("util.helpdispatch")
 nnoremap K :lua require("util.helpdispatch").dispatch()<CR>

nnoremap gH :lua require("util.helpdispatch").mode="shell"<CR>
nnoremap gL :lua require("util.helpdispatch").mode="lsp"<CR>
nnoremap gV :lua require("util.helpdispatch").mode="vim"<CR> 
  augroup arduino_filetype
    autocmd!
    autocmd BufNewFile,BufRead *.ino set filetype=cpp
  augroup END

else
  " Vim: vim-plug 側へ
  " source ~/vimfiles/core/plugins_vim.vim
endif




