" = necessary
" - text
set encoding=utf-8


" = general
set nocompatible

if has('win32')
  let vimfiles = $VIM.'/vimfiles'
endif

if has('vim_starting')
  let &runtimepath.=','.vimfiles.'/dein.vim/'
endif


" = visuals
" - colors
set background=dark
colorscheme wombat256mod
" - fonts
if has('gui_running')
  if has('gui_win32')
    set guifont=Consolas:h11
  "else
    "set guifont=Consolas\ 12
  endif
endif
" - cursor
set cursorline
" - search
set hlsearch


" = ui
" - window
if has('gui_running') && has('gui_win32') " in gvim, on windows
  aug _maximize " start maximized
    au!
    au GUIEnter * simalt ~x
  aug END
endif
" - elements
set guioptions-=m " menu
set guioptions-=T " toolbar
set guioptions-=r " right scroll bar
set guioptions-=l " left scroll bar
set guioptions-=L
" - line numbers
set number
set relativenumber


" = behaviour
" - session
set sessionoptions+=resize,winpos " restore size/position of window
set sessionoptions-=options " do not restore temporary options
" - text
set nowrap
syntax on
" - search
set ignorecase
set smartcase
set incsearch
" - windows
"if has('vim_starting') && has('win32')
  "source $VIMRUNTIME/mswin.vim
  "behave mswin
"endif
" - buffer
set splitbelow
set splitright


" = key maps
let mapleader = ';'
let maplocalleader = ';'
" - buffer
nnoremap <c-q> :q<cr>
nnoremap <c-s> :update<cr>
nnoremap <up> 5<c-w>-
nnoremap <down> 5<c-w>+
nnoremap <left> 5<c-w><
nnoremap <right> 5<c-w>>
" - navigation
" . inside buffer
nnoremap <space> <c-d>
xnoremap <space> <c-d>
nnoremap <s-space> <c-u>
xnoremap <s-space> <c-u>
nnoremap <a-h> h
xnoremap <a-h> h
nnoremap <a-n> j
xnoremap <a-n> j
nnoremap <a-e> k
xnoremap <a-e> k
nnoremap <a-i> l
xnoremap <a-i> l
nnoremap # ^
xnoremap # ^
nnoremap <c-i> <c-o>
nnoremap <c-o> <c-i>
" . between buffer
nnoremap <c-h> <c-w>h
nnoremap <c-n> <c-w>j
nnoremap <c-e> <c-w>k
nnoremap <c-k> <c-w>l
" - search
nnoremap / /\v
xnoremap / /\v
nnoremap // :nohlsearch<cr>
nnoremap R :%s///g<left><left>
xnoremap R :s///g<left><left>
nnoremap = *
xnoremap = *
nnoremap - #
xnoremap - #
" - tabs
nnoremap <c-t> :tabnew<cr>
nnoremap <a-1> 1gt
nnoremap <a-2> 2gt
nnoremap <a-3> 3gt
nnoremap <a-4> 4gt
nnoremap <a-5> 5gt
nnoremap <a-6> 6gt
nnoremap <a-7> 7gt
nnoremap <a-8> 8gt
nnoremap <a-9> :tabmove -1<cr>
nnoremap <a-0> :tabmove +1<cr>
" - copy paste
nnoremap <cr> "+yyj
nnoremap <s-cr> m`0"+y$``
" insert before cursor, cursor moves to the end
nnoremap p gP
" insert at the end of line, cursor moves to the entry point of the insertion
nnoremap P $p`[
" copy to clipboard, stay in visual mode
xnoremap <c-c> "+ygv
" move to clipboard
xnoremap <c-x> "+ygvd
" insert clipboard and move to the end
nnoremap <c-v> "+gP
" insert clipboard at the end of line, cursor moves to the entry point of the insertion
"nnoremap <c-s-v> $"+p`[ " doesnt work because c-s-v is equal to c-v
" insert clipboard, move to the end, stay in insert mode
inoremap <c-v> <c-R>+
" replace selection, move to the end
xnoremap <c-v> d"+gP
" - visual mode
nnoremap vv <c-v>


" = plugins
call dein#begin(vimfiles.'/plugins/')
call dein#add(vimfiles.'/dein.vim/')

" - startify
call dein#add('mhinz/vim-startify')
let g:startify_list_order = ['sessions', 'files', 'bookmarks']
let g:startify_bookmarks = [ {'!': $MYVIMRC} ]
let g:startify_session_dir = vimfiles.'/sessions'
nnoremap <leader>ss :Startify<cr>
nnoremap <leader>sq :SDelete! temp<cr>:SSave temp<cr>:q!<cr>

" - NERD commenter
call dein#add('scrooloose/nerdcommenter')

" = sneak
call dein#add('notEvil/vim-sneak')
let g:sneak#use_ic_scs = 1 " smartcase
let g:sneak#s2ws = 2
let g:sneak#dot2any = 1
let g:sneak#myopt = {
\   'labels': {
\     'main': 'tnseriao',
\     'above': 'plfuwyq;gj',
\     'below': 'dhvkcmx,z.',
\     'extra': '234567890'
\   }
\ }
nmap s <Plug>(MyStreak)

" = airline
call dein#add('vim-airline/vim-airline')
set laststatus=2
set noshowmode
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
call dein#add('vim-airline/vim-airline-themes')
let g:airline_theme = 'powerlineish'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" = ycm
call dein#add('Valloric/YouCompleteMe')
nnoremap gd :YcmCompleter GoTo<cr>
nnoremap gr :YcmCompleter GoToReferences<cr>
"let g:ycm_key_list_select_completion = ['<tab>']
"let g:ycm_key_list_previous_completion = ['<s-tab>']
"let g:ycm_use_ultisnips_completer = 0
"let g:ycm_goto_buffer_command = 'new-tab'
" it's not possible to remap gd
"nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<cr>
"inoremap <Nul> <C-n>

call dein#end()


" = necessary
" - dein
filetype plugin indent on
syntax enable
