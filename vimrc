" Initialize:"{{{
"
source $VIMRUNTIME/defaults.vim

scriptencoding utf-8
""""""""""""""""""""""""""""""
"内部エンコーディングの設定
""""""""""""""""""""""""""""""
set encoding=utf-8
set termencoding=utf-8


" leaderを,に変更
let mapleader=","

"------------------------------------
" neobundle.vim
"------------------------------------
if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.vim/dein')
    call dein#begin('~/.vim/dein')

    call dein#load_toml("~/dotfiles/plugin/plugins.toml", {'lazy': 0})
    call dein#load_toml("~/dotfiles/plugin/lazy.toml",    {'lazy': 1})

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on


"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_vimrc_exampleに非0な値を設定しておけばインクルードはしない。
if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  if &guioptions !~# "M"
    " vimrc_example.vimを読み込む時はguioptionsにMフラグをつけて、syntax on
    " やfiletype plugin onが引き起こすmenu.vimの読み込みを避ける。こうしない
    " とencに対応するメニューファイルが読み込まれてしまい、これの後で読み込
    " まれる.vimrcでencが設定された場合にその設定が反映されずメニューが文字
    " 化けてしまう。
    set guioptions+=M
    source $VIMRUNTIME/vimrc_example.vim
    set guioptions-=M
  else
    source $VIMRUNTIME/vimrc_example.vim
  endif
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
"  let g:solarized_bold=0    "default value is 1
"  let g:solarized_italic=0  "default value is 1
syntax enable
set background=dark
colorscheme solarized8

if has("termguicolors")
  set termguicolors
endif


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

"---------------------------------------------------------------------------
" キーマッピングに関する設定:
"


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


