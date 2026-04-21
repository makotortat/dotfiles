" set setting
set paste
set nobackup
set noswapfile
set number
set cursorline
" set cursorcolumn
" set smartindent
set nosmartindent
set visualbell
set showmatch
set noignorecase

" REF : https://vim.blue/visualization-tab-space/
set listchars=tab:>>-,trail:-,nbsp:+,eol:↲,extends:»,precedes:«,space:␣

set fileencodings=utf-8,cp932,euc-jp,utf-16le

set tabstop=4



" ctag
" REF : https://qiita.com/aratana_tamutomo/items/59fb4c377863a385e032
" REF : https://qiita.com/soramugi/items/7014c866b705e2cd0b95
if executable('ctags')
  set tags+=.tags;
  au BufNewFile,BufRead *.c,*.cpp,*.h,*.ino set tags+=$HOME/c.tags
"  au BufNewFile,BufRead *.c,*.cpp,*.h !ctags -R --languages=C,C++ -f ~/c.tags `pwd` 2>/dev/null &
  command TagsGen !ctags -R --languages=C,C++ -f ~/c.tags `pwd` 2>/dev/null &
endif
nnoremap <C-]> g<C-]>


" REF : https://liginc.co.jp/469142
let g:fzf_buffers_jump = 1
nnoremap <silent> <Leader>ff :<C-u>Ag<CR>
nnoremap <silent> <Leader>fh :<C-u>History<CR>
nnoremap <silent> <Leader>ft :<C-u>call fzf#vim#tags(expand('<cword>'))<CR>
nnoremap <silent> <Leader>fb :<C-u>Buffers<CR>
nnoremap <silent> <Leader>fgs :<C-u>GFiles?<CR>
nnoremap <silent> <Leader>fgf :<C-u>GFiles<CR>
nnoremap <silent> <Leader>fm :<C-u>Marks<CR>
  let g:fzf_layout = { 'down': '30%' }
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-j': 'split',
    \ 'ctrl-l': 'vsplit' }
  augroup vimrc_fzf
      autocmd!
      autocmd FileType fzf tnoremap <buffer> <leader>z <Esc>
  augroup END



" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
syntax enable


" User defined commands
command Currentfilepath echo expand("%:p") 
command Currentfiledir echo expand("%:h") 
command Opencurrentfiledir e %:h

" vim -b : edit binary using xxd-format!
" REF : https://rdera.hatenadiary.org/entry/20081022/1224682665
" The code was modified.
" Due to unexpected translation after %!, functions are needed.
function! s:XXDBufReadPost()
  silent %!xxd -g 1
  setlocal ft=xxd
endfunction

function! s:XXDBufWritePre()
  silent %!xxd -r 
endfunction

function! s:XXDBufWritePost()
  silent %!xxd -g 1
  setlocal nomodified
endfunction

augroup BinaryXXD
  autocmd!
  " autocmd BufReadPre  *.bin let &binary =1 " if bin file is opened, set &binary as 1
  autocmd VimEnter * if &binary |
           \ echohl MoreMsg |
           \ echom "Vim is in binary mode (-b): xxd form will be used. If not needed, please check the .vimrc." |
           \ echohl None |
           \ endif
  autocmd BufReadPost * if &binary | call s:XXDBufReadPost() | endif
  autocmd BufWritePre * if &binary | call s:XXDBufWritePre() | endif
  autocmd BufWritePost * if &binary | call s:XXDBufWritePost() | endif
augroup END


" REF : https://tm.root-n.com/unix:command:vim:vimrc_include
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

" show settings with internal more
" :let
" :set
" :registers
" :buffers
" :function
" :map
" :autocmd
" :augroup
" :command
" If needs to seartch, try the following flow
" :set nomore
" :redir @a
" :let or other command
" :redir END
" :new
" :put a

" Manual
" :help help.txt
" :help index.txt
" :lhelp ${word}
" :lopen
