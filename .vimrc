" ##################################
" General settings
" ##################################

" Syntax highlights
syntax on

" Filetype settings
filetype on
filetype plugin on

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

" ###############################################
" YAML file configuration : auto-identation
" ###############################################
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
" Remove White spaces
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


" ############################
" Go to File : Go over the file name/header file.
" -> Same window : gf
" -> Split vertical : \gv
" -> Split horizontal : \gs
" ############################

" Recognize these suffixes when using gf
set suffixesadd=.h,.hpp,.cpp,.cc,.cxx

" OLD SIMPLE Setting- Use shorcuts for gf with vertical and horizontal splt
" nnoremap <Leader>gs :sfind <C-R>=expand("<cfile>")<CR><CR>
" nnoremap <Leader>gv :vert sfind <C-R>=expand("<cfile>")<CR><CR>

" Function to find and open a file under cursor with :split or :vsplit

function! FindAndSplitFile(split_cmd)
    let l:file = expand("<cfile>")
    let l:matches = split(globpath(&path, l:file), "\n")

    " Normalize and deduplicate the results
    let l:unique = {}
    let l:deduped = []

    for path in l:matches
        let l:real = resolve(fnamemodify(path, ':p')) " get absolute resolved path
        if !has_key(l:unique, l:real)
            let l:unique[l:real] = 1
            call add(l:deduped, path)
        endif
    endfor

    if empty(l:deduped)
        echohl WarningMsg | echo "File not found: " . l:file | echohl None
        return
    endif

    if len(l:deduped) == 1
        execute a:split_cmd . ' ' . fnameescape(l:deduped[0])
        return
    endif

    let l:choices = ['Choose a file:']
    for i in range(len(l:deduped))
        call add(l:choices, printf('%d. %s', i + 1, l:deduped[i]))
    endfor

    let l:choice = inputlist(l:choices)

    if l:choice >= 1 && l:choice <= len(l:deduped)
        execute a:split_cmd . ' ' . fnameescape(l:deduped[l:choice - 1])
    else
        echo "No file selected."
    endif
endfunction

" Key mappings
nnoremap <Leader>gs :call FindAndSplitFile('split')<CR>
nnoremap <Leader>gv :call FindAndSplitFile('vsplit')<CR>


" ############################
" Switch between header and source files
" <Leader>oo → Open in same window
" <Leader>oj → Split below
" <Leader>ok → Split above
" <Leader>ol → Vertical split right
" <Leader>oh → Vertical split left
" ############################

set splitbelow
set splitright

function! ToggleSourceHeader(mode)
    let l:filename = expand('%:t')        " e.g., my_file.hpp
    let l:basename = expand('%:t:r')      " e.g., my_file
    let l:ext = expand('%:e')             " e.g., hpp
    let l:current_dir = expand('%:p:h')   " full path to current file's directory
    let l:parent_dir = fnamemodify(l:current_dir, ':h') " one directory up

    let l:headers = ['h', 'hpp']
    let l:sources = ['cpp', 'cc', 'cxx', 'c']

    if index(l:headers, l:ext) >= 0
        let l:extensions = l:sources
    elseif index(l:sources, l:ext) >= 0
        let l:extensions = l:headers
    else
        echo "Not a recognized C++ source/header file"
        return
    endif

    " Step 1: current directory (non-recursive)
    for ext in l:extensions
        let l:path = l:current_dir . '/' . l:basename . '.' . ext
        if filereadable(l:path)
            execute a:mode . ' ' . fnameescape(l:path)
            return
        endif
    endfor

    " Step 2 & 3: ../include, ../inc, ../src (recursive)
    let l:search_dirs = ['include', 'inc', 'src']
    for dir in l:search_dirs
        let l:basepath = l:parent_dir . '/' . dir
        for ext in l:extensions
            let l:pattern = l:basepath . '/**/' . l:basename . '.' . ext
            let l:found = glob(l:pattern, 0, 1)
            if !empty(l:found)
                execute a:mode . ' ' . fnameescape(l:found[0])
                return
            endif
        endfor
    endfor

    " Step 4: full recursive fallback search
    for ext in l:extensions
        let l:pattern = '**/' . l:basename . '.' . ext
        let l:found = glob(l:pattern, 0, 1)
        if !empty(l:found)
            execute a:mode . ' ' . fnameescape(l:found[0])
            return
        endif
    endfor

    " Offer to create the file in current directory
    let l:new_ext = l:extensions[0]
    let l:new_path = l:current_dir . '/' . l:basename . '.' . l:new_ext
    if confirm("File not found. Create " . l:new_path . "?", "&Yes\n&No") == 1
        call mkdir(fnamemodify(l:new_path, ':h'), 'p')
        execute a:mode . ' ' . fnameescape(l:new_path)
    else
        echo "Aborted."
    endif
endfunction

nnoremap <Leader>oo :call ToggleSourceHeader('edit')<CR>
nnoremap <Leader>oj :call ToggleSourceHeader('split')<CR>
nnoremap <Leader>ok :call ToggleSourceHeader('aboveleft split')<CR>
nnoremap <Leader>ol :call ToggleSourceHeader('vsplit')<CR>
nnoremap <Leader>oh :call ToggleSourceHeader('aboveleft vsplit')<CR>

