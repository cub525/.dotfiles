" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

if has('win32') || has('win64')
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
  set undodir=~/vimtmp/.undo/
  set backupdir=~/vimtmp/.backup/
  set directory=~/vimtmp/.swp/
endif

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction


call plug#begin()
" List your plugins here
  Plug 'vim-python/python-syntax'
  Plug 'andymass/vim-matchup'
  Plug 'rhysd/clever-f.vim'
  Plug 'github/copilot.vim', { 'on': 'Copilot' }
  Plug 'tpope/vim-characterize'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-sensible'
  Plug 'wuelnerdotexe/vim-enfocado'
  Plug 'leafOfTree/vim-svelte-plugin'
  Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
  Plug 'JuliaEditorSupport/julia-vim'
  " Plug 'mhinz/vim-startify'
call plug#end()

set termguicolors
colorscheme enfocado
let g:enfocado_style = 'nature' " Available: `nature` or `neon`.
set background=dark

let g:pymode_rope_goto_definition_bind = '<C-c>g'
let g:pymode_folding = 0
let g:pytest_test_dir = ""
let g:pytest_test_file = "test_*.py"
let g:pytest_executable = "pytest"
let g:python_highlight_all = 1

let g:clever_f_fix_key_direction = 1

augroup py
  autocmd!
  autocmd BufNewFile  *.py	0r ~\.vim\skeleton\template.py
augroup end

nnoremap <silent> <leader>d :bprevious<bar>split<bar>bnext<bar>bdelete<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :w<bar>so $MYVIMRC<CR>
" TODO make these functions that can work with directories as well
nnoremap <leader>ef :execute ":vsplit " .. expand('~') .. "\\vimfiles\\ftplugin\\" .. &filetype .. ".vim"<CR>
nnoremap <leader>sf :execute ":so " .. expand('~') .. "\\vimfiles\\ftplugin\\" .. &filetype .. ".vim"<CR>

set foldmethod=manual
set nowrap
set number
set expandtab
set tabstop=2
set shiftwidth=2
if has("gui_running")
  set guifont=Cascadia\ Mono:h12
endif
