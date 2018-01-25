" SPACING

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Use filetype detection and file-based automatic indenting.
    filetype plugin indent on

    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
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


" INFORMATION

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

" leave last command visible
set showcmd

" show line numbers
set number

" turn on line and column number in status bar
set ruler


" SEARCHING

set incsearch
set hlsearch

set tags=./tags;


" EDITING

" make backspace work
set backspace=indent,eol,start


" CUSTOM KEYBINDINGS

inoremap jj <Esc>

set timeoutlen=200


" PER-DIRECTORY .vimrc
set exrc
set secure
