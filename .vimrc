" after installing vim on a new system:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" :GoInstallBinaries
" :CocInstall coc-sh coc-css coc-flutter coc-go coc-html coc-tsserver coc-json coc-solidity


"enable mouse
" if has("mouse_sgr")
"   set ttymouse=sgr
"   set mouse=a
" else
"   set ttymouse=xterm2
"   set mouse=a
" end

" Recently vim can merge signcolumn and number column into one
if has("nvim-0.5.0") || has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

"special
" set dictionary+=/home/john/.vim/dict.txt
set nocompatible
set ttimeoutlen=50
setlocal iskeyword+=-
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

"interface
set number
set splitright
set cursorline
set nowrap
set wildmenu
set ignorecase
set equalalways
set winminheight=0
set winminwidth=0
set laststatus=2
set completeopt=longest,menuone
set backspace=indent,eol,start
set colorcolumn=80
set incsearch
set clipboard=unnamedplus
set splitkeep=screen
set termguicolors

"tabs
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set smarttab
set autoindent
set breakindent

"persistent undo and backups
set undofile
set undodir=~/.vim/undodir
set backupdir=~/.vim/backup
set directory=~/.vim/swp

"improve performance over SSH
set lazyredraw
set ttyfast

hi SpellBad guibg=lightred guifg=white
autocmd vimenter * colorscheme everforest

filetype plugin indent on
" syntax on

" global mappings
map <C-q> :b#<bar>bd#<CR>
nnoremap k gk
nnoremap K 5k
nnoremap j gj
nnoremap J 5j
nmap <C-=> ggvG=<C-o><C-o> 
nmap a A
nmap <C-d> <esc>:qa<enter>
nmap - o<Esc>
nmap ; :w<enter>
nmap <space> :
nmap <Tab> <C-w>w
nmap <S-Tab> <C-w>W
" nmap <C-W>s Hmx`` \|:split<CR>`xzt``
nmap \| :TagbarToggle<enter>
nmap <leader>u :UndotreeToggle<enter>
nmap \\ :NERDTreeToggle<enter>
map <S-F10> :setlocal spell! spelllang=en_us<CR>
nmap # yiwa `json:"<esc>pb~ww
nmap Q yiwwpbi id="<esc>xwwP
nmap ! 0yiwa <esc>p0i<<esc>wwiclass="<esc>xwwhi"<esc>xli></<esc>lxa>
nmap <s-f2> :term<enter>
nmap H gg=G<C-o><C-o>;


"plugins
call plug#begin('~/.vim/plugged')

" Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'majutsushi/tagbar'
Plug 'mbbill/undotree'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
" Plug 'christoomey/vim-tmux-navigator'

" Plug 'othree/html5.vim'
Plug 'sheerun/vim-polyglot'

Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'

" Android
Plug 'thosakwe/vim-flutter'
Plug 'dart-lang/dart-vim-plugin'
Plug 'udalov/kotlin-vim'

" Javascript
Plug 'jelera/vim-javascript-syntax'
Plug '1995eaton/vim-better-javascript-completion'
" Plug 'ramitos/jsctags'
" Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
" Plug 'maksimr/vim-jsbeautify'

" Themes
Plug 'morhetz/gruvbox'
Plug 'sainnhe/everforest'

" Solidity
Plug 'tomlion/vim-solidity'

Plug 'nvim-lualine/lualine.nvim'
Plug 'nanozuki/tabby.nvim'
" window auto-resize/animations
" Plug 'camspiers/animate.vim'
" Plug 'camspiers/lens.vim'


" Plug 'natebosch/vim-lsc'
" Plug 'natebosch/vim-lsc-dart'
" let g:lsc_auto_map = v:true
" let g:lsc_dart_sdk_path = '~/snap/flutter/common/flutter/bin/cache/dart-sdk'
" let g:lsc_server_commands = {'dart': 'dart_language_server'}

" Plug 'francoiscabrol/ranger.vim'
" Plug 'jistr/vim-nerdtree-tabs'
" Plug 'rafi/vim-tinyline'
"
" Plug 'ervandew/supertab'
" Plug 'Shougo/echodoc.vim'
" Plug 'SirVer/ultisnips'

" Plug 'morhetz/gruvbox'

" Plug 'vim-scripts/c.vim'
" Plug 'Rip-Rip/clang_complete'

" Plug 'alvan/vim-closetag'
" Plug 'ap/vim-css-color'
" Plug 'posva/vim-vue'
" Plug 'tomlion/vim-solidity'
call plug#end()

" Rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

" GO
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"
let g:go_term_enabled = 1
autocmd FileType go setlocal shiftwidth=8 tabstop=8 expandtab
au FileType go nmap <enter> :GoDoc<enter>
au FileType go nmap \<enter> <Plug>(go-def-vertical)
au BufReadPost *.tmpl set filetype=html.tmpl
ab iff if err != nil {<enter>log.Println(err)<esc>jo
ab logg log.Println("")<esc>hi
ab rrr for _, _ := range 

" NERDTree
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeWinSize=16

" COC
set updatetime=300
set shortmess+=c
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"vimjs
let g:vimjs#casesensistive = 0
" Enabled by default. flip the value to make completion matches case insensitive

let g:vimjs#smartcomplete = 1
" Disabled by default. Enabling this will let vim complete matches at any location
" e.g. typing 'ocument' will suggest 'document' if enabled.

let g:vimjs#chromeapis = 1
" Disabled by default. Toggling this will enable completion for a number of Chrome's JavaScript extension APIs
"

autocmd VimEnter * call timer_start(200, { tid -> execute('hi LineNr guifg=#c9a993 guibg=#ba5922')})
au InsertEnter * hi statusLineNC guifg=#c2a774 guibg=#fff4ce
au InsertEnter * hi StatusLine term=reverse guibg=#a85432 guifg=#faefeb
au InsertLeave * hi StatusLine term=reverse guibg=#e6e48c guifg=#7a7802

" fu! SaveSess()
"   execute 'mksession! ' . getcwd() . '/.session.vim'
" endfunction

" fu! RestoreSess()
"   if filereadable(getcwd() . '/.session.vim')
"     execute 'so ' . getcwd() . '/.session.vim'
"     if bufexists(1)
"       for l in range(1, bufnr('$'))
"         if bufwinnr(l) == -1
"           exec 'sbuffer ' . l
"         endif
"       endfor
"     endif
"   endif
" endfunction

" Save session on quitting Vim
" autocmd VimLeave * NERDTreeClose
" autocmd VimLeave * call SaveSess()

" Restore session on starting Vim
" autocmd VimEnter * nested call RestoreSess()


let g:tmux_navigator_no_mappings = 1
" noremap <silent> {Left-Mapp :<C-U>TmuxNavigateLeft<cr>
" noremap <silent> {Down-Mapping} :<C-U>TmuxNavigateDown<cr>
" noremap <silent> {Up-Mapping} :<C-U>TmuxNavigateUp<cr>
" noremap <silent> {Right-Mapping} :<C-U>TmuxNavigateRight<cr>
" noremap <silent> <Tab> :<C-U>TmuxNavigatePrevious<cr>
" autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType javascript autocmd BufWritePre <buffer> call JsBeautify()
" autocmd FileType tmpl setlocal formatprg=tidy\ -indent\ -quiet\ --show-errors\ 0\ --tidy-mark\ no\ --show-body-only\ auto
" autocmd BufRead,BufNewFile *.tmpl inoremap = =""<Left>
" set background=light
" let g:everforest_background = 'soft'
" autocmd BufNewFile,BufRead *.tmpl set filetype=html
"highlight Normal guibg=#FDF6E3
"autocmd InsertEnter * hi CursorLineNR ctermfg=022 ctermbg=148 cterm=bold
"autocmd InsertLeave * hi CursorLineNR ctermfg=255 ctermbg=red cterm=none
""Custom syntax highlighting
"hi Boolean ctermfg=089
"hi Comment guifg=#3da5a8
"hi Function ctermfg=029
"hi Keyword ctermfg=124
"hi Number ctermfg=172
"hi Method ctermfg=106 ctermbg=085
"hi String guifg=#96452a
"hi GoSpace ctermbg=222
"hi GoTodo ctermbg=214 ctermfg=232
"hi GoEscapeC cterm=bold ctermfg=291
"hi GoTypeConstructor ctermfg=161
"hi GoField ctermfg=red

"hi MatchParen cterm=bold ctermbg=085 ctermfg=016

hi CursorLine cterm=NONE guibg=#000000
hi CursorLineNR guifg=#000000 guibg=#f7c783
" hi Pmenu ctermbg=159 ctermfg=025
" hi PmenuSel ctermbg=025 ctermfg=159
" hi Pmenu guibg=#fffedc guifg=#000000
" hi PmenuSel guibg=#fffedc guifg=#000000
"hi Search ctermbg=226
"hi spellbad ctermbg=224 ctermfg=196
"hi StatusLineNC ctermfg=220 ctermbg=016
"hi VertSplit ctermfg=232 ctermbg=255
"hi Visual ctermbg=226
"hi ColorColumn ctermbg=229

" hi SignColumn ctermbg=016

"add comment on new line ??????
" set formatoptions=tcroql

" silent! source $VIMRUNTIME/defaults.vim

" adjust quickfix window
" autocmd FileType qf wincmd J

" function! Statusline() abort
" 	let focused = g:statusline_winid == win_getid(winnr())
" 	let statusline = focused ? "green" : "blue"
" 	return statusline
" endfunction


" augroup statusline
"     autocmd!
"     autocmd WinEnter,BufEnter * hi StatusLine guibg=%!Statusline()
"     autocmd WinLeave,BufLeave * hi StatusLine guibg=%!Statusline()
" augroup end
"
