set nocompatible " be IMproved
if has('vim_starting')
    set runtimepath+=~/.vim
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
set nowrap

" probably necessary
"source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin

"set backspace=indent,eol,start " not very vi like
set backspace=indent,start

" - gui
set guioptions-=T " remove toolbar
set guioptions-=m " remove menu
set guioptions-=r " remove right scrollbar
set guioptions-=R
set guioptions-=l " remove left scrollbar
set guioptions-=L
set guioptions-=b " remove bottom scrollbar


if has("gui_running") && has("gui_win32") " in gvim, on windows
    aug _maximize
	au!
	au GUIEnter * simalt ~x " start maximized
    aug END
endif


" = visual
" - colors
colorscheme wombat
set background=dark
" - font
if has("gui_running")
  if has("gui_win32")
    set guifont=Consolas:h11 " Microsoft Font, may glitch under Unix (AA)
  else
    set guifont=Inconsolata\ 13
  endif
endif
" - colored line number
func! Interpolate(p, fro, to)
    return a:fro + a:p * (a:to - a:fro)
endf
func! ColoredLineNumbers()
    let endLNr = max([2, line('$')]) " avoid div by zero
    let p = (line('.') - 1.0) / (endLNr - 1)

    let colors = [[255, 0, 0],
		\ [0, 255, 0],
		\ [0, 0, 255]]
    let end = len(colors) - 1

    let i = float2nr(p * end)
    if i == end
      let i -= 1
    endif

    let p2 = p * end - i

    let color_from = colors[i]
    let color_to = colors[i + 1]
    let r = float2nr( Interpolate(p2, color_from[0], color_to[0]) )
    let g = float2nr( Interpolate(p2, color_from[1], color_to[1]) )
    let b = float2nr( Interpolate(p2, color_from[2], color_to[2]) )
    let bg_c = printf('%02x%02x%02x', r, g, b)

    if p <= 0.1 || 0.9 <= p
	let fg_c = 'white'
    else
	let fg_c = 'black'
    endif

    exe('hi CursorLineNr guibg=#'.bg_c.' guifg='.fg_c)
endf

aug _colorLineNr
    au!
    au CursorMoved * call ColoredLineNumbers()
aug END


" = key mappings
let mapleader=";"
" - buffers
noremap <c-q> :q<cr> " see vv
nnoremap <a-j> <c-e>
nnoremap <a-k> <c-y>
nnoremap <a-h> zh
nnoremap <a-l> zl
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <up> <c-w>-
nnoremap <down> <c-w>+
nnoremap <left> <c-w><
nnoremap <right> <c-w>>
" copy absolute path to clipboard
nnoremap <silent> <leader>yp :let @+ = expand('%:p')<cr>
" open from clipboard
nnoremap <silent> <leader>pp :e <c-R>+<cr>
" - tabs
noremap <c-t> :tabnew<cr>
nnoremap <c-f4> :tabclose<cr>
noremap <c-tab> :tabnext<cr>
nnoremap <c-s-tab> :tabprevious<cr>
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <c-y> :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <c-y> :exe "tabn ".g:lasttab<cr>
" - navigation
noremap # ^
nnoremap <space> <c-d>
vnoremap <space> <c-d>
nnoremap <s-space> <c-u>
vnoremap <s-space> <c-u>
nnoremap <c-i> <c-o>
nnoremap <c-o> <c-i>
" - shortcuts
" . esc
inoremap fd <esc>
inoremap <esc> <nop>
vnoremap fd <esc>
vnoremap <esc> <nop>
" . enter
inoremap jk <cr>
" . save
nnoremap <a-s> :update<cr>
inoremap <a-s> <esc>:update<cr>a
vnoremap <a-s> <esc>:update<cr>gv
" - regex
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v
nnoremap R :%s///g<left><left>
vnoremap R :s///g<left><left>
nnoremap // :nohlsearch<cr>
noremap - #
noremap = *
vnoremap - ""y?\V<c-r>=escape(@", '\')<cr><cr>gn
vnoremap = ""y/\V<c-r>=escape(@", '\')<cr><cr>gn

" - insert mode
inoremap <a-h> <left>
inoremap <a-j> <down>
inoremap <a-k> <up>
inoremap <a-l> <right>
inoremap <c-h> <bs>
inoremap <c-l> <del>
" - visual mode
nnoremap vv <c-v>
" - run
"map <leader>rp :exe ":ConqueTermVSplit C:\\Python27\\python.exe -i " . expand("%")
" - copy paste
" insert before cursor, cursor moves to the end
nnoremap p gP
" insert at the end of line, cursor moves to the entry point of the insertion
nnoremap P $p`[
" copy to clipboard, stay in visual mode
vnoremap <c-c> "+ygv
" move to clipboard
vnoremap <c-x> "+ygvd
" insert clipboard and move to the end
nnoremap <c-v> "+gP
" insert clipboard at the end of line, cursor moves to the entry point of the insertion
"nnoremap <c-s-v> $"+p`[ " doesnt work because c-s-v is equal to c-v
" insert clipboard, move to the end, stay in insert mode
inoremap <c-v> <esc>"+gpi
" replace selection, move to the end
vnoremap <c-v> d"+gP

" = indent
set softtabstop=4
set shiftwidth=4
set autoindent
inoremap <s-tab> <c-v><tab>
" = folds
set foldmethod=indent
set foldlevelstart=1
set foldnestmax=2
nnoremap zM :set foldlevel=1<cr>

" = search
set hlsearch
hi Search guibg=Orange2
set ignorecase
set smartcase
set incsearch

" = line numbers
set number
set relativenumber

" = add filetypes
au BufNewFile,BufRead *.i set filetype=swig 
au BufNewFile,BufRead *.swg set filetype=swig 




" == diff func ==
set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction





" = startify
NeoBundle 'mhinz/vim-startify'
let g:startify_session_dir = '~/.vim/sessions'
let g:startify_list_order = ['files', 'bookmarks', 'sessions']
let g:startify_custom_indices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, '!', '@', '#', '$', '%', '^', '&', '*', '(', ')'] " loops on linux
let g:startify_bookmarks = [ '~/.vimrc' ]
noremap <leader>ss :Startify<cr>

" = airline
NeoBundle 'bling/vim-airline'
set laststatus=2
set noshowmode
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline_theme="powerlineish"
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" = ctrlp
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'tacahiroy/ctrlp-funky'
let g:ctrlp_extensions = ['funky']
let g:ctrlp_working_path_mode = 'c'
let g:ctrlp_cmd = 'CtrlPMixed'

" = ycm
NeoBundle 'Valloric/YouCompleteMe'
nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<cr>

" = python-mode
NeoBundle 'klen/python-mode'
let g:pymode_lint_on_write = 0
let g:pymode_rope_completion = 0
let g:pymode_run_key = ''
let g:pymode_folding = 0
let g:pymode_motion = 0
let g:pymode_rope_rename_bind = '<leader>rr'
let g:pymode_rope_use_function_bind = '<leader>hu'

" = NERDcommenter
NeoBundle 'scrooloose/nerdcommenter'

" = sneak
NeoBundle 'justinmk/vim-sneak'
let g:sneak#use_ic_scs = 1 " smartcase
let g:sneak#s_next = 1
let g:sneak#s2ws = 2
let g:sneak#dot2any = 1
nmap s <Plug>(MyStreak)
xmap s <Plug>(MyStreak)
omap s <Plug>(MyStreak)
nmap S <Plug>(SneakStreak)

" = clever f
NeoBundle 'rhysd/clever-f.vim'
let g:clever_f_chars_match_any_signs = ';'

" = rainbow paranthesis
NeoBundle 'kien/rainbow_parentheses.vim'
nnoremap <leader>tr :RainbowParenthesesToggle<cr>

" = surround
NeoBundle 'tpope/vim-surround'

" = mark
NeoBundle 'dusans/Mark--Karkat'
nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext 
nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
let g:mwDirectGroupJumpMappingNum = 0

" = neobundle
NeoBundleCheck


