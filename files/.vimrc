
" colorscheme evening

"----------------My settings-----------------
syntax on
filetype on
filetype plugin on
filetype indent on 	" load the filetype-specific indent files
set nu				" show line number
set relativenumber	" show relative linenumber
" set fillchars+=vert:│   " change separation style
"set tabstop=4
"set softtabstop=4
set expandtab 		" turn <tab> into normal spaces
set showcmd			" show commands at bottom no matter what
" set cursorline		" highlight the line where the  cursor is
set wildmode=longest,list,full  " allow Tab completion on command mode
set wildmenu		" autocomplete menu (press tab to show)
set showmatch		" highlight the matching brackets (enables by default)
set encoding=utf-8
set smartindent 
" set foldmethod=marker "Enable folding
set updatetime=300  " Refresh time for writes swapfile and others
set tw=160          " Textwidth for auto line break
:let &t_ut=''       " fix background black lines issue
set signcolumn=yes
set cmdheight=1          " Give more space for displaying messages.
set path+=**            " Provide tab completion for all file related tasks (search down into sub folders)
set wrap                " To wrap lines visually, i.e. the line is still one line of text, but Vim displays it on multiple lines.
set omnifunc=syntaxcomplete#Complete
if (has("termguicolors"))
  set termguicolors
endif
set textwidth=0

set tabstop=4
set softtabstop=4
set shiftwidth=4
set nobackup

" for cross-terminal clipboard support
set clipboard=unnamed
set clipboard^=unnamedplus

" File specific settings ===================================================={{{
" https://stackoverflow.com/questions/158968/changing-vim-indentation-behavior-by-file-type
autocmd FileType vim,txt setlocal foldmethod=marker

" treat json as jsonc
autocmd BufRead,BufNewFile *.json set filetype=jsonc

" GLSL support
autocmd! BufNewFile,BufRead *.vs,*.fs set filetype=glsl

" Python settings
let python_highlight_all=1
au Filetype python setlocal tabstop=4
au Filetype python setlocal softtabstop=4
au Filetype python setlocal shiftwidth=4
au Filetype python setlocal expandtab
" au Filetype python setlocal textwidth=79
au Filetype python setlocal expandtab
au Filetype python setlocal autoindent
au Filetype python setlocal fileformat=unix
" au Filetype python setlocal foldmethod=marker

" Markdown settings
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
au Filetype markdown setlocal autoindent

" Html settings
au Filetype html setlocal shiftwidth=4 softtabstop=4 expandtab
au Filetype html setlocal foldmethod=syntax

" Javascript settings
au Filetype javascript setlocal shiftwidth=4 softtabstop=4 expandtab
au Filetype javascript setlocal foldmethod=syntax

" C/C++
au filetype c,cpp setlocal foldmethod=syntax
au filetype c,cpp setlocal cindent

" tex settings
au Filetype tex setlocal shiftwidth=2 softtabstop=2 expandtab

"}}}

" My Functions__________{{{
function! TRelative()		" function! will override a function if it's defined before
	set relativenumber!		" set relative number to opposite
endfunc

func! CompileRunGcc()
        exec "w"
        if &filetype == 'c'
                exec "!g++ % -o %<"
                exec "!time ./%<"
        elseif &filetype == 'cpp'
                exec "!g++ % -o %<"
                exec "!time ./%<"
        elseif &filetype == 'java'
                exec "!javac %"
                exec "!time java %<"
        elseif &filetype == 'sh'
                :!time bash %
        elseif &filetype == 'python'
                exec "!clear"
                exec "!time python3 %"
        elseif &filetype == 'html'
                exec "!firefox % &"
        elseif &filetype == 'go'
                " exec "!go build %<"
                exec "!time go run %"
        elseif &filetype == 'mkd'
                exec "!~/.vim/markdown.pl % > %.html &"
                exec "!firefox %.html &"
        endif
endfunc

"}}}

"=====================My_Mappings____________{{{
" to fix meta-keys which generate <Esc>a .. <Esc>z goto:
" https://vim.fandom.com/wiki/Fix_meta-keys_that_break_out_of_Insert_mode
"

:noremap / :set hlsearch<CR>/

" toggle paste mode
:noremap <F2> :set paste! nopaste?<CR>

" toggle number lines
:noremap <F3> :set nonumber! nonumber?<CR>

" toggle search highlights
:noremap <F4> :set hlsearch! hlsearch?<CR>

let mapleader=";;"
nnoremap <c-t> :call TRelative()<cr>
map <F5> :call CompileRunGcc()<CR>
" Remap space to folding
nnoremap <space> za
set pastetoggle=<F2>
" Motion
nnoremap <up> <c-y>
nnoremap <down> <c-e>
nnoremap <left> <c-u>
nnoremap <right> <c-d>
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>
map <C-;> <Esc>
" Insert tag create pair tag from word before cursor.
inoremap <C-t> <></><Esc>5hdiwp3lpT>i
" Easier save
inoremap ;;s <Esc>:w<cr>a
nnoremap ;;s <Esc>:w<cr>

" Terminal mapping
command! -nargs=* T split | terminal <args>
command! -nargs=* VT vsplit | terminal <args>
command! -nargs=* TT tabedit | terminal <args>
tnoremap <leader>d <C-\><C-n>
tnoremap <Esc> <C-\><C-n>
"}}}

