" Leader to ;
let mapleader=";"

" No compatibility with Vi
set nocompatible

" status line
set laststatus=2
"set statusline=%f\ %m\ %r\ %y%=%l/%L\,%c\ [%p%%]
set statusline=%<%-.30t\ %h%m%r%5y%=%-5.(%l/%L,%c%V%)\ [%p%%]

" indenting spaces
set shiftwidth=2

" stops for a tab
set tabstop=2

" Auto indenting
set autoindent

" Show cursor line
set ruler

" highlight cursor line
set cursorline

" search
set incsearch

set ignorecase
set smartcase

" highlight search
set hlsearch
hi CursorLine cterm=NONE ctermbg=234

" find files recursively
set path+=**

" matching brackets
set showmatch

" syntax highlighting
syntax enable
colorscheme cobalt

" Enable file type detection and auto indentation accordingly
filetype plugin on
filetype indent on

set wildmenu

" tags
command! MakeTags !ctags -R .

" splits
nmap <C-h> :vertical res +5 <CR>
nmap <C-l> :vertical res -5 <CR>
nmap <C-j> :res +5 <CR>
nmap <C-k> :res -5 <CR>

" copy to clipboard
noremap <Leader>y "+y
noremap <Leader>p "+p

" netrw file browser
let g:netrw_banner=0           " disable top banner
let g:netrw_browse_split=4     " open in prior window
"let g:netrw_altv=1             " open splits to the right
let g:netrw_winsize=75         " new split size in percentage
let g:netrw_liststyle=3        " tree view

" Learning
" ========
" Tags
" ----
" C-] jump to tag under cursor
" C-t go back the stack of tag jumbs
" 
" Autocomplete
" ------------
"  C-x C-n words list on the current file
"  C-x C-f autocomplete files
"  C-x C-] autocomplete from the tags list
"  C-n move to next item in the autocomplete list
"  C-p move to previous item in the autocomplete list
"
"
" Navigation
" ----------
"  f char jumps to the first occarance of the 'char' on the line
"  cl lists the errors in the current file
"  cn moves next on the list of errors in the current file
"  cp move previous on the list of errors in the current file
