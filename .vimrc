set nocompatible

" PER-DIRECTORY .vimrc
set exrc
set secure

" But no per-file modelines.
set modelines=0


" AVOID DATA LOSS

" Keep undo information in *.un~ files
set undofile

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "1000:  will save up to 1000 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"1000,:20,%,n~/.viminfo

" TEXT
set encoding=utf-8


" SPACING

set autoindent

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Use filetype detection and file-based automatic indenting.
    filetype plugin indent on

    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab

    " clang-format
    autocmd FileType c,cpp map <C-I> :pyf ~/.vim/clang-format.py<CR>
    autocmd FileType c,cpp imap <C-I> <ESC>:pyf ~/.vim/clang-format.py<CR>i
endif

" For everything else, use a tab width of 2 space chars.
set tabstop=8       " Display TAB as having width 8.
set shiftwidth=2    " Indent width.
set softtabstop=2   " Sets the number of columns for a TAB.
set expandtab       " Expand TABs to spaces.


" HIGHLIGHTING

if exists('+colorcolumn')
  " highlight 80th column
  set colorcolumn=80
else
  " highlight columns after 80
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" highlight trailing whitespace
match ErrorMsg '\s\+$'

" turn on syntax highlighting
syntax on
colorscheme elflord

" Custom syntax support
au BufNewFile,BufRead SCons* set filetype=scons


" DISPLAY & INFORMATION

" Disable beeping, instead flash screen if possible
set visualbell

" Always show status bar
set laststatus=2

" leave last command visible
set showcmd

" Keep context lines visible around cursor
set scrolloff=3

" show line numbers
set number
set relativenumber

" turn on line and column number in status bar
set ruler

" Show as much as possible of line that wraps past end of window
set display+=lastline

" Show potentially unwanted whitespace and line wraps
set list listchars=tab:▸\ ,trail:·,nbsp:·,precedes:←,extends:→


" NAVIGATION

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk


" SEARCHING

set incsearch
set hlsearch
nnoremap <C-n> :noh<cr>

set ignorecase
set smartcase

set gdefault

set tags=./tags;


" EDITING

" make backspace work
set backspace=indent,eol,start

" Sensible autocomplete
set wildmenu
set wildmode=list:longest

" https://stackoverflow.com/a/18730056
xnoremap <expr> P '"_d"'.v:register.'P'

" CUSTOM KEYBINDINGS

inoremap jj <Esc>

set timeoutlen=200
