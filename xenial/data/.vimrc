" Yann Esposito
" http://yannesposito.com
" @yogsototh
"
" ---------- VERY IMPORTANT -----------
" To install plugin the first time:
" > vim +PlugInstall +qall
" cd ~/.vim/bundle/vimproc.vim && make
" cabal install ghc-mod
" -------------------------------------

call plug#begin('~/.vim/plugged')

" Distraction Free Writting
Plug 'junegunn/goyo.vim'

" completion during typing
Plug 'neocomplcache'
" solarized colorscheme
Plug 'altercation/vim-colors-solarized'
" Right way to handle trailing-whitespace
Plug 'bronson/vim-trailing-whitespace'
" NERDTree
Plug 'scrooloose/nerdtree'
"Tagbar
Plug 'majutsushi/tagbar'
" Unite
"   depend on vimproc
"   you have to go to .vim/plugin/vimproc.vim and do a ./make
Plug 'Shougo/vimproc.vim'
Plug 'Shougo/unite.vim'
" writing pandoc documents
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
" GIT
Plug 'tpope/vim-fugitive'
" show which line changed using git
Plug 'airblade/vim-gitgutter'
" Align code
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/syntastic'             " syntax checker
Plug 'pbrisbin/html-template-syntax'    " Yesod templates
" --- XML
Plug 'othree/xml.vim'
" " Plug 'paredit.vim'
Plug 'tpope/vim-fireplace'
" " <<< vim-fireplace dependencie
" Plug 'tpope/vim-classpath'

"" Color
Plug 'tomasr/molokai'

" go
"" Go Lang Bundle
Plug 'fatih/vim-go'
Plug 'avelino/vim-bootstrap-updater'
Plug 'sheerun/vim-polyglot'
filetype plugin indent on
if v:version >= 704
  "" Snippets
  Plug 'SirVer/ultisnips'
  Plug 'FelikZ/ctrlp-py-matcher'
endif


" Plug 'jpalardy/vim-slime'
" -- ag
Plug 'rking/ag.vim'
" --- elm-lang
Plug 'lambdatoast/elm.vim'
" --- Idris
Plug 'idris-hackers/idris-vim'

" -- reload browser on change
" Plug 'Bogdanp/browser-connect.vim'

Plug 'maksimr/vim-jsbeautify'
Plug 'einars/js-beautify'

call plug#end()

set nocompatible

" ###################
" ### Plugin conf ###
" ###################

" Auto-checking on writing
" autocmd BufWritePost *.hs,*.lhs GhcModCheckAndLintAsync

"  neocomplcache (advanced completion)
" autocmd BufEnter *.hs,*.lhs let g:neocomplcache_enable_at_startup = 1
" function! SetToCabalBuild()
"     if glob("*.cabal") != ''
"         set makeprg=cabal\ build
"     endif
" endfunction
" autocmd BufEnter *.hs,*.lhs :call SetToCabalBuild()

" -- neco-ghc
let $PATH=$PATH.':'.expand("~/.cabal/bin")

" -- Frege
autocmd BufEnter *.fr :filetype haskell

" ----------------
"       GIT
" ----------------

" -- vim-gitgutter
highlight clear SignColumn
highlight SignColumn ctermbg=0
nmap gn <Plug>GitGutterNextHunk
nmap gN <Plug>GitGutterPrevHunk

" -----------------
"       THEME
" -----------------

" -- solarized theme
set background=dark
try
    colorscheme elflord
catch
endtry

" ----------------------------
"       File Management
" ----------------------------
let g:unite_source_history_yank_enable = 1
try
  let g:unite_source_rec_async_command='ag --nocolor --nogroup -g ""'
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
catch
endtry
" search a file in the filetree
nnoremap <space><space> :split<cr> :<C-u>Unite -start-insert file_rec/async<cr>
nnoremap <space>f :split<cr> :<C-u>Unite file<cr>
nnoremap <space>g :split<cr> :<C-u>Unite -start-insert file_rec/git<cr>
" see the yank history
nnoremap <space>y :split<cr>:<C-u>Unite history/yank<cr>
" reset not it is <C-l> normally
:nnoremap <space>r <Plug>(unite_restart)


" #####################
" ### Personal conf ###
" #####################

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set bs=2		        " allow backspacing over everything in insert mode
set viminfo='20,\"50    " read/write a .viminfo file, don't store more
			            " than 50 lines of registers
set history=10000	    " keep 100000 lines of command line history
set ruler		        " show the cursor position all the time

syntax on " syntax highlighting
set hlsearch " highlight searches


set visualbell " no beep

" move between splits
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" -- sudo save
cmap w!! w !sudo tee >/dev/null %

" Tabulation management
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set cindent
set cinoptions=(0,u0,U0

" Spellchecking
if has("spell") " if vim support spell checking
    " Download dictionaries automatically
    if !filewritable($HOME."/.vim/spell")
        call mkdir($HOME."/.vim/spell","p")
    endif
    set spellsuggest=10 " z= will show suggestions (10 at most)
    " spell checking for text, HTML, LaTeX, markdown and literate Haskell
    autocmd BufEnter *.txt,*.tex,*.html,*.md,*.ymd,*.lhs setlocal spell
    autocmd BufEnter *.txt,*.tex,*.html,*.md,*.ymd,*.lhs setlocal spelllang=fr,en
    " better error highlighting with solarized
    highlight clear SpellBad
    highlight SpellBad term=standout ctermfg=2 term=underline cterm=underline
    highlight clear SpellCap
    highlight SpellCap term=underline cterm=underline
    highlight clear SpellRare
    highlight SpellRare term=underline cterm=underline
    highlight clear SpellLocal
    highlight SpellLocal term=underline cterm=underline
endif

" Easy align interactive
vnoremap <silent> <Enter> :EasyAlign<cr>

" .ymd file type
autocmd BufEnter *.ymd set filetype=markdown
autocmd BufEnter *.cljs,*.cljs.hl set filetype=clojure
" -- Reload browser on cljs save
"  don't forget to put <script src="http://localhost:9001/ws"></script>
"  in your HTML
" au BufWritePost *.cljs :BCReloadPage


"*****************************************************************************
"" Visual Settings
"*****************************************************************************
syntax on
set ruler
set number
set paste

let no_buffers_menu=1
if !exists('g:not_finish_vimplug')
  colorscheme molokai
endif

set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10

if has("gui_running")
  if has("gui_mac") || has("gui_macvim")
    set guifont=Menlo:h12
    set transparency=7
  endif
else
  let g:CSApprox_loaded = 1

  " IndentLine
  let g:indentLine_enabled = 1
  let g:indentLine_concealcursor = 0
  let g:indentLine_char = '┆'
  let g:indentLine_faster = 1

  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
  else
    if $TERM == 'xterm'
      set term=xterm-256color
    endif
  endif
  
endif


if &term =~ '256color'
  set t_ut=
endif


"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

" vim-airline
let g:airline_theme = 'powerlineish'
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1


" ========
" Personal
" ========

" Easier anti-quote
imap éé `

" -- show the column 81
" if (exists('+colorcolumn'))
"     set colorcolumn=80
"     highlight ColorColumn ctermbg=1
" endif

" --- type ° to search the word in all files in the current dir
" nmap ° :Ag <c-r>=expand("<cword>")<cr><cr>
" nnoremap <space>/ :Ag 

" -- js beautifer
autocmd FileType javascript noremap <buffer> <c-f> :call JsBeautify()<cr>
autocmd FileType html noremap <buffer> <c-f> :call JsBeautify()<cr>
autocmd FileType css noremap <buffer> <c-f> :call JsBeautify()<cr>

" set noswapfile

" -- vim-pandoc folding
let g:pandoc#modules#disabled = ["folding"]

" -- Add Ag related config
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Enable NerdTree
map <C-n> :NERDTreeToggle<CR>
map <C-l> :TagbarToggle<CR>

