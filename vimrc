" Initialize:"{{{
"

""""""""""""""""""""""""""""""
"内部エンコーディングの設定
""""""""""""""""""""""""""""""
set encoding=utf-8
set termencoding=utf-8


scriptencoding utf-8

"------------------------------------
" neobundle.vim
"------------------------------------
"filetype plugin indent off     " required!

let g:neobundle#types#git#default_protocol="https"

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc.vim', {
      \   'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'linux' : 'make',
      \     'unix' : 'gmake',
      \   }
      \ }

" My Bundles here:
"
" original repos on github
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'

NeoBundle 'rhysd/unite-codic.vim'
NeoBundle 'koron/codic-vim'

NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'bling/vim-airline'

NeoBundle 'thinca/vim-quickrun'
NeoBundle 'mattn/sonictemplate-vim'
NeoBundle 'vim-jp/vim-go-extra'

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'cohama/agit.vim'

NeoBundle 'ctrlpvim/ctrlp.vim'

" Vim-script repositories
"NeoBundle 'vim-scripts/gtags.vim'
"NeoBundle 'vim-scripts/taglist.vim'

call neobundle#end()

filetype plugin indent on     " required!

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

if !has('vim_starting')
  " Call on_source hook when reloading .vimrc.
  call neobundle#call_hook('on_source')
endif

"---------------------------------------------------------------------------
augroup vimrc
  autocmd!
augroup END

"---------------------------------------------------------------------------
" Ev/Rvでvimrcの編集と反映
command! Ev tabedit   $MYVIMRC
command! Rv source $MYVIMRC

"-------------------------------------------------------------------------------
" ステータスライン StatusLine
"-------------------------------------------------------------------------------
set laststatus=2 " 常にステータスラインを表示

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=4
set softtabstop=4
set shiftwidth=4
" タブをスペースに展開しない (expandtab:展開する)
set noexpandtab
"新しい行のインデントを同じ行にする
set autoindent
set smartindent
set cindent

filetype plugin indent on
set nocindent
" 改行時にコメントしない
set formatoptions-=ro
augroup vimrc_group_formatoptions
  autocmd!
  autocmd FileType * setlocal formatoptions-=ro
augroup END
" バックスペースでインデントや改行を削除できるようにする
set backspace=2
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" 10進にする
set nrformats=

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示 (number:表示)
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
set list
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:▸\ ,trail:_,extends:>,precedes:<
set listchars=tab:^.,trail:_,extends:>,precedes:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set nowrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=1
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" 補完のプレビュー無効
set completeopt=menuone

" Do not display greetings message at the time of Vim start.
set shortmess=aTI

" Display all the information of the tag by the supplement of the Insert mode.
set showfulltag

"全角スペースを表示 {{{
"http://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-color
"コメント以外で全角スペースを指定しているので scriptencodingと、
"このファイルのエンコードが一致するよう注意！
"全角スペースが強調表示されない場合、ここでscriptencodingを指定すると良い。
"scriptencoding cp932

function! s:zenkakuSpace()
  "ZenkakuSpaceをカラーファイルで設定するなら次の行は削除
  highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
  "全角スペースを明示的に表示する。
  silent! match ZenkakuSpace /　/
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd VimEnter,BufEnter * call <SID>zenkakuSpace()
  augroup END
endif
" }}}

if !has('gui_running')
" ------------------------------------------------------------------
" Solarized Colorscheme Config
" ------------------------------------------------------------------
  let g:solarized_bold=0    "default value is 1
  let g:solarized_italic=0  "default value is 1
  syntax enable
  set background=dark
  colorscheme solarized

" ------------------------------------------------------------------
  " Using the mouse on a terminal
  if has('mouse')
    set mouse=a
      if v:version == 703 && has('patch632') " I couldn't use has('mouse_sgr') :-(
        set ttymouse=sgr
      else
        set ttymouse=xterm2
    endif
  endif
endif

"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
set nobackup

" スワップファイル作らない
set noswapfile

" undoファイル保存先
set undodir=~/.vim/undo

"ファイル保存の初期ディレクトリをバッファファイル位置に設定
set browsedir=buffer

" 常に開いているファイルと同じディレクトリをカレントディレクトリにする
augroup group_vimrc_cd
  autocmd!
  autocmd BufEnter * execute ":lcd " . (isdirectory(expand("%:p:h")) ? expand("%:p:h") : "")
augroup END

" 自動的にクリップボードへ
set clipboard+=autoselect
set clipboard+=unnamed

" Grep設定
" Use vimgrep.
"set grepprg=internal
" Use grep.
set grepprg=grep\ -nH


"function! s:remove_dust()
"    let cursor = getpos(".")
    " 保存時に行末の空白を除去する
""    %s/\s\+$//ge
"    %s/\S\zs\s\+$//e
"    call setpos(".", cursor)
"    unlet cursor
"endfunction
"autocmd vimrc BufWritePre * call <SID>remove_dust()

" 保存時にGoFmtを実行する
autocmd vimrc FileType go autocmd vimrc BufWritePre <buffer> Fmt

"---------------------------------------------------------------------------
" キーマッピングに関する設定:
"

" leaderを,に変更
let mapleader=","

noremap p P
noremap P p

" C-@ の誤爆防止
inoremap <C-@> <ESC>

" 検索後画面の中心に。
nnoremap n nzz
nnoremap N Nzz

" 検索のハイライトを消す
nnoremap <Esc><Esc> :nohlsearch<CR>

" CTRL-V and SHIFT-Insert are Paste without Normal mode.
noremap! <C-v> <C-R>*

" バッファの移動
nnoremap <silent> <SPACE> :bnext<CR>

" タブの移動
nnoremap <silent> <C-l> :tabnext<CR>
nnoremap <silent> <C-h> :tabprevious<CR>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

"-------------------------------------------------------------------------------
" タグ関連 Tags
"-------------------------------------------------------------------------------
" tagsファイルを検索する際に、カレントバッファから上に辿って探す
set tags+=./tags;

"-------------------------------------------------------------------------------
" プラグインごとの設定 Plugins
"-------------------------------------------------------------------------------
"------------------------------------
" vim-airline
"------------------------------------
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_theme='powerlineish'
let g:airline#extensions#whitespace#enabled = 0

" old vim-powerline symbols
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'

"------------------------------------
" vimproc
"------------------------------------

"------------------------------------
" unite.vim
"------------------------------------
let g:unite_data_directory = $HOME."/.vim/.unite"

" unite.vim"{{{
" The prefix key.
nnoremap    [unite]   <Nop>
xnoremap    [unite]   <Nop>
nmap    <Leader>f [unite]
xmap    <Leader>f [unite]

nnoremap <silent> [unite]/  :<C-u>Unite -buffer-name=search line -start-insert -no-quit<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register history/yank<CR>
nnoremap <silent> [unite]o :<C-u>Unite outline -start-insert<CR>
nnoremap [unite]f :<C-u>Unite source<CR>
nnoremap <silent> [unite]t :<C-u>Unite sonictemplate<CR>
xnoremap <silent> [unite]r d:<C-u>Unite -buffer-name=register register history/yank<CR>
nnoremap <silent> [unite]w :<C-u>UniteWithCursorWord -buffer-name=register
      \ buffer file_mru bookmark file<CR>
nnoremap <silent> [unite]g :<C-u>Unite grep -buffer-name=search -no-quit<CR>
"nnoremap <silent> [unite]g :<C-u>Unite grep:::<C-R>=escape(@/, '\\.*$^[]')<CR><CR>
nnoremap <silent> <C-k> :<C-u>Unite change jump<CR>
nnoremap <silent> [unite]c :<C-u>Unite change<CR>
nnoremap <silent> [unite]d :<C-u>Unite -buffer-name=files -default-action=lcd directory_mru<CR>
nnoremap <silent> [unite]ma :<C-u>Unite mapping<CR>
nnoremap <silent> [unite]me :<C-u>Unite output:message<CR>
nnoremap <silent> [unite]mru :<C-u>Unite file_mru<CR>
" unite-grepのキーマップ
" 選択した文字列をunite-grep
" https://github.com/shingokatsushima/dotfiles/blob/master/.vimrc
vnoremap /g y:Unite grep:::<C-R>=escape(@", '\\.*$^[]')<CR><CR>
" }}}


"------------------------------------
" neocomplete.vim
"------------------------------------
let g:neocomplete#data_directory = $HOME."/.vim/.neocomplete"
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" Enable omni completion.
autocmd vimrc FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd vimrc FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd vimrc FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd vimrc FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd vimrc FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'


"------------------------------------
" quickrun.vim
"------------------------------------
let g:quickrun_config = {}
let g:quickrun_config['*'] = {'runmode': "async:remote:vimproc", 'split': 'below'}

"------------------------------------
" ctrlp.vim
"------------------------------------
if executable('ag')
  let g:ctrlp_use_caching=0
  let g:ctrlp_user_command='ag %s -i --nocolor --nogroup -g ""'
endif

