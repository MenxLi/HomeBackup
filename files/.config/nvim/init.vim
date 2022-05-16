" Some notes:
"
" Dependecies
" |- yarn: COC
" |- Nodejs: COC
" |- VimVersion > 8.0: COC
" |- CCLS: COC(For C/C++)
" |- Ag: silversearcher-ag (For FZF-ag)
" |- lehre: jsdoc
" |- npm -g install instant-markdown-d (for markdown preview)
" |- pip install pynvim
" |- pip install ast (For python docstring)
"
" For beauty:
" |- Powerline fonts (for airline): https://github.com/powerline/fonts
" |- Nerdfont (for devicons): https://gist.github.com/matthewjberger/7dd7e079f282f8138a9dc3b045ebefa0
"

" Place basic configurations in .vimrc
source ~/.vimrc

" Plugins using vim-plug=============================={{{
call plug#begin()
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
" Plug 'scrooloose/nerdtree'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'zhimsel/vim-stay'
Plug 'tpope/vim-repeat'
Plug 'preservim/nerdcommenter'
Plug 'tmhedberg/SimpylFold'
Plug 'wesQ3/vim-windowswap'
Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-startify'
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'SirVer/ultisnips'
Plug 'sheerun/vim-polyglot'
" ==== Beautify
Plug 'flazz/vim-colorschemes'
" Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'sainnhe/sonokai'
Plug 'tomasiser/vim-code-dark'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
" ==
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'luochen1990/rainbow'
" ==== Web dev
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'
Plug 'valloric/MatchTagAlways'
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'javascript.jsx','typescript'],
  \ 'do': 'make install'
\}
" ==== python
Plug 'pixelneo/vim-python-docstring'
call plug#end()

" CocNvim plugins
" :CocInstall coc-tsserver
"}}}

"===================Plugin settings===================
" markdown----------------------{{{
" slow down refresh of markdown preview 
let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 0
let vim_markdown_preview_browser='Firefox'
au Filetype markdown map <c-b> :InstantMarkdownPreview<CR>"
"}}}
"
" Colorscheme------------------{{{
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

set background=dark
" colorscheme zenburn
" colorscheme gruvbox
colorscheme sonokai
" colorscheme codedark
let g:one_allow_italics = 1
"}}}

" vim-airline------------------{{{
" set guifont=Liberation\ Mono\ for\ Powerline\ 10
set guifont=Source_Code_Pro_Light:h15:cANSI
let g:airline_powerline_fonts = 1
" let g:airline_theme='gruvbox'
"let g:airline_theme='powerlineish'
" if !exists('g:airline_symbols')
"         let g:airline_symbols = {}
"     endif
" get working directory into airline
let g:airline_section_c = airline#section#create(['path', 'readonly'])
let g:airline#extensions#tabline#tabs_label = fnamemodify(getcwd(), ':t')
"}}}

" Nerdtree--------------------{{{
nnoremap ;F :NERDTreeToggle<cr>
" show hidden files
let NERDTreeShowHidden=1
" close vim if the only window left open is a NERDTree
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Start NERDTree and put the cursor back in the other window.
" autocmd VimEnter * NERDTree | wincmd p
" Exit Vim if NERDTree is the only window remaining in the only tab.
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
" autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Nerdtree-git--------{{{
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
"}}}
" }}}

" Python-mode ---------------{{{
let g:pymode_options_max_line_length = 100
let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}
let g:pymode_options_colorcolumn = 1
"}}}

" pixelneo/vim-python-docstring{{{
au filetype python nnoremap ;ds :Docstring<cr>
let g:python_style = 'google'"}}}

"NerdCommenter{{{
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/*','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1

vmap CC <plug>NERDCommenterToggle
nmap CC <plug>NERDCommenterToggle
" }}}

"{{{ Rainbow
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
	\	'separately': {
	\		'nerdtree': 0,
	\	}
	\}
"}}}

" SimpylFold------------------{{{
" Enable docstring preview
let g:SimpulFold_docstring_preview = 1
let g:SimpylFold_fold_import = 1
"}}}

" Syntastic-------------------{{{
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
"
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 0
" "let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
"
" " Disable by default, When need to use error checking simply hit: ctrl-w E
" let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
" nnoremap <C-w>E :SyntasticCheck<CR>
"}}}

"Auto pair--------------------{{{
" default bind to <C-h>, ban!
let g:AutoPairsMapCh = 0
"}}}

"Vim stay--------------------{{{
set viewoptions=cursor,folds,slash,unix
"}}}

" emmet----------------------{{{
" https://medium.com/vim-drops/be-a-html-ninja-with-emmet-for-vim-feee15447ef1
let g:user_emmet_leader_key=','
"}}}

" vimtex-------------------{{{
" let g:tex_flavor = 'latex'}}}

"{{{ jsdoc
" nmap <silent> <c-l> <plug>(jsdoc)
au filetype javascript nmap <silent> <c-d> <plug>(jsdoc)
let g:jsdoc_lehre_path = "/home/monsoon/.nvm/versions/node/v16.14.0/bin/lehre"
let g:jsdoc_formatter = "esdoc"
"}}}

"{{{ MatchTagAlways
nnoremap <leader>% :MtaJumpToOtherTag<cr>
"}}}

" vim-snippets & ultisnips{{{
let g:ultisnips_python_style = 'google'
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="''"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"}}}

" FZF{{{
nmap ;f [fzf-prefix]
" nnoremap [fzf-prefix]f :FZF<CR>
nnoremap [fzf-prefix]f :Files<CR>
nnoremap [fzf-prefix]h :History:<CR>
nnoremap [fzf-prefix]a :Ag<CR>
nnoremap [fzf-prefix]b :Buffer<CR>
"}}}

"COC-----------------------------------{{{
"
let g:coc_global_extensions = [
    \ 'coc-pyright',
    \ 'coc-css',
    \ 'coc-tsserver',
    \ 'coc-eslint',
    \ 'coc-json',
    \ 'coc-highlight',
    \ 'coc-tabnine',
    \ 'coc-texlab',
    \ 'coc-snippets',
    \ 'coc-explorer'
    \ ]

"{{{ Default
" TextEdit might fail if hidden is not set.
set hidden
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction 

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"}}}

" =========> COC Plugin <==============
" coc-texlab{{{
au filetype tex noremap <C-b> :w<cr>:CocCommand latex.Build<cr>
"}}}

" coc-highlight{{{
autocmd CursorHold * silent call CocActionAsync('highlight')
"}}}

" coc-pydocstring{{{
nmap <silent> ga <Plug>(coc-codeaction-line)
xmap <silent> ga <Plug>(coc-codeaction-selected)
nmap <silent> gA <Plug>(coc-codeaction)
"}}}

" coc-snippets{{{
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" Make <tab> used for trigger completion, completion confirm, snippet expand and jump like VSCode.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
"}}}

" coc-explorer{{{
nmap ;e [coc-explorer-prefix]
nmap [coc-explorer-prefix] <Cmd>CocCommand explorer<CR>
nmap [coc-explorer-prefix]e <Cmd>CocCommand explorer<CR>
let g:coc_explorer_global_presets = {
\   '.vim': {
\     'root-uri': '~/.vim',
\   },
\   'cocConfig': {
\      'root-uri': '~/.config/coc',
\   },
\   'tab': {
\     'position': 'tab',
\     'quit-on-open': v:true,
\   },
\   'tab:$': {
\     'position': 'tab:$',
\     'quit-on-open': v:true,
\   },
\   'floating': {
\     'position': 'floating',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingTop': {
\     'position': 'floating',
\     'floating-position': 'center-top',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingLeftside': {
\     'position': 'floating',
\     'floating-position': 'left-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingRightside': {
\     'position': 'floating',
\     'floating-position': 'right-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'simplify': {
\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   },
\   'buffer': {
\     'sources': [{'name': 'buffer', 'expand': v:true}]
\   },
\ }

" Use preset argument to open it
nmap [coc-explorer-prefix]d <Cmd>CocCommand explorer --preset .vim<CR>
nmap [coc-explorer-prefix]f <Cmd>CocCommand explorer --preset floating<CR>
nmap [coc-explorer-prefix]c <Cmd>CocCommand explorer --preset cocConfig<CR>
nmap [coc-explorer-prefix]b <Cmd>CocCommand explorer --preset buffer<CR>

" List all presets
nmap [coc-explorer-prefix]l <Cmd>CocList explPresets<CR>
"}}}

"-------------------------}}}

