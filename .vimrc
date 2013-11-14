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
set nowrap
" may cause more trouble than help
"set autochdir " auto change current directory to file parent

" probably necessary
"source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin

set backspace=indent,eol,start

" - gui
set guioptions-=T " remove toolbar
set guioptions-=m " remove menu
set guioptions-=r " remove right scrollbar
set guioptions-=L " remove left scrollbar
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
    set guifont=Consolas:h11
  else
    set guifont=Inconsolata\ 12
  endif
endif
" - colored line number bg
function Interpolate(p, fro, to)
    return a:fro + a:p * (a:to - a:fro)
endfunction
function OnCursorMoved1()
    let endLNr = line('$')
    if endLNr == 1
        let endLNr = 2
    endif

    let colors = [[255, 255, 255],
                \ [235, 235, 54],
                \ [121, 219, 50],
                \ [54, 123, 235],
                \ [0, 0, 0]]
    let fg_colors = ['black', '#005f00', 'white']

    let p = (line('.') - 1) * 1.0 / (endLNr - 1)

    let fg_color_index = float2nr(p * len(fg_colors) - 0.001)
    let fg_color = fg_colors[fg_color_index]

    let color_index_from = float2nr(p * (len(colors) - 1) - 0.001)
    let color_index_to = color_index_from + 1
    let p2 = (p * (len(colors) - 1)) - color_index_from

    let color_from = colors[color_index_from]
    let color_to = colors[color_index_to]

    let r = float2nr( Interpolate(p2, color_from[0], color_to[0]) )
    let g = float2nr( Interpolate(p2, color_from[1], color_to[1]) )
    let b = float2nr( Interpolate(p2, color_from[2], color_to[2]) )

    let c = printf('%02x%02x%02x', r, g, b)
    exe('hi CursorLineNr guibg=#'.c.' guifg='.fg_color)
endfunction

aug _colorLineNr
    au!
    au CursorMoved * call OnCursorMoved1()
aug END

hi CursorLineNr guifg=#000000


" = key mappings
let mapleader="ö"
" - buffers
noremap <a-q> :q<cr>
noremap <a-Q> :wq<cr>
nnoremap <a-h> <c-w>h
nnoremap <a-j> <c-w>j
nnoremap <a-k> <c-w>k
nnoremap <a-l> <c-w>l
nnoremap <up> <c-w>-
nnoremap <down> <c-w>+
nnoremap <left> <c-w><
nnoremap <right> <c-w>>
" - tabs
noremap <c-h> :tabprevious<CR>
noremap <c-l> :tabnext<CR>
noremap <c-t> :tabnew<CR>
" - navigation
nnoremap <space> <c-d>
vnoremap <space> <c-d>
nnoremap <s-space> <c-u>
vnoremap <s-space> <c-u>
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
" - regex
nnoremap / /\v
vnoremap / /\v
nnoremap R :%s//
nnoremap // :nohlsearch<cr>
" - insert mode
inoremap <a-h> <left>
inoremap <a-j> <down>
inoremap <a-k> <up>
inoremap <a-l> <right>
inoremap <c-h> <bs>
inoremap <c-l> <del>
" - run
"map <leader>rp :exe ":ConqueTermVSplit C:\\Python27\\python.exe -i " . expand("%")
" - copy paste
noremap <c-c> "+y
noremap <c-v> "+P
inoremap <c-v> <esc>l"+Pli
nnoremap P p
nnoremap p P

" = indent
set softtabstop=4
set shiftwidth=4
set autoindent

" = search
set hlsearch
hi Search guibg=Orange2
set ignorecase
set smartcase
set incsearch

" = line numbers
set number
set relativenumber





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
nnoremap <leader>t :NERDTreeToggle<cr>

" = ycm
NeoBundle 'Valloric/YouCompleteMe'
noremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<cr>

" = python-mode
NeoBundle 'klen/python-mode'
let g:pymode_lint_write = 0
let g:pymode_run_key = '<leader>rp'
let g:pymode_folding = 0

" = startify
NeoBundle 'mhinz/vim-startify'
let g:startify_session_dir = '~/.vim/sessions'
let g:startify_custom_indices = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, '!', '"', '§', '%', '&', '/', '(', ')', '=']
let g:startify_session_persistence = 1
let g:startify_bookmarks = [ '~/.vimrc' ]
noremap <leader>s :Startify<cr>

" = utisnips
NeoBundle 'UltiSnips'

" = syntastic
NeoBundle 'scrooloose/syntastic'

" = NERDcommenter
NeoBundle 'scrooloose/nerdcommenter'

" = Conque-Shell
NeoBundle 'vim-scripts/Conque-Shell'

" = pyclewn
NeoBundle 'xieyu/pyclewn'

" = sneak
NeoBundle 'justinmk/vim-sneak'


" = neobundle
NeoBundleCheck
