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

""" dein start
" REF : https://github.com/Shougo/dein.vim
if &compatible
  set nocompatible               " Be iMproved
endif

" Set Dein base path (required)
let s:dein_base = '~/.cache/dein'

" Set Dein source path (required)
let s:dein_src = '~/.cache/dein/repos/github.com/Shougo/dein.vim'

" Set Dein runtime path (required)
execute 'set runtimepath+=' . s:dein_src

" Call Dein initialization (required)
call dein#begin(s:dein_base)

" Let dein manage dein
" Required:
call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

" Add or remove your plugins here like this:
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('Shougo/unite.vim')


" highlight
" REF : https://github.com/t9md/vim-quickhl
call dein#add('t9md/vim-quickhl')
" CAUTION!!! The following settings were changed from the default minimum settings on the github.
nmap m <Plug>(quickhl-manual-this)
xmap m <Plug>(quickhl-manual-this)
nmap M <Plug>(quickhl-manual-reset)
xmap M <Plug>(quickhl-manual-reset)


" status line
call dein#add('itchyny/lightline.vim')
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
      \ }
      \ }


" comment out
call dein#add('tpope/vim-commentary')
" gcc : comment out toggle


" ctag
" REF : https://qiita.com/aratana_tamutomo/items/59fb4c377863a385e032
" REF : https://qiita.com/soramugi/items/7014c866b705e2cd0b95
if executable('ctags')
  set tags+=.tags;
  au BufNewFile,BufRead *.c,*.cpp,*.h set tags+=$HOME/c.tags  
  au BufNewFile,BufRead *.c,*.cpp,*.h !ctags -R --languages=C,C++ -f ~/c.tags `pwd` 2>/dev/null &
  command TagsGen !ctags -R --languages=C,C++ -f ~/c.tags `pwd` 2>/dev/null &
endif
nnoremap <C-]> g<C-]>

" REF : https://github.com/preservim/tagbar
call dein#add('preservim/tagbar')
nmap <F8> :TagbarToggle<CR>

" smooth scroll
" call dein#add('yuttie/comfortable-motion.vim')

" FZF
" REF : https://github.com/Shougo/dein.vim/issues/74
call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 }) 
call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

" REF : https://www.wazalab.com/2018/09/23/2018%E5%B9%B4%E3%81%AEvim%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E6%A4%9C%E7%B4%A2%E3%83%BB%E6%96%87%E5%AD%97%E5%88%97%E6%A4%9C%E7%B4%A2%E3%81%AFfzf%E3%81%A8ripgreprg%E3%81%A7%E6%B1%BA%E3%81%BE/
fun! FzfOmniFiles()
  let is_git = system('git status')
  if v:shell_error
    :Files
  else
    :GitFiles
  endif
endfun
nnoremap <C-p> :call FzfOmniFiles()<CR>

let mapleader = "\<Space>"

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

" REF : https://blog.monochromegane.com/blog/2013/09/18/ag-and-unite/
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})

nnoremap <silent> <Space><Space>g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
nnoremap <silent> <Space><Space><Space> :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>

if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column --ignore-case'
  let g:unite_source_grep_recursive_opt = ''
endif

" REF : https://github.com/itchyny/calendar.vim
call dein#add('itchyny/calendar.vim')
command Calendaryv Calendar -view=year -split=vertical -width=27
command Calendaryh Calendar -view=year -split=horizontal -position=below -height=12
command Calendarm Calendar -first_day=monday

" REF : https://github.com/ervandew/supertab
" When using paste mode, this plugin can not work.
" call dein#add('ervandew/supertab')

" REF : https://kazuph.hateblo.jp/entry/2013/01/04/005030
call dein#add('kana/vim-operator-user')
call dein#add('kana/vim-operator-replace')
map P <Plug>(operator-replace)
" P + i + w : replace the word on cursor by reg 0 without update the reg 0

" REF : https://github.com/adi/vim-indent-rainbow
call dein#add('adi/vim-indent-rainbow')
call togglerb#map("<F9>")
let g:rainbow_colors_black= [ 238, 239, 240, 241, 242, 243 ]
let g:rainbow_colors_color= [ 226, 192, 195, 189, 225, 221 ]
set ts=2

" REF : https://github.com/luochen1990/rainbow
"" Target : markdown, lisp, haskell, vim, perl, stylus, css, nerdtree, only
" call dein#add('luochen1990/rainbow')
" let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

" REF : https://github.com/simeji/winresizer
call dein#add('simeji/winresizer')
" Ctrl + e : Resize window

" Finish Dein initialization (required)
call dein#end()

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
syntax enable

"
" If you want to install not installed plugins on startup.
  if dein#check_install()
    call dein#install()
  endif
"
""" dein end


" User defined commands
command Currentfilepath echo expand("%:p") 
command Currentfiledir echo expand("%:h") 
command Opencurrentfiledir e %:h

" vim -b : edit binary using xxd-format!
" REF : https://rdera.hatenadiary.org/entry/20081022/1224682665
augroup BinaryXXD
  " autocmd!
  " autocmd BufReadPre  *.bin let &binary =1
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r | endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
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
