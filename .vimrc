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

" probably necessary
"source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin

"set backspace=indent,eol,start " not very vi like

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
    set guifont=Consolas:h11 " Microsoft Font, may glitch under Unix (AA)
  else
    set guifont=Inconsolata\ 12
  endif
endif
" - colored line number bg
function Interpolate(p, fro, to)
    return a:fro + a:p * (a:to - a:fro)
endfunction
function ColoredLineNumbers()
    let endLNr = line('$')
    if endLNr == 1
	let endLNr = 2
    endif
    let p = (line('.') - 1) * 1.0 / (endLNr - 1)

    let colors = [[255, 0, 0],
		\ [0, 255, 0],
		\ [0, 0, 255]]
    let step = 1.0 / (len(colors) - 1)
    let index = 0
    let p2 = p
    while step < p2
	let p2 -= step
	let index += 1
    endwhile
    let p2 = p2 * 2

    let color_from = colors[index]
    let color_to = colors[index + 1]
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
endfunction

aug _colorLineNr
    au!
    au CursorMoved * call ColoredLineNumbers()
aug END


" = key mappings
let mapleader="ö"
" - buffers
noremap <c-q> :q<cr>
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
" - tabs
noremap <c-t> :tabnew<cr>
nnoremap <c-f4> :tabclose<cr>
noremap <c-tab> :tabnext<cr>
nnoremap <c-s-tab> :tabprevious<cr>
" - navigation
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
nnoremap R :%s//
nnoremap // :nohlsearch<cr>
nnoremap # *
vnoremap # *
nnoremap + #
vnoremap + #
nnoremap <F3> *
vnoremap <C-F3> #
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
"nnoremap <c-s-v> $"+p`[
" insert clipboard, move to the end, stay in insert mode
inoremap <c-v> <esc>"+gpi
" replace selection, move to the end
vnoremap <c-v> d"+gP
" - in/dedent
vnoremap < <gv
vnoremap > >gv

" = indent
set softtabstop=4
set shiftwidth=4
set autoindent
" = folds
set foldmethod=indent
set foldlevelstart=1
set foldnestmax=2

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





" = airline
NeoBundle 'bling/vim-airline'
set laststatus=2
set noshowmode
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts=1
let g:airline_theme="powerlineish"

" = ctrlp
NeoBundle 'kien/ctrlp.vim'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
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
let g:pymode_lint_on_write = 0
let g:pymode_rope_completion = 0
let g:pymode_run_key = ''
let g:pymode_folding = 0
"let g:pymode_rope_rename_bind = '<leader>r'
"let g:pymode_rope_rename_module_bind = '<leader>R'
"let g:pymode_rope_extract_method_bind = '<leader>t'
"let g:pymode_rope_extract_variable_bind = '<leader>T'
"let g:pymode_rope_use_function_bind = '<leader>z'
"let g:pymode_rope_change_signature_bind = '<leader>Z'
"au FileType python nnoremap <c-u> :PymodeRopeUndo
"au FileType python nnoremap <c-u> :PymodeRopeRedo
"au FileType python nnoremap <c-j> :call pymode#motion#move('^\(class\|def\)\s', '')<cr>
"au FileType python nnoremap <c-j> :call pymode#motion#move('^\(class\|def\)\s', '')<cr>
"au FileType python nmap <c-k> [[
"au FileType python vmap <c-j> ]]
"au FileType python vmap <c-k> [[

" = startify
NeoBundle 'mhinz/vim-startify'
let g:startify_session_dir = '~/.vim/sessions'
let g:startify_custom_indices = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, '!', '"', '§', '%', '&', '/', '(', ')', '=']
let g:startify_session_persistence = 1
let g:startify_bookmarks = [ '~/.vimrc' ]
noremap <leader>s :Startify<cr>

" = NERDcommenter
NeoBundle 'scrooloose/nerdcommenter'

" = sneak
NeoBundle 'justinmk/vim-sneak'
let g:sneak#use_ic_scs = 1 " smartcase
let g:sneak#streak = 1

"" = utisnips
"NeoBundle 'UltiSnips'

"" = syntastic
"NeoBundle 'scrooloose/syntastic'

"" = Conque-Shell
"NeoBundle 'vim-scripts/Conque-Shell'

"" = pyclewn
"NeoBundle 'xieyu/pyclewn'

" jedi
NeoBundle 'davidhalter/jedi-vim'
let g:jedi#auto_initialization = 0
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
au FileType python nnoremap <leader>rr :call jedi#rename()<cr>
au FileType python nnoremap <leader>hu :call jedi#usages()<cr>


" = neobundle
NeoBundleCheck
