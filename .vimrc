" = general
set nocompatible

let configdir = (has('win32') ? $VIM.'/vimfiles' : $HOME.'/.config/nvim')

if has('vim_starting')
  let &runtimepath.=','.configdir.'/dein.vim/'
endif


" = visuals
" - colors
set background=dark
colorscheme wombat256mod
" - fonts
if has('gui_running')
  let font = (has('gui_win32') ? 'Consolas:h11' : (has('gui') ? 'Consolas\ 12' : ''))
  if font != ''
    exec 'set guifont='.font
  endif
endif
" - cursor
set cursorline
" - search
set hlsearch
" - colored line number
let LineColors = [[255, 0, 0],
                \ [0, 255, 0],
                \ [0, 0, 255]]
fun! HighlightLinenumber()
  let endLNr = line('$')
  let p = (line('.') - 1.0) / ((2 < endLNr ? endLNr : 2) - 1)

  let end = len(g:LineColors) - 1
  let i = float2nr(p * end)
  if i == end
    let i -= 1
  endif
  let p2 = p * end - i

  let color_from = g:LineColors[i]
  let color_to = g:LineColors[i + 1]
  let r = float2nr( Interpolate(p2, color_from[0], color_to[0]) )
  let g = float2nr( Interpolate(p2, color_from[1], color_to[1]) )
  let b = float2nr( Interpolate(p2, color_from[2], color_to[2]) )
  let bg_c = printf('%02x%02x%02x', r, g, b)

  let fg_c = (p <= 0.1 || 0.9 <= p ? 'white' : 'black')
  exe('hi CursorLineNr guibg=#'.bg_c.' guifg='.fg_c)
endfun
fun! Interpolate(p, a, b)
  return a:a + a:p * (a:b - a:a)
endfun
aug _highlightLinenumber
  au!
  au CursorMoved * call HighlightLinenumber()
aug END


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


" = behaviour
" - session
set sessionoptions+=resize,winpos " restore size/position of window
set sessionoptions-=options " do not restore temporary options
" - line numbers
set relativenumber
" - text
set encoding=utf-8
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
" - indent
set expandtab
set softtabstop=4
set shiftwidth=4
set autoindent
set backspace=indent,eol
" - folds
set foldmethod=indent
aug _maxfoldlevel
  au!
  au Syntax * normal! zR
aug END
" - tpope/vim-sensible
set nrformats-=octal
"set display+=lastline " incompatible with sneak
" - command line
set wildmenu


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
nnoremap ? ?\v
xnoremap ? ?\v
nnoremap // :nohlsearch<cr>
nnoremap R :%s///g<left><left>
xnoremap R :s///g<left><left>
nnoremap - #
nnoremap = *
xnoremap - ""y?\V<c-r>=escape(@", '\/')<cr><cr>gn
xnoremap = ""y/\V<c-r>=escape(@", '\/')<cr><cr>gn
" - tabs
nnoremap <c-t> :tab split<cr>
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
nnoremap p gP| " insert before cursor, cursor moves to the end
cnoremap <c-p> <c-r>"
nnoremap P $p`[| " insert at the end of line, cursor moves to the entry point of the insertion
xnoremap <c-c> "+ygv| " copy to clipboard, stay in visual mode
xnoremap <c-x> "+ygvd| " move to clipboard
nnoremap <c-v> "+gP| " insert clipboard and move to the end
" insert clipboard at the end of line, cursor moves to the entry point of the insertion
"nnoremap <c-s-v> $"+p`[ " doesnt work because c-s-v is equal to c-v
inoremap <c-v> <c-r>+| " insert clipboard, move to the end, stay in insert mode
xnoremap <c-v> d"+gP| " replace selection, move to the end
cnoremap <c-v> <c-r>+
" - visual mode
nnoremap vv <c-v>
xnoremap . :normal! .<cr>
" - insert mode
inoremap <silent> <esc> <esc>`^
" - nop
nnoremap Q <nop>
" - folds
nnoremap zf za
nnoremap zF zA
nnoremap zc zm
nnoremap zo zr
nnoremap zC zM
nnoremap zO zR


" = plugins
call dein#begin(configdir.'/plugins/')
call dein#add(configdir.'/dein.vim/')

" - startify
call dein#add('mhinz/vim-startify')
let g:startify_list_order = ['sessions', 'files', 'bookmarks']
let g:startify_bookmarks = [ {'!': $MYVIMRC} ]
let g:startify_session_dir = configdir.'/sessions'
nnoremap <leader>ss :Startify<cr>
nnoremap <leader>sq :SDelete! temp<cr>:SSave temp<cr>:qa!<cr>

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
nmap s <Plug>MySneakLabel_s
nmap S <Plug>MySneakLabel_S
xmap s <Plug>MySneakLabel_s
xmap S <Plug>MySneakLabel_S

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
let g:ycm_python_binary_path = 'python3'
"nnoremap gr :YcmCompleter GoToReferences<cr>
"let g:ycm_key_list_select_completion = ['<tab>']
"let g:ycm_key_list_previous_completion = ['<s-tab>']
"let g:ycm_use_ultisnips_completer = 0
"let g:ycm_goto_buffer_command = 'new-tab'
" it's not possible to remap gd
"nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<cr>
"inoremap <Nul> <C-n>

" = surround
call dein#add('tpope/vim-surround')
let g:surround_no_mappings = 1
nmap ds <Plug>Dsurround
nmap cs <Plug>Csurround
xmap is <Plug>VSurround

" = python syntax
call dein#add('purpleP/python-syntax')
let python_highlight_all = 1
hi link pythonInstanceVariable Identifier
hi link pythonClassVaraible Identifier
hi link pythonBoolean Type

" = clever f
call dein#add('rhysd/clever-f.vim')


call dein#end()


" = necessary
" - dein
filetype plugin indent on
