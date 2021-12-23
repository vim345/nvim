call plug#begin()
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'fcpg/vim-osc52'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'FooSoft/vim-argwrap'
Plug 'blueyed/vim-diminactive'
Plug 'pangloss/vim-javascript'
Plug 'w0rp/ale'
Plug 'derekwyatt/vim-scala'
Plug 'psf/black', {'tag': '19.10b0'}
call plug#end()


" Use this python virtualenv for nvim
let g:python3_host_prog='~/virtual_env/py3/bin/python'


" Enable 256 color schema in vimdiff.
set t_Co=256

" Enable relative number
set number
set relativenumber


" following enables syntax highlighting by default.
if has("syntax")
  syntax on
endif


" Add automatic indent support.
filetype plugin indent on


" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd         " Show (partial) command in status line.
set showmatch       " Show matching brackets.
"set ignorecase     " Do case insensitive matching
set smartcase       " Do smart case matching
set incsearch       " Incremental search
set autowrite       " Automatically save before commands like :next and :make
set hidden          " Hide buffers when they are abandoned
set mouse=r         " Disable mouse usage (all modes)
set ruler           " Add ruler to status bar.
set tabpagemax=30   " Max number of open tabs.
"
"
" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
  set smartindent
  set tabstop=4
  set shiftwidth=4
  set expandtab
  autocmd Filetype javascript setlocal ts=2 sw=2 sts=0
  autocmd Filetype css setlocal ts=2 sw=2 sts=0
  autocmd Filetype json setlocal ts=2 sw=2 sts=0
  autocmd Filetype scss setlocal ts=2 sw=2 sts=0
  autocmd Filetype html setlocal ts=2 sw=2 sts=0
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=2 ts=2 sw=2
  autocmd FileType vue setlocal ts=2 ts=2 sw=2
endif



" Set the width to 80 for Python and 130 for go
autocmd BufRead,BufNewFile   *.py set tw=130
autocmd BufRead,BufNewFile   *.go set tw=130
autocmd BufRead,BufNewFile   *.tmpl set tw=0


" Wrap the line when it exceeds the max width.
set wrap!


" Highlight search matches.
:set hlsearch


" Make diff split vertical
set diffopt=vertical


" Make the new vertical open on the right side
set splitright


" Open/ Tab For Each Buffer
" set switchbuf=newtab


" Hide the numbers of inactive window, when splitting.
" augroup BgHighlight
"     autocmd!
"     autocmd WinEnter * set number
"     autocmd WinEnter *.py set colorcolumn=131
"     autocmd WinLeave *.py set colorcolumn=0
" augroup END
" doautocmd BgHighlight WinEnter -


" Highlighs trailing whitespace.
highlight default link TrailingWhitespace Error
augroup filetypedetect
  autocmd WinEnter,BufNewFile,BufRead * match TrailingWhitespace /\s\+$/
augroup END
autocmd InsertEnter * match none
autocmd InsertLeave * match TrailingWhitespace /\s\+$/


" Status line configuration.
set laststatus=2 " Enables the status line at the bottom of Vim

set statusline=%#Question#
set statusline+=%{fugitive#statusline()}
set statusline+=%#StatusLine#
set statusline+=\ %f
set statusline+=%#WarningMsg#
set statusline+=\ %n
set statusline+=%#StatusLine#
set statusline+=%=    " Switch to right.
set statusline+=%#VisualNOS#
set statusline+=%y
set statusline+=\ %l   " Current line
set statusline+=/      " Separator
set statusline+=%L     " Total lines
set statusline+=\ %P   " Current percentage
set statusline+=%#VertSplit#
set statusline+=\ %c   " Current width
set statusline+=%#StatusLine#
set statusline+=\ %m   " Modified flag.
set statusline+=\ %r   " Readonly flag.
set statusline+=\ %w   " Preview flag.
set statusline+=\ %q   " QuickList flag.


" Highlight matches when jumping to next.
nnoremap <silent> n   n:call HLNext(0.2)<cr>
nnoremap <silent> N   N:call HLNext(0.3)<cr>

" Ring the match in red...
function! HLNext (blinktime)
    highlight RedOnRed ctermfg=red ctermbg=red
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    echo matchlen
    let ring_pat = (lnum > 1 ? '\%'.(lnum-1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.\|' : '')
            \ . '\%'.lnum.'l\%>'.max([col-4,1]) .'v\%<'.col.'v.'
            \ . '\|'
            \ . '\%'.lnum.'l\%>'.max([col+matchlen-1,1]) .'v\%<'.(col+matchlen+3).'v.'
            \ . '\|'
            \ . '\%'.(lnum+1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.'
    let ring = matchadd('RedOnRed', ring_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction


" Enable omnifunc to activate auto complete for supported languages.
set omnifunc=syntaxcomplete#Complete


" Vim's popup menu doesn't select the first completion item. Also don't show
" the top bar.
set completeopt=longest,menuone


" When you type the first tab hit will complete as much as possible, the
" second tab hit will provide a list, the third and subsequent tabs will cycle
" through completion options so you can complete the file without further keys
set wildmode=longest,list,full
set wildmenu


" Enable realtime auto complete.
" let g:neocomplete#enable_at_startup = 1


" Enable goimports to automatically insert import paths instead of gofmt.
let g:go_fmt_command = "goimports"


" Enable syntax-highlighting for Functions, Methods and Structs.
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1


" Show the type info (|:GoInfo|) for the word under the cursor automatically.
let g:go_auto_type_info = 1


let g:go_auto_sameids = 1


" Highlights operators such as `:=` , `==`, `-=`, etc ...By default it's
" disabled.
let g:go_highlight_operators = 1


" Format the Go Tagbar.
" let g:tagbar_type_go = {
"     \ 'ctagstype' : 'go',
"     \ 'kinds'     : [
"         \ 'p:package',
"         \ 'i:imports:1',
"         \ 'c:constants',
"         \ 'v:variables',
"         \ 't:types',
"         \ 'n:interfaces',
"         \ 'w:fields',
"         \ 'e:embedded',
"         \ 'm:methods',
"         \ 'r:constructor',
"         \ 'f:functions'
"     \ ],
"     \ 'sro' : '.',
"     \ 'kind2scope' : {
"         \ 't' : 'ctype',
"         \ 'n' : 'ntype'
"     \ },
"     \ 'scope2kind' : {
"         \ 'ctype' : 't',
"         \ 'ntype' : 'n'
"     \ },
"     \ 'ctagsbin'  : 'gotags',
"     \ 'ctagsargs' : '-sort -silent'
"     \ }

"" Syntastic check.
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

"let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
"let g:syntastic_python_checkers=['python -m pylint']
"let g:syntastic_always_populate_loc_list=1
"let g:syntastic_javascript_checkers = ['jshint']


" " Exclude files and directories using Vim's wildignore and CtrlP's own g:ctrlp_custom_ignore:
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set wildignore+=*/bower_components/*     " bower compoentns
set wildignore+=*/node_modules/*     " Node modules
set wildignore+=*/vendor/*     " Golang vendor files
set wildignore+=*/virtualenv_run/*     " Files in virtualenv
set wildignore+=*/docker-venv/*     " Files in docker virtualenv
set wildignore+=*/playground/*     " Files in playground.


" Enable built-in fuzzy search
" set path+=**


" press F10 to open the buffer menu
set wildcharm=<C-Z>
nnoremap <F10> :b <C-Z>
nnoremap <F5> :Buffers <cr>


" Disable powerline
" let g:powerline_loaded = 1


" Writes the content of the file automatically if you call :make.
set autowrite


" Set the tag file.
set tags=./.tags;/

"
" Let backspace do its job
set backspace=indent,eol,start


" Auto clean fugitive buffers.
autocmd BufReadPost fugitive://* set bufhidden=delete


" Format JSON.
com! FormatJSON %!jq .
com! FormatJSON4 %!python -m json.tool


" Break/Join function arguments in python argument.
nnoremap <silent> <leader>w :ArgWrap<CR>
let g:argwrap_tail_comma = 1


" Trigger configuration. Do not use <tab> if you use
 let g:UltiSnipsExpandTrigger="<c-space>"
 let g:UltiSnipsJumpForwardTrigger="<c-b>"
 let g:UltiSnipsJumpBackwardTrigger="<c-z>"

 " If you want :UltiSnipsEdit to split your window.
 let g:UltiSnipsEditSplit="vertical"


 " Color scheme.
colorscheme mohammad
if &diff
    colorscheme mohammad
endif


" Set Abbreviation
:ab #a assert False
:iabbr pdb import pdb; pdb.set_trace()
:iabbr ipdb import ipdb; ipdb.set_trace()


" Maping shortcut keys to tab switching
map <silent><C-l> :tabnext<CR>
map <silent><C-h> :tabprevious<CR>


" Erasing trailing whitespace
map <leader>e :%s/\s\+$//<CR>


" Erasing empty lines
com! DeleteEmptyLines g/^$/d


" Map directory listing
map <silent><F2> :sp %:h<CR>


" Maping shortcut keys for setting mouse
nnoremap <F6> :call ToggleMouse()<CR>
function! ToggleMouse()
  if &mouse == 'a'
    set mouse=
    echo "Mouse usage disabled"
  else
    set mouse=a
    echo "Mouse usage enabled"
  endif
endfunction


" Toggle Paste Mode
:set pastetoggle=<F9>


" Clean highlights with Ctrl+n
nmap <silent> <C-N> :silent noh<CR>


"""""""""""""""""""""""""""" Go Specific mappings.

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" Show a list of interfaces which is implemented by the type under your cursor.
au FileType go nmap <Leader>s <Plug>(go-implements)

" Show type info for the word under your cursor.
au FileType go nmap <Leader>i <Plug>(go-info)

" Open the relevant Godoc for the word under the cursor.
au FileType go nmap <Leader>gd <Plug>(go-doc)

" open the definition/declaration in a new vertical, horizontal or tab.
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)

" Run, build, test, and coverage the code.
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage-toggle)

" Rename the identifier under the cursor to a new name
au FileType go nmap <Leader>e <Plug>(go-rename)

" Open the Go Tag bar.
nmap <F8> :TagbarToggle<CR>

" Jump between errors in quickfix list.
map <leader>n :cnext<CR>
map <leader>m :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" Mappings for diff
map <leader>d :windo diffthis<CR>
map <leader>o :windo diffoff<CR>


"""""""""""""""""""""""""""" End of Go Specific mappings.


" Switch between files and tests.
let pattern = '\(\(_\(unit\)\?test\)\?\.\(cc\|go\|js\|py\)\|\(-inl\)\?\.h\)$'
nmap ,p :vsplit <C-R>=substitute(expand("%"), pattern, "." . expand("%:e"), "")<CR><CR>
nmap ,tp :tabedit <C-R>=substitute(expand("%"), pattern, "." . expand("%:e"), "")<CR><CR>
nmap ,t :vsplit <C-R>=substitute(expand("%"), pattern, "_test." . expand("%:e"), "")<CR><CR>
nmap ,tt :tabedit <C-R>=substitute(expand("%"), pattern, "_test." . expand("%:e"), "")<CR><CR>

let test_pattern = '_test'
nmap ,y :vsplit <C-R>="tests/". join(split(expand("%:r"), "/")[1:], "/") . "_test." . expand("%:e")<CR><CR>
nmap ,ty :tabedit <C-R>="tests/". join(split(expand("%:r"), "/")[1:], "/") . "_test." . expand("%:e")<CR><CR>
nmap ,e :vsplit <C-R>=getcwd() . "/" . split(getcwd(), "/")[-1] . "/" . substitute(join(split(expand("%:r"), "/")[1:], "/"), test_pattern, "." . expand("%:e"), "")<CR><CR>
nmap ,te :tabedit <C-R>=getcwd() . "/" . split(getcwd(), "/")[-1] . "/" . substitute(join(split(expand("%:r"), "/")[1:], "/"), test_pattern, "." . expand("%:e"), "")<CR><CR>


" Toggle linting enabledness.
nmap <silent> <F3> :ALEToggle<CR>
nmap <silent> <leader>aj :ALENext<cr>
nmap <silent> <leader>ak :ALEPrevious<cr>


" Black related mappings.
autocmd FileType py nnoremap <F4> :Black<CR>


" Convert camelCase to under_score
" command CamelCaseTo :s#\(\<\u\l\+\|\l\+\)\(\u\)#\l\1_\l\2#g
" Convert each name_like_this to NameLikeThis in current line.
" command ToCamelCase :s#\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)#\u\1\2#g

" disable statusline overwriting
let g:fzf_nvim_statusline = 0
nmap <C-P> :Files<CR>
" Only show files that are in the same directory.
nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
" Find directory path
imap <C-x><C-p> <plug>(fzf-complete-path)


" Fix files with isort.
" autocmd FileType py let b:ale_fixers = ['black']
let b:ale_fixers = {'javascript': [ 'prettier', 'eslint'], 'python': ['black']}
let b:ale_linters = {'go': [ 'gobuild', 'gopls']}


" Enable quickfix in ALE.
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_save = 1
let g:ale_completion_enabled = 1

let g:go_fmt_fail_silently = 1
let g:go_auto_type_info = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']


xmap <F7> y:call SendViaOSC52(getreg('"'))<cr>

function! OscCopy()
  let encodedText=@"
  let encodedText=substitute(encodedText, '\', '\\\\', "g")
  let encodedText=substitute(encodedText, "'", "'\\\\''", "g")
  let executeCmd="echo -n '".encodedText."' | base64 | tr -d '\\n'"
  let encodedText=system(executeCmd)
  if $TMUX != ""
    "tmux
    let executeCmd='echo -en "\x1bPtmux;\x1b\x1b]52;;'.encodedText.'\x1b\x1b\\\\\x1b\\" > /dev/tty'
  else
    let executeCmd='echo -en "\x1b]52;;'.encodedText.'\x1b\\" > /dev/tty'
  endif
  call system(executeCmd)
  redraw!
endfunction
command! OscCopy :call OscCopy()

