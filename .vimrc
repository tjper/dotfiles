call plug#begin('~/.vim/plugged')

Plug 'christoomey/vim-tmux-navigator'
Plug 'mhinz/vim-startify'
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vimwiki/vimwiki'

Plug 'w0rp/ale'
Plug 'uber/prototool', { 'rtp':'vim/prototool' }

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'junegunn/vim-easy-align'
Plug 'neoclide/coc.nvim', { 'do': { -> coc#util#install()} }

Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'

Plug 'morhetz/gruvbox'
Plug 'plasticboy/vim-markdown'
Plug 'hashivim/vim-terraform'

Plug 'leafgarland/typescript-vim'
Plug 'sebdah/vim-delve'

call plug#end()

" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
set background=dark
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_invert_indent_guides='0'
colorscheme gruvbox


" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic Settings
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader      = ' '
let maplocalleader = ' '

augroup vimrc
  autocmd!
augroup END

set nu
set relativenumber
set autoindent
set smartindent
set lazyredraw
set laststatus=2
set showcmd
set visualbell
set backspace=indent,eol,start
set timeoutlen=500
set whichwrap=b,s
set shortmess=aITc
set hlsearch " CTRL-L / CTRL-R W
set incsearch
set hidden
set ignorecase smartcase
set wildmenu
set wildmode=full
set tabstop=2
set shiftwidth=2
set expandtab smarttab
set scrolloff=5
set encoding=utf-8
set list
set listchars=tab:\|\ ,
set virtualedit=block
set nojoinspaces
set diffopt=filler,vertical
set autoread
set clipboard=unnamed
set foldlevelstart=99
set grepformat=%f:%l:%c:%m,%f:%l:%m
set completeopt=menuone,preview
set nocursorline
set nopaste
set nrformats=hex
silent! set cryptmethod=blowfish2
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set signcolumn=yes


set modelines=2
set synmaxcol=1000

" Turn persistent undo on
try
    set undodir=~/.vim/temp_dirs/undodir
    set undofile
catch
endtry

" Annoying temporary files
set backupdir=/tmp//,.
set directory=/tmp//,.
if v:version >= 703
  set undodir=/tmp//,.
endif

" 80 chars/line
set textwidth=0
if exists('&colorcolumn')
  set colorcolumn=80
endif

" Keep the cursor on the same column
set nostartofline

" FOOBAR=~/<CTRL-><CTRL-F>
set isfname-==

if exists('&fixeol')
  set nofixeol
endif

" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic Mappings
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <C-F> <C-D>
noremap <C-B> <C-U>

" Open new line below and above current line
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

" Save
nnoremap <leader>s :update<cr>

" Quit
nnoremap <Leader>q :q<cr>
nnoremap <Leader>Q :qa!<cr>

" Make Y behave like other capitals
nnoremap Y y$

" qq to record, Q to replay
nnoremap Q @q

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" reload syntax highlighting
noremap <F10> <Esc>:syntax sync fromstart<CR>
inoremap <F10> <C-o>:syntax sync fromstart<CR>

" search and replace visual selection
vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>

" window resize shortcuts
nnoremap <silent> + :exe "resize +15"<CR>
nnoremap <silent> - :exe "resize -15"<CR>
nnoremap <silent> <c-m> :exe "vertical resize +30"<CR>
nnoremap <silent> <c-n> :exe "vertical resize -30"<CR>

" neovim terminal
command! -nargs=* T split | terminal <args>
command! -nargs=* VT vsplit | terminal <args>
command! -nargs=* VTS vsplit | vertical resize 90 | terminal <args>

" ----------------------------------------------------------------------------
" Markdown headings
" ----------------------------------------------------------------------------
nnoremap <leader>1 m`yypVr=``
nnoremap <leader>2 m`yypVr-``
nnoremap <leader>3 m`^i### <esc>``4l
nnoremap <leader>4 m`^i#### <esc>``6l

" ----------------------------------------------------------------------------
" <Leader>c Close quickfix/location window
" ----------------------------------------------------------------------------
nnoremap <leader>c :cclose<bar>lclose<cr>


" }}}
" ============================================================================
" FUNCTIONS & COMMANDS {{{
" ============================================================================
" ----------------------------------------------------------------------------
" <F5> / <F6> | Run script
" ----------------------------------------------------------------------------
function! s:run_this_script(output)
  let head   = getline(1)
  let pos    = stridx(head, '#!')
  let file   = expand('%:p')
  let ofile  = tempname()
  let rdr    = " 2>&1 | tee ".ofile
  let win    = winnr()
  let prefix = a:output ? 'silent !' : '!'
  " Shebang found
  if pos != -1
    execute prefix.strpart(head, pos + 2).' '.file.rdr
  " Shebang not found but executable
  elseif executable(file)
    execute prefix.file.rdr
  elseif &filetype == 'ruby'
    execute prefix.'/usr/bin/env ruby '.file.rdr
  elseif &filetype == 'tex'
    execute prefix.'latex '.file. '; [ $? -eq 0 ] && xdvi '. expand('%:r').rdr
  elseif &filetype == 'dot'
    let svg = expand('%:r') . '.svg'
    let png = expand('%:r') . '.png'
    " librsvg >> imagemagick + ghostscript
    execute 'silent !dot -Tsvg '.file.' -o '.svg.' && '
          \ 'rsvg-convert -z 2 '.svg.' > '.png.' && open '.png.rdr
  else
    return
  end
  redraw!
  if !a:output | return | endif

  " Scratch buffer
  if exists('s:vim_exec_buf') && bufexists(s:vim_exec_buf)
    execute bufwinnr(s:vim_exec_buf).'wincmd w'
    %d
  else
    silent!  bdelete [vim-exec-output]
    silent!  vertical botright split new
    silent!  file [vim-exec-output]
    setlocal buftype=nofile bufhidden=wipe noswapfile
    let      s:vim_exec_buf = winnr()
  endif
  execute 'silent! read' ofile
  normal! gg"_dd
  execute win.'wincmd w'
endfunction
nnoremap <silent> <F5> :call <SID>run_this_script(0)<cr>
nnoremap <silent> <F6> :call <SID>run_this_script(1)<cr>

" ----------------------------------------------------------------------------
" Profile
" ----------------------------------------------------------------------------
function! s:profile(bang)
  if a:bang
    profile pause
    noautocmd qall
  else
    profile start /tmp/profile.log
    profile func *
    profile file *
  endif
endfunction
command! -bang Profile call s:profile(<bang>0)

" ----------------------------------------------------------------------------
" <Leader>?/! | Google it / Feeling lucky
" ----------------------------------------------------------------------------
function! s:goog(pat, lucky)
  let q = '"'.substitute(a:pat, '["\n]', ' ', 'g').'"'
  let q = substitute(q, '[[:punct:] ]',
       \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
  call system(printf('open "https://www.google.com/search?%sq=%s"',
                   \ a:lucky ? 'btnI&' : '', q))
endfunction

nnoremap <leader>? :call <SID>goog(expand("<cWORD>"), 0)<cr>
nnoremap <leader>! :call <SID>goog(expand("<cWORD>"), 1)<cr>
xnoremap <leader>? "gy:call <SID>goog(@g, 0)<cr>gv
xnoremap <leader>! "gy:call <SID>goog(@g, 1)<cr>gv

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""
" vim-markdown
"""""""""""""""""""""""""""""""
let g:vim_markdown_conceal=0

" folding
set foldmethod=indent

"""""""""""""""""""""""""""""""
" airline
"""""""""""""""""""""""""""""""
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
let g:airline_highlighting_cache=1

let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#ale#enabled=1

"""""""""""""""""""""""""""""""
" gruvbox
"""""""""""""""""""""""""""""""
nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>

nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?

"""""""""""""""""""""""""""""""
" vim-sneak
"""""""""""""""""""""""""""""""
let g:sneak#label = 0

"""""""""""""""""""""""""""""""
" fzf
"""""""""""""""""""""""""""""""

" Hide statusline of terminal buffer
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" nnoremap <silent> <Leader><Leader> :Files<CR>
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <silent> <Leader>B :Buffers<CR>
nnoremap <silent> <Leader>L :Lines<CR>
nnoremap <silent> <Leader>c :Tags <C-R><C-W><CR>
nnoremap <silent> <Leader>C :Tags <CR>
nnoremap <silent> <Leader>ag :Rg <C-R><C-W><CR>
nnoremap <silent> <Leader>AG :Rg <CR>
xnoremap <silent> <Leader>ag y:Rg <C-R>"<CR>

function! s:plug_help_sink(line)
  let dir = g:plugs[a:line].dir
  for pat in ['doc/*.txt', 'README.md']
    let match = get(split(globpath(dir, pat), "\n"), 0, '')
    if len(match)
      execute 'tabedit' match
      return
    endif
  endfor
  tabnew
  execute 'Explore' dir
endfunction

command! PlugHelp call fzf#run(fzf#wrap({
  \ 'source': sort(keys(g:plugs)),
  \ 'sink':   function('s:plug_help_sink')}))

" fzf#vim#grep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=never --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)


""""""""""""""""""""""""""""""
" indentLine
""""""""""""""""""""""""""""""
let g:indentLine_color_term = 245
let g:indentLine_char = '¦'
set list lcs=tab:\|\

""""""""""""""""""""""""""""""
" Startify
""""""""""""""""""""""""""""""
let g:startify_session_dir = '~/.vim/sessions'

""""""""""""""""""""""""""""""
" Tagbar
""""""""""""""""""""""""""""""
nmap <F8> :TagbarToggle<CR>
nmap <F9> :TagbarTogglePause<CR>

"""""""""""""""""""""""""""""""""
" Vim-Sessions
"""""""""""""""""""""""""""""""""
set sessionoptions-=tabpages
set sessionoptions-=buffers
set sessionoptions-=options
let g:session_autosave = "no"
let g:session_autoload = "no"
let g:session_lock_enabled = 0

"""""""""""""""""""""""""""""""""
" gitgutter
"""""""""""""""""""""""""""""""""
let g:gitgutter_enabled = 1
let g:gitgutter_terminal_reports_focus = 0
let g:gitgutter_max_signs = 500
nmap <leader>hv <Plug>GitGutterPreviewHunk

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_set_loclist = 1
let g:ale_set_highlights = 1
let g:ale_set_signs = 1

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'go': ['gofmt', 'goimports'],
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'JSON': ['prettier'],
\   'YAML': ['prettier'],
\}
let g:ale_fix_on_save = 1

let g:ale_linters = {
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'python': ['flake8'],
\   'Dockerfile': ['hadolint'],
\   'go': ['golangci-lint'],
\   'JSON': ['prettier'],
\   'YAML': ['prettier'],
\   'proto': ['prototool-lint'],
\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1

let g:ale_go_golangci_lint_options = '--disable gochecknoglobals --disable gochecknoinits'
let g:ale_go_golangci_lint_package = 1

nmap ]a <Plug>(ale_next_wrap)
nmap [a <Plug>(ale_previous_wrap)

nnoremap <silent> <leader>f :call PrototoolFormatFix()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tagbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tagbar_sort = 0
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" ----------------------------------------------------------------------------
" vim-commentary
" ----------------------------------------------------------------------------
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" ----------------------------------------------------------------------------
" vim-fugitive
" ----------------------------------------------------------------------------
nmap     <Leader>g :Gstatus<CR>gg<c-n>
nnoremap <Leader>d :Gdiff<CR>

" ----------------------------------------------------------------------------
" NERDtree
" ----------------------------------------------------------------------------
let NERDTreeShowHidden=1

" ----------------------------------------------------------------------------
" UltiSnips
" ----------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

let g:UltiSnipsEditSplit = "vertical"

set rtp+=~/.vim/ftdetect/
let g:UltiSnipsSnippetsDir="~/.vim/ftdetect/UltiSnips"


" ----------------------------------------------------------------------------
" Conquer of Completion
" ----------------------------------------------------------------------------
" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" ----------------------------------------------------------------------------
" Formatters
" ----------------------------------------------------------------------------
function! FormatSQL() range
  execute a:firstline . "," . a:lastline . "!sqlf rmat --reindent --keywords upper --identifiers lower -a -"
endfunction
command! -range FormatSQL <line1>,<line2>call FormatSQL()

function! FormatJSON() range
  execute a:firstline . "," . a:lastline . "!python -m json.tool"
endfunction
command! -range FormatJSON <line1>,<line2>call FormatJSON()

" ----------------------------------------------------------------------------
" vim-easy-align
" ----------------------------------------------------------------------------
xmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" ----------------------------------------------------------------------------
" vim-delve
" ----------------------------------------------------------------------------
let g:delve_backend = "lldb"
