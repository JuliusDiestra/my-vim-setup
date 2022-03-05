" Syntax highlights
syntax on
colorscheme koehler

" compatible is set to on by default. While a .vimrc file is found, is set to off. 
" But, it is added just in case.
set nocompatible

" Provides tab-completition for all file-related tasks
set path+=**
set path+=/usr/include/c++/7
set path+=/usr/lib/llvm-3.9/lib/clang/3.9.1/include
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
