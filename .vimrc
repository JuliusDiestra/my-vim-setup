" Syntax highlights
syntax on
colorscheme torte

" compatible is set to on by default. While a .vimrc file is found, is set to off.
" But, it is added just in case.
set nocompatible

" Provides tab-completition for all file-related tasks
set path+=**
"set path+=/usr/include/c++/7
"set path+=/usr/lib/llvm-3.9/lib/clang/3.9.1/include
" Enables a menu at the bottom of the vim window
set wildmenu
" Tab completion #new added
set wildmode=list:longest,full
" Ignore case in tab completion
set wildignorecase
" Ignore build folder #new added
 set wildignore+=*/build/*

" No sound
set noerrorbells
" Tabs settings
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Show complete line, do not split a long line.
set nowrap
" Show line numbers
set number
" Set relative number.
set relativenumber
set nu
" Searching without problems without casesensitive
set ignorecase
set smartcase

" Do not keep history
set nobackup
set noswapfile

" Save undo after file closese in .vim/undodir
set undodir=~/.vim/undodir
set undofile

" Enable incremental search: Use / and the highlights will move as you increase words
set incsearch
"set termguicolors

set scrolloff=15
" Jumps while I press ctrl-u and ctrl-d
set scroll=10

"set signcolumn=yes


" More space to display messages
set cmdheight=2

set backspace=indent,eol,start

" Set autocomplete tabnine
set rtp+=~/.vim/tabnine-vim

" YAML file configuration : auto-identation
augroup yaml_fix
    autocmd!
    autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>
augroup END

" Netrw settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_localrmdir='rm -r'  " To be able to remove directories and files inside pressing D #new_added

" #########################
" White spaces
" ########################
" White spaces in red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au BufWinLeave * call clearmatches()
" Remove white spaces by pressing: \rs
nnoremap <silent> <leader>rs :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" #########################
" Man pages and cppman
" ########################
" Activate man plugin
runtime! ftplugin/man.vim

" C++ manual
" Install man, usually already installed: sudo apt-get install man
" Install cppman : sudo apt-get install cppman
" Add cppman to man: cppman -m true
" In case this fails, there is a bug in /usr/lib/python3/dist-package/cppman/util.py
" Optional : Adding cache : cppman -c
" Set:
"   cppman -m 'true'
"   cppman -s 'cppreference.com'
"   cppman -c
"   In ubuntu 20.04 I had to add < export MANPATH="$(manpath -g):$HOME/.cache/cppman > to ~/.bashrc so I could call man std::vector
function! s:JbzCppMan()
    let old_isk = &iskeyword
    setl iskeyword+=:
    let str = expand("<cword>")
    let &l:iskeyword = old_isk
    execute 'Man ' . str
endfunction
command! JbzCppMan :call s:JbzCppMan()

au FileType cpp nnoremap <buffer>K :JbzCppMan<CR>

" #########################
" Plugin manager
" ########################
" Automatic installation of vim plugin manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" #########################
" Install plugin
" ########################
" Install plugins using -> :PlugInstall
call plug#begin()

Plug 'derekwyatt/vim-fswitch'           " Plugin to jump between .hpp and .cpp files
"Plug 'ludovicchabant/vim-gutentags'     " Plugin to manage ctags

call plug#end()

" #########################
" vim-fswitch settings
" ########################
au BufEnter *.h  let b:fswitchdst = "c,cpp,cc,m"
au BufEnter *.cc let b:fswitchdst = "h,hpp"
au BufEnter *.h let b:fswitchdst = 'c,cpp,m,cc' | let b:fswitchlocs = 'reg:|include.*|src/**|'
" nnoremap <silent> <A-o> :FSHere<cr>
nnoremap <silent> <localleader>oo :FSHere<cr>
" Extra hotkeys to open header/source in the split
"       Works using: \oh \oj \ok \ol
nnoremap <silent> <localleader>oh :FSSplitLeft<cr>
nnoremap <silent> <localleader>oj :FSSplitBelow<cr>
nnoremap <silent> <localleader>ok :FSSplitAbove<cr>
nnoremap <silent> <localleader>ol :FSSplitRight<cr>

" ############################
" Clang-format
" ############################
map <C-K> :py3f /usr/share/clang/clang-format-15/clang-format.py<cr>
imap <C-K> <c-o>:py3f /usr/share/clang/clang-format-15/clang-format.py<cr>

function! s:ClangFormatFile()
    let l:lines="all"
    py3f /usr/share/clang/clang-format-15/clang-format.py
endfunction
command! ClangFormatFile :call s:ClangFormatFile()
au FileType cpp nnoremap <silent> <localleader>cff :ClangFormatFile<cr>

" #########################
" ctags settings
" #########################
" Installing: sudo snap install universal-ctags
" PENDING
set tags=./tags;
