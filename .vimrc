set nocompatible " be IMproved

" = neobundle
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'


" = general
filetype plugin indent on " required!

set sessionoptions+=resize,winpos " restore size/position of window
set sessionoptions-=options " do not restore temporary options
set encoding=utf-8
syntax on
"set autochdir " auto change current directory to file parent
" may cause more trouble than help

" probably necessary
"source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin


" = visual
" == gui
set guioptions-=T " remove toolbar
set guioptions-=m " remove menu
set guioptions-=r " remove right scrollbar
set guioptions-=L " remove left scrollbar
set guioptions-=b " remove bottom scrollbar
if has("gui_running") && has("gui_win32") " in gvim, on windows
  autocmd GUIEnter * simalt ~x " start maximized
endif
" == colors
colorscheme wombat
set background=dark
" == font
if has("gui_running")
  if has("gui_win32")
    set guifont=Consolas:h11
  else
    set guifont=Inconsolata\ 12
  endif
endif



" = key mappings
let mapleader="ö"
" == windows
" navigation
map <a-h> <c-w>h
map <a-j> <c-w>j
map <a-k> <c-w>k
map <a-l> <c-w>l
" resize
map <up> <c-w>-
map <down> <c-w>+
map <left> <c-w><
map <right> <c-w>>
" == tabs
map <c-h> :tabprevious<CR>
map <c-l> :tabnext<CR>
map <c-t> :tabnew<CR>
" == navigation
nmap <space> <c-d>
vmap <space> <c-d>
nmap <a-space> <c-u>
vmap <a-space> <c-u>
" == shortcuts
" === esc
imap fd <esc>
" === enter
imap jk <cr>
" === save
nmap <c-s> :update<cr>
nmap <c-S> :update<cr>
imap <c-s> <esc>:update<cr>a
imap <c-S> <esc>:update<cr>a
" == regex
nmap / /\v
vmap / /\v
" == search
nmap // :nohlsearch<cr>
set hlsearch
highlight Search guibg=Orange2


" = indent
set softtabstop=4
set shiftwidth=4
set autoindent


" = search
set ignorecase
set smartcase
set incsearch


" = line numbers
set relativenumber



" = airline
NeoBundle 'bling/vim-airline'
set laststatus=2
set noshowmode
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts=1

" = ctrlp
NeoBundle 'kien/ctrlp.vim'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_custom_ignore = {
	    \ 'dir': '\v[\/]\.'
	    \ }
let g:ctrlp_follow_symlinks = 0

" = nerdtree
NeoBundle 'scrooloose/nerdtree'
nmap <leader>t :NERDTreeToggle<cr>

" = ycm
NeoBundle 'Valloric/YouCompleteMe'

" = python-mode
NeoBundle 'klen/python-mode'

" = startify
NeoBundle 'mhinz/vim-startify'
let g:startify_session_dir = '~/.vim/sessions'
let g:startify_cumstom_indices = ['u', 'i', 'o', 'p']
let g:startify_session_persistence = 1
let g:startify_bookmarks = [ '~/.vimrc' ]
map <leader>s :Startify<cr>


" = neobundle
NeoBundleCheck
