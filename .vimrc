set nocompatible " be IMproved
filetype off " required

if has('vim_starting')
    set runtimepath+=~/.vim/ " use .vim on windows
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif


" = general
set sessionoptions+=resize,winpos " restore size/position of window
set sessionoptions-=options " do not restore temporary options
set encoding=utf-8
syntax on
set nowrap

" probably necessary
"source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin


" - gui
set guioptions-=T " remove toolbar
set guioptions-=m " remove menu
set guioptions-=r " remove right scrollbar
set guioptions-=R
set guioptions-=l " remove left scrollbar
set guioptions-=L
set guioptions-=b " remove bottom scrollbar

if has('gui_running') && has('gui_win32') " in gvim, on windows
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
if has('gui_running')
  if has('gui_win32')
    set guifont=Consolas:h11 " Microsoft Font, may glitch under Unix (AA)
  else
    set guifont=Inconsolata\ 11
  endif
endif
" - colored line number
fun! Interpolate(p, fro, to)
    return a:fro + a:p * (a:to - a:fro)
endfun
fun! ColoredLineNumbers()
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
endfun

aug _colorLineNr
    au!
    au CursorMoved * call ColoredLineNumbers()
aug END

" = key mappings
let mapleader = ';'
let maplocalleader = ';'
" = switch black/white
nnoremap <leader>td :colorscheme wombat<cr>
nnoremap <leader>tl :colorscheme sienna<cr>
" - buffers
nnoremap <c-q> :q<cr>
nnoremap <c-h> <c-w>h
nnoremap <c-n> <c-w>j
nnoremap <c-e> <c-w>k
nnoremap <c-k> <c-w>l
nnoremap <a-up> 5<c-w>-
nnoremap <a-down> 5<c-w>+
nnoremap <a-left> 10<c-w><
nnoremap <a-right> 10<c-w>>
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
nnoremap <c-j> :tabn <c-r>=g:lasttab<cr><cr>
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
inoremap <c-s> <c-o>:update<cr>
" - regex
nnoremap / /\v
xnoremap / /\v
nnoremap ? ?\v
xnoremap ? ?\v
nnoremap R :%s///g<left><left>
xnoremap R :s///g<left><left>
nnoremap // :nohlsearch<cr>
nnoremap - #
nnoremap = *
xnoremap - ""y?\V<c-r>=escape(@", '\')<cr><cr>gn
xnoremap = ""y/\V<c-r>=escape(@", '\')<cr><cr>gn
" - insert mode
"inoremap <silent> <esc> <esc>`^ " see ultisnips
inoremap <a-h> <left>
inoremap <a-n> <down>
inoremap <a-e> <up>
inoremap <a-i> <right>
inoremap <c-h> <bs>
inoremap <c-i> <del>
inoremap <c-n> <esc>m`O<esc>``a
inoremap <c-e> <esc>m`kdd``a
inoremap <c-p> <c-R>"
inoremap <a-a> <c-O>^
inoremap <a-t> <c-O>$
fun! StripLeft(x)
  return substitute(a:x, '\v(^\s+)', '', 'g')
endfun
fun! FindSimilar(iWhite)
  let cLineNo = line('.')
  let cColNo = col('.')
  let cLine = getline(cLineNo)

  if a:iWhite
    let cLine = StripLeft(cLine)
    let pattern = '\s\*'.escape(cLine, '\')
  else
    let pattern = escape(cLine, '\')
  endif
  let pattern = '\V\^'.pattern

  call cursor(cLineNo - 1, 1)
  let [l, c] = searchpos(pattern, 'bcn')
  if l == 0
    return ''
  endif
  call cursor(cLineNo, cColNo)

  let r = getline(l)
  if a:iWhite
    let r = StripLeft(r)
  endif
  return strpart(r, strlen(cLine))
endfun
inoremap <c-tab> <c-r>=FindSimilar(1)<cr>
" - visual mode
nnoremap vv <c-v>
xnoremap <c-n> <esc>`<O<esc>`>jddgv
xnoremap <c-e> <esc>`<kdd`>o<esc>gv
"vnoremap <c-j> ygvjojpkC<esc>gv " alternative
"vnoremap <c-k> ygvkokgPC<esc>gv
xnoremap . :normal .<cr>
" - command mode
cnoremap <a-h> <left>
cnoremap <a-n> <up>
cnoremap <a-e> <down>
cnoremap <a-i> <right>
cnoremap <a-a> <Home>
cnoremap <a-t> <End>
cnoremap <c-v> <c-R>+
cnoremap <c-p> <c-R>*
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
"inoremap <s-tab> <c-v><tab> " TODO not working
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
" noswapfile (save copy of file)
" bufhidden=unload (save memory when other file is viewed)
" buftype=nowritefile (is read-only)
" undolevels=-1 (no undo possible)
aug LargeFile
    au!
    " dont need eventignore+=FileType cuz we set syntax sync minlines, maxlines
    autocmd BufReadPre * let f=expand('<afile>') | if getfsize(f) > g:LargeFileLimit | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | endif
aug END

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
let g:airline_theme='powerlineish'
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
let g:ycm_key_list_select_completion = ['<tab>']
let g:ycm_key_list_previous_completion = ['<s-tab>']
let g:ycm_use_ultisnips_completer = 0
" it's not possible to remap gd
nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<cr>
inoremap <Nul> <C-n>

" = python-mode
NeoBundle 'klen/python-mode'
let g:pymode_lint_on_write = 0
let g:pymode_rope_completion = 0
let g:pymode_run = 0
let g:pymode_folding = 0
let g:pymode_motion = 0
"let g:pymode_rope_rename_bind = '<leader>rr'
"let g:pymode_rope_use_function_bind = '<leader>hu'
NeoBundle 'vim-debug'
fun! PythonFile()
  fun! Start(args)
    exe 'Pyclewn pdb '.join(a:args, ' ')
    sleep 100m
    sleep 100m
  endfun
  fun! Stop(args)
    C import sys; sys.exit(1)
  endfun
  fun! Command(command)
    exe 'C '.escape(a:command, '"')
  endfun
  fun! PutBp(bp)
    exe 'C'.(a:bp.temp ? 't' : '').'break '.a:bp.file.':'.a:bp.line.', '.a:bp.condition
  endfun
  fun! RemoveBp(bp)
    exe 'Cclear '.a:bp.file.':'.a:bp.line
  endfun
  fun! ChangeBpCondition(bp, condition)
    exe 'Ccondition '.a:bp.count.' '.a:condition
  endfun
  fun! SetBpEnabled(bp, enabled)
    exe 'C'.(a:enabled ? 'enable' : 'disable').' '.a:bp.count
  endfun
  fun! SetBpIgnore(bp, ignore)
    exe 'Cignore '.a:bp.count.' '.a:ignore
  endfun
  fun! Print(x, pretty)
    exe 'Cp'.(a:pretty ? 'p' : '').' '.a:x
  endfun
  let g:debug#opts = {
  \ 'startF': function('Start'),
  \ 'stopF': function('Stop'),
  \ 'commandF': function('Command'),
  \ 'putBpF': function('PutBp'),
  \ 'removeBpF': function('RemoveBp'),
  \ 'changeBpConditionF': function('ChangeBpCondition'),
  \ 'setBpEnabledF': function('SetBpEnabled'),
  \ 'setBpIgnoreF': function('SetBpIgnore'),
  \ 'printF': function('Print')
  \ }
  " without sleep commands might not get executed
  nnoremap <leader>dr :call debug#dummy()<cr>:DebugStart <c-r>=expand('%:p')<cr><cr>
  nnoremap <leader>dq :DebugStop<cr>
  nnoremap <leader>dl :call debug#load()<cr>
  nnoremap <leader>ds :call debug#save()<cr>
  nnoremap <c-c> :Cinterrupt<cr>
  nnoremap <F1> :call debug#printWatch()<cr>
  nnoremap <F5> :Cstep<cr>
  nnoremap <F6> :Cnext<cr>
  nnoremap <F7> :Creturn<cr>:call debug#clearTemps()<cr>
  nnoremap <F8> :Ccontinue<cr>:call debug#clearTemps()<cr>
  nnoremap <F11> :Cup<cr>
  nnoremap <F12> :Cdown<cr>
  " breakpoints
  nnoremap <leader>d<space> :call debug#toggleHere(0)<cr>
  nnoremap <leader>dc :DebugBp <c-r>=debug#getRecommends()<cr> 
  nnoremap <leader>dt :call debug#toggleHere(1)<cr>
  nnoremap <leader>dd :call debug#toggleHere(1)<cr>:Ccontinue<cr>:call debug#clearTemps()<cr>
  nnoremap <leader>de :call debug#toggleEnabled(debug#here())<cr>
  nnoremap <leader>di :DebugBpIgnore 
  " prints
  nnoremap <leader>dp :Cpp <c-r>=expand('<cword>')<cr><cr>
  xnoremap <leader>dp ""y:Cpp <c-r>=escape(@", '"')<cr><cr>
  inoremap <c-cr> <c-o>on<c-o>:Cpp <c-r>=getline(line('.')-1)<cr><cr><bs>
  nnoremap <leader>dw :DebugWatch 
endfun
au FileType python call PythonFile()

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

" = UltiSnips
NeoBundle 'SirVer/ultisnips'
let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsListSnippets = '<Nop>'

" = vim-snippets
NeoBundle 'honza/vim-snippets'

" = R
"NeoBundle 'vim-scripts/Vim-R-plugin'
NeoBundle 'jcfaria/Vim-R-plugin'
let g:vimrplugin_user_maps_only = 1
let g:vimrplugin_assign = 0
fun! RFile()
  nmap <leader>rr <Plug>RStart
  nmap <leader>rq <Plug>RClose
  nmap <c-cr> <Plug>RDSendLine
  xmap <c-cr> <Plug>RSendSelection
  imap <c-cr> <Plug>RSendLine
  nmap <leader>rh <Plug>RHelp
  nmap <leader>rs <Plug>RObjectStr
  nmap <leader>rc <Plug>RClearAll
  inoremap $ $<c-x><c-o><c-p>
  inoremap . .<c-x><c-o><c-p>
endfun
au FileType r call RFile()

" = Latex
NeoBundle 'lervag/vim-latex'
let g:tex_flavor = 'latex'

" = vdebug
NeoBundle 'joonty/vdebug.git'
let g:vdebug_keymap = {
\ 'run': '<leader>dr',
\ 'run_to_cursor': '<leader>dd',
\ 'step_over': '<F6>',
\ 'step_into': '<F5>',
\ 'step_out': '<F7>',
\ 'close': '<leader>dq',
\ 'set_breakpoint': '<leader>d<space>',
\ 'get_context': '<F1>',
\ 'eval_under_cursor': '<leader>dp',
\ 'eval_visual': '<leader>dp'
\ }


" ycm & UltiSnips compatibility
"inoremap <silent> <expr> <esc> (pumvisible() ? '\<c-e>' : '\<esc>') "annoying

fun! g:UltiSnips_Complete()
  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res != 0
    return ''
  endif
  if pumvisible()
    " \" != ' ;)
    return "\<c-n>"
  endif
  call UltiSnips#JumpForwards()
  if g:ulti_jump_forwards_res != 0
    return ''
  endif
  return "\<tab>"
endfun

" either ycm or ultisnips remap <tab> somewhere => au
" TODO doesn't seem to work when opening file from cmd line
au BufNewFile,BufRead * inoremap <silent> <tab> <c-R>=g:UltiSnips_Complete()<cr>
" TODO esc may not always exit insert mode, but I still don't know why
au BufNewFile,BufRead * inoremap <silent> <esc> <esc>`^

"let g:util_expand_or_jump_res=0
"au BufNewFile,BufRead * inoremap <silent> <expr> <esc> (g:util_expand_or_jump_res != 0 ? '<esc>ab<esc>' : '<esc>')


call neobundle#end()


" finish
filetype plugin indent on " required!

NeoBundleCheck



