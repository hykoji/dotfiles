" Initialize:"{{{
"
"source $VIMRUNTIME/defaults.vim

"language ja_JP.utf8

scriptencoding utf-8
set encoding=utf-8
set termencoding=utf-8

""""""""""""""""""""""""""""""
"内部エンコーディングの設定
""""""""""""""""""""""""""""""
source  ~/dotfiles/encoding.rc.vim

" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif


" leaderを,に変更
let mapleader=","

"------------------------------------
" dein.vim
"------------------------------------
if &compatible
  set nocompatible
endif
set runtimepath+=~/.config/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.config/dein')
    call dein#begin('~/.config/dein')

"    call dein#load_toml("~/.config/dein/plugin/plugins.toml", {'lazy': 0})
    call dein#load_toml("~/.config/dein/plugin/plugins_coc.toml", {'lazy': 0})
"    call dein#load_toml("~/.config/dein/plugin/lazy.toml",    {'lazy': 1})

    call dein#end()
    call dein#save_state()
endif

if !has('vim_starting') && dein#check_install()
  " Installation check.
  call dein#install()
endif

filetype plugin indent on
syntax enable


" Ev/Rvでvimrcの編集と反映
command! Ev tabedit   $MYVIMRC
command! Rv source $MYVIMRC

"-------------------------------------------------------------------------------
" ステータスライン StatusLine
"-------------------------------------------------------------------------------
set laststatus=2 " 常にステータス行を表示 (詳細は:he laststatus)

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=4
set softtabstop=4
set shiftwidth=4
" タブをスペースに展開しない (expandtab:展開する)
set noexpandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
set cindent
" 括弧を入力した時にカーソルが移動しないように設定
set matchtime=0

" バックスペースでインデントや改行を削除できるようにする
"set backspace=2
set backspace=indent,eol,start

" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan

" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
"set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
"set formatoptions+=mM
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" 改行時にコメントしない
set formatoptions-=ro
augroup vimrc_group_formatoptions
	autocmd!
	autocmd FileType * setlocal formatoptions-=ro
augroup END

set undodir= "~/.vim/undo"

" set virtualedit=block

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示 (number:表示)
set number
" カーソルラインをハイライト
set cursorline
" ルーラーを表示 (noruler:非表示)
"set ruler
" タブや改行を表示 (list:表示)
set list
" どの文字でタブや改行を表示するかを設定
set listchars=tab:^.,trail:_,extends:>,precedes:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set nowrap
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=1
" コマンドをステータス行に表示
"set showcmd
" タイトルを表示
set title

" Do not display greetings message at the time of Vim start.
set shortmess=aTI

" Display all the information of the tag by the supplement of the Insert mode.
set showfulltag
" Can supplement a tag in a command-line.
set wildoptions=tagfile


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

"---------------------------------------------------------------------------
" マウスに関する設定:
"
" ターミナルでマウスを使用できるようにする
set mouse=a
set ttymouse=sgr

"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
"set nobackup
set backup
set backupdir=~/.vim/backup

" スワップファイル作らない
set noswapfile

" UNDOファイルフォルダ設定
set undodir=~/.vim/undo
set undofile

"ファイル保存の初期ディレクトリをバッファファイル位置に設定
set browsedir=buffer

" 常に開いているファイルと同じディレクトリをカレントディレクトリにする
augroup group_vimrc_cd
  autocmd!
  autocmd BufEnter * execute ":lcd " . (isdirectory(expand("%:p:h")) ? expand("%:p:h") : "")
augroup END

" 自動的にクリップボードへ
set clipboard=unnamed
"set clipboard=unnamed,autoselect
"set clipboard=unnamedplus

" クリップボードからペーストする時だけインデントしないよう
if &term =~ "xterm"
	let &t_SI .= "\e[?2004h"
	let &t_EI .= "\e[?2004l"
	let &pastetoggle = "\e[201~"

	function XTermPasteBegin(ret)
		set paste
		return a:ret
	endfunction

	inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" Grep設定
" Use vimgrep.
"set grepprg=internal
" Use grep.
"set grepprg=grep\ -nH
"set grepprg=grep


"---------------------------------------------------------------------------
" キーマッピングに関する設定:
"

" p, P入れ替え
noremap p P
noremap P p

" C-@ の誤爆防止
inoremap <C-@> <ESC>

" 検索のハイライト
if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" 検索のハイライトを消す
nnoremap <Esc><Esc> :nohlsearch<CR>

" CTRL-V and SHIFT-Insert are Paste without Normal mode.
noremap! <C-v> <C-R>*

" 検索後画面の中心に
nnoremap n nzz
nnoremap N Nzz

" タブの移動
nnoremap <silent> <C-l> :tabnext<CR>
nnoremap <silent> <C-h> :tabprevious<CR>

" バッファの移動
nnoremap <SPACE>   :bnext<CR>


noremap x "_x
noremap <leader>d "_d


set diffopt+=vertical

"-------------------------------------------------------------------------------
" タグ関連 Tags
"-------------------------------------------------------------------------------
" tagsファイルを検索する際に、カレントバッファから上に辿って探す
set tags+=./tags;

