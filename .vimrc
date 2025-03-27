" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

if has('win32') || has('win64')
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
  set undodir=~/vimtmp/.undo/
  set backupdir=~/vimtmp/.backup/
  set directory=~/vimtmp/.swp/
endif

call plug#begin()
  " List your plugins here
  Plug 'andymass/vim-matchup'
  Plug 'rhysd/clever-f.vim'
  Plug 'tpope/vim-characterize'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-sensible'
  Plug 'wuelnerdotexe/vim-enfocado'
  Plug 'github/copilot.vim', { 'on': 'Copilot' }
  Plug 'leafOfTree/vim-svelte-plugin', { 'for': 'svelte' }
  Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
  Plug 'vim-python/python-syntax', { 'for': 'python' }
  Plug 'JuliaEditorSupport/julia-vim', { 'for': 'julia' }
  " Plug 'mhinz/vim-startify'
call plug#end()

set termguicolors
colorscheme enfocado
let g:enfocado_style = 'nature' " Available: `nature` or `neon`.
set background=dark

let g:pymode_python = 'python3'
let g:pymode_virtualenv = 0
let g:pymode_rope_goto_definition_bind = '<C-c>g'
let g:pymode_folding = 0
let g:pytest_test_dir = ""
let g:pytest_test_file = "test_*.py"
let g:pytest_executable = "pytest"
let g:python_highlight_all = 1

let g:clever_f_fix_key_direction = 1

augroup py
  autocmd!
  autocmd BufNewFile  *.py	0r ~/.vim/skeleton/template.py
augroup end

nnoremap <silent> <leader>d :bprevious<bar>split<bar>bnext<bar>bdelete<CR>
nnoremap <silent> <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>sv :w<bar>so $MYVIMRC<CR>
" TODO make these functions that can work with directories as well
nnoremap <silent> [w :tabprevious<CR>
vnoremap <silent> [w :tabprevious<CR>
tnoremap <silent> [w :tabprevious<CR>
nnoremap <silent> ]w :tabnext<CR>
vnoremap <silent> ]w :tabnext<CR>
tnoremap <silent> ]w :tabnext<CR>
nmap <silent> g] g
vmap <silent> g] g

function! OpenFileTypeDirectoryOrVimFile()
  " Get the current filetype
  let l:filetype = &filetype
  if empty(l:filetype)
    echo "No filetype detected!"
    return
  endif

  " Construct the path to the filetype directory in $VIM/ftplugin/
  let l:ft_dir = expand('~/.vim/ftplugin/' . l:filetype)

  if isdirectory(l:ft_dir)
    " Open netrw in a new vertical split at that directory
    execute 'Vexplore ' . l:ft_dir
  else
    " Open the filetype.vim file instead
    execute 'split ' . expand('~/.vim/ftplugin/' . l:filetype . '.vim')
  endif
endfunction

nnoremap <silent> <leader>ef :call OpenFileTypeDirectoryOrVimFile()<CR>
nnoremap <silent> <leader>sf :edit %<CR>

set foldmethod=manual
set nowrap
set number
set expandtab
set tabstop=2
set shiftwidth=2
if has("gui_running")
  set guifont=Cascadia\ Mono:h12
endif
