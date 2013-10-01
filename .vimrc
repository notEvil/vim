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
" == colored line number bg
function Interpolate(p, fro, to)
    return a:fro + a:p * (a:to - a:fro)
endfunction
"function OnCursorMoved1()
    "let endLNr = line('$')
    "if endLNr == 1
        "let endLNr = 2
    "endif

    "let r1 = 110
    "let g1 = 255
    "let b1 = 110
    "let r2 = 255
    "let g2 = 70
    "let b2 = 40

    "let p = (line('.') - 1) * 1.0 / (endLNr - 1)
    "if p < 0.5
	"let fg_color = 'black'
    "else
	"let fg_color = 'white'
    "endif

    "let r = float2nr( Interpolate(p, r1, r2) )
    "let g = float2nr( Interpolate(p, g1, g2) )
    "let b = float2nr( Interpolate(p, b1, b2) )
    "let c = printf('%02x%02x%02x', r, g, b)
    "exe('highlight CursorLineNr guibg=#'.c.' guifg='.fg_color)
"endfunction    

"autocmd CursorMoved * call OnCursorMoved1()
"highlight CursorLineNr guifg=#000000


"function OnCursorMoved1()
    "let endLNr = line('$')
    "if endLNr == 1
        "let endLNr = 2
    "endif

    "let r1 = 235
    "let g1 = 235
    "let b1 = 54

    "let r2 = 121
    "let g2 = 219
    "let b2 = 50

    "let r3 = 54
    "let g3 = 123
    "let b3 = 235

    "let p = (line('.') - 1) * 1.0 / (endLNr - 1)

    "if p < 0.9
        "let fg_color = 'black'
    "else
        "let fg_color = 'white'
    "endif

    "if p < 0.50
        "let p2 = p * 2
        "let r = float2nr( Interpolate(p2, r1, r2) )
        "let g = float2nr( Interpolate(p2, g1, g2) )
        "let b = float2nr( Interpolate(p2, b1, b2) )
    "else
        "let p2 = (p - 0.5) * 2
        "let r = float2nr( Interpolate(p2, r2, r3) )
        "let g = float2nr( Interpolate(p2, g2, g3) )
        "let b = float2nr( Interpolate(p2, b2, b3) )
    "endif

    "let c = printf('%02x%02x%02x', r, g, b)
    "exe('highlight CursorLineNr guibg=#'.c.' guifg='.fg_color)
"endfunction

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
    let p2 = (p * (len(colors) - 1 )) - color_index_from

    let color_from = colors[color_index_from]
    let color_to = colors[color_index_to]

    let r = float2nr( Interpolate(p2, color_from[0], color_to[0]) )
    let g = float2nr( Interpolate(p2, color_from[1], color_to[1]) )
    let b = float2nr( Interpolate(p2, color_from[2], color_to[2]) )

    let c = printf('%02x%02x%02x', r, g, b)
    exe('highlight CursorLineNr guibg=#'.c.' guifg='.fg_color)
endfunction

autocmd CursorMoved * call OnCursorMoved1()
highlight CursorLineNr guifg=#000000


" = key mappings
let mapleader="ö"
" == windows
map <a-q> :q<cr>
map <a-Q> :wq<cr>
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
" == insert mode
imap <a-h> <left>
imap <a-j> <down>
imap <a-k> <up>
imap <a-l> <right>
" == run
"map <leader>rp :exe ":ConqueTermVSplit C:\\Python27\\python.exe -i " . expand("%")


" = indent
set softtabstop=4
set shiftwidth=4
set autoindent


" = search
set ignorecase
set smartcase
set incsearch


" = line numbers
set number
set relativenumber


" = folding
"set foldmethod=manual












" = airline
NeoBundle 'bling/vim-airline'
set laststatus=2
set noshowmode
"let g:airline#extensions#tabline#enabled = 1
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
map <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<cr>

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
map <leader>s :Startify<cr>

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


" = neobundle
NeoBundleCheck
