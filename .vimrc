" =============================================================================
"  Import basic environment based on different OS
" =============================================================================

" -----------------------------------------------------------------------------
"  Linux or Windows
" -----------------------------------------------------------------------------
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif

" -----------------------------------------------------------------------------
"  GUI or terminal
" -----------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif

" -----------------------------------------------------------------------------
"  Windows Gvim settings: fix the diff() bug
" -----------------------------------------------------------------------------
if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    " source $VIMRUNTIME/mswin.vim
    behave mswin
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
                "fix diff func bug on windows
                let cmd = '"' . $VIMRUNTIME . '\diff"'
"                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '""'
"                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

" -----------------------------------------------------------------------------
"  Linux setting, both GUI and terminal
" -----------------------------------------------------------------------------
if g:islinux
    set hlsearch
    set incsearch

    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim

        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif

        set mouse=a                    " use mouse
        set t_Co=256                   " use 256 color 
        set backspace=2                " 设置退格键可用

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif


" =============================================================================
"  User preference
" =============================================================================

"  map ',' as ';' then map ';' as leader
nnoremap , ;
let mapleader = ";"

" map cusor move in Insert Mode
inoremap <c-b> <Left>
inoremap <c-f> <Right>

" switch window easily
noremap <c-k> <c-w>k
noremap <c-j> <c-w>j
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l

" make searching item in the central of the window
nnoremap n nzz

" -----------------------------------------------------------------------------
"  < Vundle >
" Vundle requires git. A better way is to install cygwin. Then add cygwin path
" to the system environment. It's strongly recommanded that you put the cygwin
" path in the first position. Because Windows cmd also has some command which 
" have the same name as shell.
" -----------------------------------------------------------------------------

set nocompatible
filetype off

if g:islinux
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
else
    set rtp+=$VIM/vimfiles/bundle/vundle/
    call vundle#rc('$VIM/vimfiles/bundle/')
endif

Bundle 'gmarik/vundle'

Bundle 'a.vim'
" Bundle 'Align'
" Bundle 'jiangmiao/auto-pairs'
Bundle 'bufexplorer.zip'
Bundle 'WolfgangMehner/c.vim'
Bundle 'DoxygenToolkit.vim'
Bundle 'ccvext.vim'
" Bundle 'cSyntaxAfter'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'Yggdroot/indentLine'
Bundle 'Mark--Karkat'
Bundle 'Shougo/neocomplete.vim'
Bundle 'scrooloose/nerdtree'
" Bundle 'OmniCppComplete'
Bundle 'Lokaltog/vim-powerline'
Bundle 'repeat.vim'
" Bundle 'msanders/snipmate.vim'
" Bundle 'wesleyche/SrcExpl'
" Bundle 'std_c.zip'
" Bundle 'tpope/vim-surround'
Bundle 'scrooloose/syntastic'
Bundle 'majutsushi/tagbar'
" Bundle 'taglist.vim'
" Bundle 'TxtBrowser'
" Bundle 'ZoomWin'

" -----------------------------------------------------------------------------
" set encoding
" -----------------------------------------------------------------------------
set encoding=utf-8                                    "set encoding of gvim internal
set fileencoding=utf-8                                "default file encoding
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "supported file encoding

set fileformat=unix                                   "set <EOL> 
set fileformats=unix,dos,mac                          "set supported <EOL> type

if (g:iswindows && g:isGUI)                           "set menu encoding
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    language messages zh_CN.utf-8                     "set console output encoding
endif

" -----------------------------------------------------------------------------
"  < edit configuration >
" -----------------------------------------------------------------------------
filetype on
filetype plugin on
filetype plugin indent on
set smartindent

set expandtab                                         "expand tab to space
set tabstop=4                                         "set tab width
set softtabstop=4
set shiftwidth=4                                      "shift width
set smarttab
set softtabstop=4                                     "set space number of backspace
set nofoldenable                                      "no fold on startup
set foldmethod=indent
" set foldmethod=marker

set autoread
set noundofile

" toggle folding using <space>
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" clear redundant space at end of line
nmap cS :%s/\s\+$//g<CR>:noh<CR>
" clear redundant ^M at end of line
nmap cM :%s/\r$//g<CR>:noh<CR>

set ignorecase                                        "ignorecase when searching
set smartcase                                         "when capital letter appear, using noignorecase
" set noincsearch

" move cursor easily
nmap <leader>e $
nmap <leader>a ^
nmap <leader>g %

" copy and paste from system clipboard
vnoremap <leader>y "+y
nmap <leader>p "+p"
" when chracter beyond 80 columns, blue and underline characters
" au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)

" -----------------------------------------------------------------------------
"  < User Interface Setting >
" -----------------------------------------------------------------------------
set number                                            "line number
set laststatus=2                                      "status bar
set cmdheight=1                                       "set cmdline height
set guifont=YaHei_Consolas_Hybrid:h16                 "set gui font
set nowrap
set shortmess=atI                                     "no welcome info
set gcr=a:block-blinkon0                              "disable cursor blinking
set colorcolumn=120
" when character of a line more than 120, then highlight.
" au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 120 . 'v.\+', -1)


" set windows gVim
if (g:isGUI) && (g:iswindows)
    au GUIEnter * simalt ~x                           "maximum window on startup
    " winpos 100 10                                   "set position
    " set lines=38 columns=120                        "set window size
endif

" set colorscheme
if g:isGUI
"    colorscheme Tomorrow-Night-Eighties
    set cursorline
    set cursorcolumn
    colorscheme solarized
else
    set nocursorline
    set nocursorcolumn
    set background=dark
    colorscheme solarized
endif

" Toggle menue and scroll bar using Ctrl + F11
if g:isGUI
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    nmap <silent> <c-F11> :if &guioptions =~# 'm' <Bar>
        \set guioptions-=m <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=r <Bar>
        \set guioptions-=L <Bar>
    \else <Bar>
        \set guioptions+=m <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=r <Bar>
        \set guioptions+=L <Bar>
    \endif<CR>
endif

" -----------------------------------------------------------------------------
"  < other configuration >
" -----------------------------------------------------------------------------
set writebackup                             "backup before save
set nobackup                                "don't use backup file
set autochdir
" set noswapfile                            "don't use swap file
" set vb t_vb=                              "silent mode
" change dir automatically
" au BufRead,BufNewFile,BufEnter * cd %:p:h


" =============================================================================
"  Plugin Settings
" =============================================================================

" -----------------------------------------------------------------------------
"  < a.vim >
" -----------------------------------------------------------------------------
" 用于切换C/C++头文件
" :A    switch between .h/.c file
" :AV   switch and vertical split
" :AS   switch and horizontal split

" -----------------------------------------------------------------------------
"  < BufExplorer >
" -----------------------------------------------------------------------------
" <Leader>be open buffer list in current window
" <Leader>bs open buffer list in a new window and horizontal split
" <Leader>bv open buffer list in a new window and vertical split

" -----------------------------------------------------------------------------
"  < c-support >
" -----------------------------------------------------------------------------
" let g:C_MapLeader  = ';'

" -----------------------------------------------------------------------------
"  < ccvext.vim >
" -----------------------------------------------------------------------------
" generate tags and link with cscope, saving tags and other files in (X:\.symbs)
" (Windows) or "~/.symbs/"(Linux)
" <Leader>sy generate and link
" <Leader>sc link

" -----------------------------------------------------------------------------
"  < DoxygenToolkit 插件配置 >
" -----------------------------------------------------------------------------
nmap <Leader>dx :Dox<CR>
nmap <Leader>da :DoxAuthor<CR>
"let g:DoxygenToolkit_briefTag_pre="@Synopsis  "
"let g:DoxygenToolkit_paramTag_pre="@Param "
"let g:DoxygenToolkit_returnTag="@Returns   "
let g:DoxygenToolkit_commentType="C"
let g:DoxygenToolkit_briefTag_pre="\\biref "
let g:DoxygenToolkit_paramTag_pre = "\\param "
let g:DoxygenToolkit_returnTag = "\\return "
let g:DoxygenToolkit_fileTag = "\\file "
let g:DoxygenToolkit_authorTag = "\\author "
let g:DoxygenToolkit_dateTag = "\\date "
let g:DoxygenToolkit_versionTag = "\\version "
let g:DoxygenToolkit_blockTag = "\\name "
let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="Winter Liu"
"let g:DoxygenToolkit_licenseTag="My own license"   <-- Does not end with "\<enter>"

" -----------------------------------------------------------------------------
"  < ccvext.vim >
" -----------------------------------------------------------------------------
" <Leader>sy 自动生成tags与cscope文件并连接
" <Leader>sc 连接已存在的tags与cscope文件

" -----------------------------------------------------------------------------
"  < cSyntaxAfter >
" -----------------------------------------------------------------------------
" highlight bracket and operators
" au! BufRead,BufNewFile,BufEnter *.{c,cpp,h,java,javascript} call CSyntaxAfter()

" -----------------------------------------------------------------------------
"  < ctrlp.vim >
" -----------------------------------------------------------------------------
" Searching file using Ctrl + p

" -----------------------------------------------------------------------------
"  < indentLine >
" -----------------------------------------------------------------------------
nmap <leader>il :IndentLinesToggle<CR>

" set indeng line looks
if g:isGUI
    let g:indentLine_char = "┊"
    let g:indentLine_first_char = "┊"
endif

" set line color
let g:indentLine_color_term = 239
" let g:indentLine_color_gui = '#A4E57E'

" -----------------------------------------------------------------------------
"  < Mark--Karkat >
" -----------------------------------------------------------------------------
" Mark words using different colors

" -----------------------------------------------------------------------------
"  < MiniBufExplorer >
" -----------------------------------------------------------------------------
" swich between window

" -----------------------------------------------------------------------------
"  < neocomplete >
" -----------------------------------------------------------------------------
"nmap <F3> :NeoCompleteToggle<CR>
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

" -----------------------------------------------------------------------------
"  < nerdcommenter >
" -----------------------------------------------------------------------------
" comment varios language

" -----------------------------------------------------------------------------
"  < nerdtree >
" -----------------------------------------------------------------------------
let g:NERDTreeWinSize=25
nmap <Leader>nt :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

" -----------------------------------------------------------------------------
"  < powerline >
" -----------------------------------------------------------------------------
" set powerline scheme
let g:Powerline_colorscheme='solarized256'

" -----------------------------------------------------------------------------
"  < repeat >
" -----------------------------------------------------------------------------
" repeat command using "."

" -----------------------------------------------------------------------------
"  < snipMate >
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
"  < SrcExpl >
" -----------------------------------------------------------------------------
" something like "Source Insight"
" nmap <F3> :SrcExplToggle<CR>

" -----------------------------------------------------------------------------
"  < std_c >
" -----------------------------------------------------------------------------
"  enhanced highlighting for C language
let c_cpp_comments = 0

" -----------------------------------------------------------------------------
"  < Syntastic >
" -----------------------------------------------------------------------------
" check syntax while saving
nmap <leader>cc g:SyntasticCheck<CR>
let g:syntastic_check_on_wq = 0
let g:syntastic_always_populate_loc_list = 1
nmap <leader>ln :lnext<CR>
nmap <leader>lp :lprevious<CR>

" -----------------------------------------------------------------------------
"  < Tagbar >
" -----------------------------------------------------------------------------
"nmap <leader>tb :TlistClose<CR>:TagbarToggle<CR>
nmap <leader>tb :TagbarToggle<CR>
let g:tagbar_width=30


" =============================================================================
" Tools Settings
" =============================================================================

" -----------------------------------------------------------------------------
"  < cscope 工具配置 >
" -----------------------------------------------------------------------------
if has("cscope")
    "display result on Quickfix window
    set cscopequickfix=s-,c-,d-,i-,t-,e-
    "jump between functions using ctrl + t / [
    set cscopetag
    "searching forward
    set csto=0
    if filereadable("cscope.out")
        cs add cscope.out
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set cscopeverbose
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif

" -----------------------------------------------------------------------------
"  < ctags >
" -----------------------------------------------------------------------------
set tags=./tags;

" -----------------------------------------------------------------------------
"  < gvimfullscreen >
" -----------------------------------------------------------------------------
" available on Windows
if (g:iswindows && g:isGUI)
    nmap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
endif

