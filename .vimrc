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

" - enable ALT key combinations in terminal
let c = 'abcdefghijklmnopqrstuvwxyz1234567890-=[]\o'',./'
for cc in split(c, '\zs')
  exec "set <A-".cc.">=\e".cc
  exec "imap \e".cc." <A-".cc.">"
endfor

set timeout ttimeoutlen=50


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
set background=dark
set t_Co=256
colorscheme wombat256mod
if &term =~ '256color' " fix bg color in tmux
  set t_ut=
endif
" - font
if has('gui_running')
  if has('gui_win32')
    set guifont=Consolas:h11
  else
    set guifont=Consolas\ 12
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


" = indent
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
"inoremap <s-tab> <c-v><tab> " TODO not working

" = folds
set foldmethod=indent
set foldlevelstart=1
set foldnestmax=2
nnoremap zM :set foldlevel=1<cr>

" = search
set hlsearch
"hi Search guibg=Orange2
set ignorecase
set smartcase
set incsearch

" = line numbers
set number
set relativenumber


" = key mappings
let mapleader = ';'
let maplocalleader = ';'
" - switch black/white
nnoremap <leader>td :colorscheme wombat256mod<cr>
nnoremap <leader>tl :colorscheme sienna<cr>
" - nop
nnoremap Q <nop>
" - buffers
nnoremap <c-q> :q<cr>
nnoremap <c-h> <c-w>h
nnoremap <c-n> <c-w>j
nnoremap <c-e> <c-w>k
nnoremap <c-k> <c-w>l
nnoremap <up> 5<c-w>-
nnoremap <down> 5<c-w>+
nnoremap <left> 10<c-w><
nnoremap <right> 10<c-w>>
nnoremap <a-up> <c-w>-
nnoremap <a-down> <c-w>+
nnoremap <a-left> <c-w><
nnoremap <a-right> <c-w>>
" copy buffer path to clipboard
nnoremap <leader>yy :let @+ = expand('%:p')<cr>
" open path from clipboard
nnoremap <leader>pp :e <c-R>=escape(@+, ' ')<cr><cr>
" - tabs
nnoremap <c-t> :tabnew<cr>
nnoremap <c-f4> :tabclose<cr>
nnoremap <c-tab> :tabnext<cr>
nnoremap <c-s-tab> :tabprevious<cr>
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <a-j> :tabn <c-r>=g:lasttab<cr><cr>
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
nnoremap <a-a> ^
nnoremap <a-t> $
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
xnoremap <c-s> :<c-u>update<cr>gv
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
inoremap <a-a> <c-O>^
inoremap <a-t> <c-O>$
inoremap <c-h> <bs>
inoremap <c-i> <del>
inoremap <c-n> <esc>m`O<esc>``a
inoremap <c-e> <esc>m`kdd``a
inoremap <c-p> <c-R>"
fun! StripLeft(x)
  return substitute(a:x, '\v(^\s+)', '', 'g')
endfun
fun! FindSimilar(iWhite)
  let pos = getpos('.') | let cline = getline(pos[1])
  let pattern = '\V\^'
  if a:iWhite
    let cline = StripLeft(cline)
    let pattern .= '\s\*'.escape(cline, '\')
  else
    let pattern .= escape(cline, '\')
  endif
  normal 0
  let [l, c] = searchpos(pattern, 'bnw')
  call setpos('.', pos)
  if l == 0 | return '' | endif
  let r = getline(l)
  if a:iWhite | let r = StripLeft(r) | endif
  return strpart(r, strlen(cline))
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
cnoremap <c-p> <c-R>"
" - copy paste
nnoremap <cr> "+yyj
nnoremap <s-cr> m`0"+y$``
xnoremap <cr> <esc>2gn"+ygv
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


fun! MergeSubPatterns(patterns) " assumes \v
  let r = copy(a:patterns)
  call map(r, 'substitute(v:val, ''\v(^\()|[^\\]@<=\('', ''%('', ''g'')') " all ( to %(
  return '('.join(r, ')|(').')'
endfun

let s:defaultBalances = ["'", '"']
let s:defaultPercents = ['\(|\[|\{', '\)|\]|\}']
let s:defaultStop = '(\zs(^|[^=])\=\ze($|[^=]))|[,:;#]|\/\/|\/\*|\*\/|^\s*((el)?if|for|while|return|def|class|import|from)\s|\s(in|import|as)\s'
fun! JumpOverDefaults(back, visual, balances, percents, stop, breakLine)
  return JumpOver(a:back, a:visual,
                \ (a:percents ? s:defaultPercents : []),
                \ (a:balances ? s:defaultBalances : []),
                \ (a:stop ? s:defaultStop : ''),
                \ a:breakLine)
endfun

fun! JumpOver(back, visual, percents, balances, stop, breakLine) " assumes \v
  if a:visual | norm! gv
  endif
  norm! m'
  let noPattern = '\_.@!' " const
  let [a, b] = (len(a:percents) == 0 ? [noPattern, noPattern] : a:percents) " validate percents
  " 0: percents, 1: stop, 2-(n-2): balances, n-1: line break
  let patterns = [(a:back ? b : a),
                \ join([(a:back ? a : b)] + (strlen(a:stop) == 0 ? [] : [a:stop]), '|')]
  call extend(patterns, a:balances)
  if a:breakLine | call add(patterns, (a:back ? '^' : '$')) | endif
  let pattern = '\v'.MergeSubPatterns(patterns)
  let pLineBreak = (a:breakLine ? len(patterns) - 1 : -1)
  let baseFlags = (a:back ? 'b' : '').'pW'
  let flags = baseFlags.'c'
  while 1
    if a:breakLine && col('.') == (a:back ? 1 : col('$') - 1) " some workaround
      let p = pLineBreak " same as natural line break
      break
    endif
    let [l, c, p] = searchpos(pattern, flags)
    if l == 0 | return [0, 0] | endif " unusual but possible
    let p -= 2
    let flags = baseFlags
    if p == 0 " percent
      norm! %
      if line('.') == l && col('.') == c | break | endif " no closing
    elseif p == 1 || p == pLineBreak " stop or line break
      break
    else " balance
      let [l, c, p] = searchpos('\v'.patterns[p], flags)
      if l == 0 | break | endif " no closing
    endif
  endwhile
  let r = [line('.'), col('.')]
  if a:back
    if p != pLineBreak | call search(pattern, 'ceW') | endif " jump over closing
    call search('\v\S', (p == pLineBreak ? 'c' : '').'W')
  else
    call search('\v\S', (p == pLineBreak ? 'c' : '').'bW')
  endif
  return r
endfun

nnoremap <leader>ee :call JumpOverDefaults(0, 0, 1, 1, 1, 1)<cr>
inoremap <leader>ee <esc>`^:call JumpOverDefaults(0, 0, 1, 1, 1, 1)<cr>a
xnoremap <leader>ee :<c-u>call JumpOverDefaults(0, 1, 1, 1, 1, 1)<cr>
nnoremap <leader>bb :call JumpOverDefaults(1, 0, 1, 1, 1, 1)<cr>
inoremap <leader>bb <esc>:call JumpOverDefaults(1, 0, 1, 1, 1, 1)<cr>i
xnoremap <leader>bb :<c-u>call JumpOverDefaults(1, 1, 1, 1, 1, 1)<cr>
xnoremap iB <esc>:call JumpOverDefaults(1, 0, 1, 1, 1, 1)<cr>v:<c-u>call JumpOverDefaults(0, 1, 1, 1, 1, 1)<cr>
onoremap iB :normal viB<cr>


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
let g:ycm_goto_buffer_command = 'new-tab'
" it's not possible to remap gd
nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<cr>
inoremap <Nul> <C-n>

" = python-mode
NeoBundle 'klen/python-mode'
let g:pymode_folding = 0
let g:pymode_motion = 0 " got my own
let g:pymode_run = 0
let g:pymode_breakpoint = 0
let g:pymode_lint = 0
let g:pymode_rope = 0
"let g:pymode_rope_rename_bind = '<leader>rr'
"let g:pymode_rope_use_function_bind = '<leader>hu'

" = vim-debug
NeoBundle 'pyclewn'
NeoBundle 'notEvil/vim-debug'
fun! PythonFile()
  nnoremap <leader>dr :call debug#dummy()<cr>:DebugStart "<c-r>=expand('%:p')<cr>"<cr>
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
  nnoremap <leader>d<space> :DebugBp at :<c-r>=line('.')<cr><cr>
  xnoremap <leader>d<space> :DebugBp range :<c-r>=line("'<")<cr> :<c-r>=line("'>")<cr><cr>
  nnoremap <leader>dc :DebugBp at :<c-r>=line('.')<cr> 
  xnoremap <leader>dc :DebugBp range :<c-r>=line("'<")<cr> :<c-r>=line("'>")<cr> 
  nnoremap <leader>dt :DebugBp temp at :<c-r>=line('.')<cr><cr>
  nnoremap <leader>dd :DebugBp temp at :<c-r>=line('.')<cr><cr>:Ccontinue<cr>:call debug#clearTemps()<cr>
  nnoremap <leader>de :call debug#toggleEnabled(debug#here())<cr>
  xnoremap <leader>de :DebugBp range :<c-r>=line("'<")<cr> :<c-r>=line("'>")<cr> enable<cr>
  xnoremap <leader>dd :DebugBp range :<c-r>=line("'<")<cr> :<c-r>=line("'>")<cr> disable<cr>
  " prints
  nnoremap <leader>dp :Cpp <c-r>=expand('<cword>')<cr><cr>
  nnoremap <cr> <cr>:C <c-r>=getline(line('.')-1)<cr><cr>
  xnoremap <cr> ""y:Cpp <c-r>=escape(@", '"')<cr><cr>
  "inoremap <cr> <c-o>on<c-o>:Cpp <c-r>=getline(line('.')-1)<cr><cr><bs>
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
let g:sneak#myopt = {
\   'labels': {
\     'main': 'tnseriao',
\     'above': 'plfuwyq;gj',
\     'below': 'dhvkcmx,z.',
\     'extra': '234567890'
\   }
\ }
nmap s <Plug>(MyStreak)
nmap S <Plug>(MyStreakBackward)
xmap s <Plug>(MyStreak)
xmap S <Plug>(MyStreakBackward)
omap s <Plug>(MyStreak)
omap S <Plug>(MyStreakBackward)

" = clever f
NeoBundle 'notEvil/clever-f.vim'
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

"" = auto pairs
"NeoBundle 'jiangmiao/auto-pairs'
"let g:AutoPairsShortcutToggle = ''
"let g:AutoPairsShortcutFastWrap = '<leader>af'
"let g:AutoPairsShortcutJump = ''
"let g:AutoPairsCenterLine = 0
"let g:AutoPairsFlyMode = 0
"let g:AutoPairsShortcutBackInsert = '<leader>ab'
fun! FindClosing(forward)
  let win = winsaveview()
  let [l, c] = JumpOver(!a:forward, 0, s:defaultPercents, s:defaultBalances, '', 0)
  let r = strpart(getline(l), c - 1, 1)
  call winrestview(win)
  return get((a:forward ? {')': '(', ']': '[', '}': '{'} : {'(': ')', '[': ']', '{': '}'}), r, '')
endfun
inoremap <a-[> (
inoremap <a-]> <c-r>=FindClosing(0)<cr>

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
let g:vimrplugin_source_args = 'max.deparse.length = 300, echo = TRUE'
let g:vimrplugin_rmhidden = 1
fun! RRunTill()
  let w = winsaveview()
  exec "normal \<Plug>RClearAll"
  norm! Vgg
  exec "normal \<Plug>RDSendSelection"
  call winrestview(w)
endfun
fun! RFile()
  nmap <leader>rr <Plug>RStart
  nmap <leader>rq <Plug>RClose
  nmap <cr> <Plug>RDSendLine
  xmap <cr> <Plug>RDSendSelection
  imap <s-cr> <Plug>RSendLine
  nmap <leader>rh <Plug>RHelp
  nmap <leader>rs <Plug>RObjectStr
  nmap <leader>rc <Plug>RClearAll
  nmap <leader>r<cr> :call RRunTill()<cr>
  inoremap $ $<c-x><c-o><c-p>
  inoremap :: ::<c-x><c-o><c-p>
endfun
au FileType r call RFile()

"" = vdebug
"NeoBundle 'joonty/vdebug.git'
"let g:vdebug_keymap = {
"\ 'run': '<leader>dr',
"\ 'run_to_cursor': '<leader>dd',
"\ 'step_over': '<F6>',
"\ 'step_into': '<F5>',
"\ 'step_out': '<F7>',
"\ 'close': '<leader>dq',
"\ 'set_breakpoint': '<leader>d<space>',
"\ 'get_context': '<F1>',
"\ 'eval_under_cursor': '<leader>dp',
"\ 'eval_visual': '<leader>dp'
"\ }


" ycm & UltiSnips compatibility
fun! g:UltiSnips_Complete()
  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res != 0 | return '' | endif
  if pumvisible() | return "\<c-n>" " \" != ' ;)
  endif
  call UltiSnips#JumpForwards()
  if g:ulti_jump_forwards_res != 0 | return '' | endif
  return "\<tab>"
endfun

" either ycm or ultisnips remap <tab> somewhere => au
" TODO doesn't seem to work when opening file from cmd line
au BufNewFile,BufRead * inoremap <silent> <tab> <c-R>=g:UltiSnips_Complete()<cr>
" TODO esc may not always exit insert mode, but I still don't know why
au BufNewFile,BufRead * inoremap <silent> <esc> <esc>`^


call neobundle#end()


" finish
filetype plugin indent on " required!

NeoBundleCheck

