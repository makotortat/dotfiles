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
  
  augroup arduino_filetype
    autocmd!
    autocmd BufNewFile,BufRead *.ino set filetype=cpp
  augroup END

  " lua require('config.options')
  " lua require('config.keymaps')
  " lua require('lazy').setup('plugins')
else
  " Vim: vim-plug 側へ
  " source ~/vimfiles/core/plugins_vim.vim
endif




