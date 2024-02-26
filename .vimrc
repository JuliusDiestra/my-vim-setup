" Syntax highlights
syntax on

" Colors settings
colorscheme torte

" compatible is set to on by default. While a .vimrc file is found, is set to off.
" But, it is added just in case.
set nocompatible

" Provides tab-completition for all file-related tasks
set path+=**

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

set scrolloff=15
" Jumps while I press ctrl-u and ctrl-d
set scroll=10

" More space to display messages
set cmdheight=2

set backspace=indent,eol,start

" YAML file configuration : auto-identation
augroup yaml_fix
    autocmd!
    autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>
augroup END


" ##################################
" NETRW settings
" ##################################
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_localrmdir='rm -r'  " To be able to remove directories and files inside pressing D

" ##########################################
" White spaces
" -> Press \rs to remove all empty spaces.
" #########################################
" White spaces in red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
au BufWinEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
au BufWinLeave * call clearmatches()
" Remove white spaces by pressing: \rs
nnoremap <silent> <leader>rs :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" ##########################################################
" Man pages and cppman
" -> Press K in the C++ datatype and it will open manpages
" ##########################################################
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
""   In ubuntu 20.04 I had to add < export MANPATH="$(manpath -g):$HOME/.cache/cppman > to ~/.bashrc so I could call man std::vector
function! s:JbzCppMan()
    let old_isk = &iskeyword
    setl iskeyword+=:
    let str = expand("<cword>")
    let &l:iskeyword = old_isk
    execute 'Man ' . str
endfunction
command! JbzCppMan :call s:JbzCppMan()

au FileType cpp nnoremap <buffer>K :JbzCppMan<CR>

" ############################
" Clang-format
" -> Clang format current file : \cff
" ############################
map <C-K> :py3f /usr/share/clang/clang-format-15/clang-format.py<cr>
imap <C-K> <c-o>:py3f /usr/share/clang/clang-format-15/clang-format.py<cr>

function! s:ClangFormatFile()
    let l:lines="all"
    py3f /usr/share/clang/clang-format-15/clang-format.py
endfunction
command! ClangFormatFile :call s:ClangFormatFile()
au FileType cpp nnoremap <silent> <localleader>cff :ClangFormatFile<cr>

" ################################################
" Plugin manager
" -> Automatic installation of vim plugin manager
" ################################################
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" #####################################################
" Plugins Installation
" -> Run :PlugInstall to install all plugins I need.
" #####################################################
call plug#begin()

Plug 'derekwyatt/vim-fswitch'           " Plugin to jump between .hpp and .cpp files
Plug 'vim-scripts/OmniCppComplete'
Plug 'JuliusDiestra/modified-cpp-headers'

call plug#end()

" ##############################################
" Plugin vim-fswitch settings
" -> Jump from hpp->cpp or cpp->hpp file using:
"    \oh : Open new window to the left.
"    \oj : Open new window below.
"    \ok : Open new window above.
"    \ol : Open new window to the right.
"    \oo : Open in same window.
" ###############################################
au BufEnter *.h  let b:fswitchdst = "c,cpp,cc,m"
au BufEnter *.cc let b:fswitchdst = "h,hpp"
au BufEnter *.h let b:fswitchdst = 'c,cpp,m,cc' | let b:fswitchlocs = 'reg:|include.*|src/**|'
" nnoremap <silent> <A-o> :FSHere<cr>
nnoremap <silent> <localleader>oo :FSHere<cr>
nnoremap <silent> <localleader>oh :FSSplitLeft<cr>
nnoremap <silent> <localleader>oj :FSSplitBelow<cr>
nnoremap <silent> <localleader>ok :FSSplitAbove<cr>
nnoremap <silent> <localleader>ol :FSSplitRight<cr>

" ############################################################
" OmniCppComplete
" ############################################################
au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main
filetype on

" configure tags - add additional tags here or comment out not-used ones
set tags+=./tags
set tags+=~/.vim/plugged/modified-cpp-headers/gcc_9_tags
" build tags of your own project with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q -I _GLIBCXX_NOEXCEPT .<CR>

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
" also necessary for fixing LIBSTDC++ releated stuff
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

