set nocompatible " be IMproved

if has('vim_starting')
    set runtimepath+=~/.vim/ " use .vim on windows
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif


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
nnoremap <c-q> :q<cr>
"nnoremap <a-j> <c-e> " lost
"nnoremap <a-k> <c-y>
"nnoremap <a-h> zh
"nnoremap <a-l> zl
nnoremap <c-h> <c-w>h
nnoremap <c-n> <c-w>j
nnoremap <c-e> <c-w>k
nnoremap <c-i> <c-w>l
nnoremap <up> <c-w>-
nnoremap <down> <c-w>+
nnoremap <left> <c-w><
nnoremap <right> <c-w>>
" copy buffer path to clipboard
nnoremap <leader>yy :let @+ = expand('%:p')<cr>
" open path from clipboard
nnoremap <leader>pp :e <c-R>+<cr>
" - tabs
nnoremap <c-t> :tabnew<cr>
nnoremap <c-f4> :tabclose<cr>
nnoremap <c-tab> :tabnext<cr>
nnoremap <c-s-tab> :tabprevious<cr>
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <c-j> :exe "tabn ".g:lasttab<cr>
xnoremap <silent> <c-j> :exe "tabn ".g:lasttab<cr>
nnoremap <c-F1> 1gt
nnoremap <c-F2> 2gt
nnoremap <c-F3> 3gt
nnoremap <c-F4> 4gt
nnoremap <c-F5> 5gt
nnoremap <c-F6> 6gt
nnoremap <c-F7> 7gt
nnoremap <c-F8> 8gt
nnoremap <c-F9> 9gt
nnoremap <c-F10> 10gt
nnoremap <c-F11> :tabmove -1<cr>
nnoremap <c-F12> :tabmove +1<cr>
" - navigation
nnoremap <a-h> h
nnoremap <a-n> j
nnoremap <a-e> k
nnoremap <a-i> l
xnoremap <a-h> h
xnoremap <a-n> j
xnoremap <a-e> k
xnoremap <a-i> l
nnoremap # ^
nnoremap <space> <c-d>
xnoremap <space> <c-d>
nnoremap <s-space> <c-u>
xnoremap <s-space> <c-u>
nnoremap <c-i> <c-o>
nnoremap <c-o> <c-i>
" - shortcuts
" . save
nnoremap <c-s> :update<cr>
" - regex
nnoremap / /\v
xnoremap / /\v
nnoremap ? ?\v
xnoremap ? ?\v
nnoremap R :%s///g<left><left>
xnoremap R :s///g<left><left>
nnoremap // :nohlsearch<cr>
noremap - #
noremap = *
xnoremap - ""y?\V<c-r>=escape(@", '\')<cr><cr>gn
xnoremap = ""y/\V<c-r>=escape(@", '\')<cr><cr>gn
" - insert mode
inoremap <silent> <esc> <esc>`^
inoremap <a-h> <left>
inoremap <a-n> <down>
inoremap <a-e> <up>
inoremap <a-i> <right>
"inoremap <a-i> <c-o>I " obsolete
"inoremap <a-a> <c-o>A
inoremap <c-h> <bs> " TODO: collides with ycm
inoremap <c-i> <del>
inoremap <c-n> <esc>m`O<esc>``a
" - insert new lines
nnoremap <c-n> m`O<esc>``
nnoremap <c-e> m`kdd``
inoremap <c-e> <esc>m`kdd``a
inoremap <c-p> <c-R>"
" - visual mode
nnoremap vv <c-v>
"vnoremap <a-h> oho " lost
"vnoremap <a-j> ojo
"vnoremap <a-k> oko
"vnoremap <a-l> olo
"vnoremap <c-j> <esc>`<O<esc>`>jddgv " TODO: move to func
"vnoremap <c-k> <esc>`<kdd`>o<esc>gv
"vnoremap <c-j> ygvjojpkC<esc>gv " alternative
"vnoremap <c-k> ygvkokgPC<esc>gv
" - copy paste
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

" = indent
set softtabstop=4
set shiftwidth=4
set autoindent
inoremap <s-tab> <c-v><tab> " TODO: not working
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

" = open large file
let g:LargeFileLimit = 1024 * 1024 * 50 " 50 MB

" Protect large files from sourcing and other overhead. Set read only
if !exists("my_auto_commands_loaded")
    let my_auto_commands_loaded = 1
    " noswapfile (save copy of file)
    " bufhidden=unload (save memory when other file is viewed)
    " buftype=nowritefile (is read-only)
    " undolevels=-1 (no undo possible)
    augroup LargeFile
        " dont need eventignore+=FileType cuz we set syntax sync minlines, maxlines
        autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFileLimit | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | endif
    augroup END
endif

" how many lines before/max current line to start syntax highlighting parsing
autocmd Syntax * syn sync clear | syntax sync minlines=512 | syntax sync maxlines=512


" initialize neobundle
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'


" = startify
NeoBundle 'mhinz/vim-startify'
let g:startify_session_dir = '~/.vim/sessions'
let g:startify_list_order = ['files', 'bookmarks', 'sessions']
let g:startify_custom_indices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, '!', '@', '#', '$', '%', '^', '&', '*', '(', ')'] " loops on linux
let g:startify_bookmarks = [ '~/.vimrc' ]
nnoremap <leader>ss :Startify<cr>

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
let g:ctrlp_max_depth = 1 " speed up
let g:ctrlp_cmd = 'CtrlPMixed'

" = ycm
NeoBundle 'Valloric/YouCompleteMe'
" it's not possible to remap gd
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
NeoBundle 'notEvil/vim-sneak'
let g:sneak#use_ic_scs = 1 " smartcase
let g:sneak#s2ws = 2
let g:sneak#dot2any = 1
nmap s <Plug>(MyStreak)
nmap S <Plug>(MyStreakBackward)
xmap s <Plug>(MyStreak)
xmap S <Plug>(MyStreakBackward)
omap s <Plug>(MyStreak)
omap S <Plug>(MyStreakBackward)

" = clever f
NeoBundle 'rhysd/clever-f.vim'
let g:clever_f_chars_match_any_signs = '.'
let g:clever_f_fix_key_direction = 1

" = surround
NeoBundle 'tpope/vim-surround'
let g:surround_no_mappings = 1
nmap ds <Plug>Dsurround
nmap cs <Plug>Csurround
xmap is <Plug>VSurround

" = mark
NeoBundle 'dusans/Mark--Karkat'
nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext 
nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
let g:mwDirectGroupJumpMappingNum = 0

" = replay
NeoBundle 'chrisbra/Replay'

" = auto pairs
NeoBundle 'jiangmiao/auto-pairs'
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutJump = ''


call neobundle#end()
NeoBundleCheck

