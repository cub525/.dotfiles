" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

if has('win32') || has('win64')
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

set undodir=~/vimtmp/.undo/
set backupdir=~/vimtmp/.backup/
set directory=~/vimtmp/.swp/

call plug#begin()
  " List your plugins here
  Plug 'mattn/emmet-vim'
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
  " Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
  Plug 'vim-python/python-syntax', { 'for': 'python' }
  Plug 'tmhedberg/SimpylFold', { 'for': 'python' }
  Plug 'JuliaEditorSupport/julia-vim', { 'for': 'julia' }
  " Plug 'mhinz/vim-startify'
call plug#end()

" set termguicolors
colorscheme enfocado
let g:enfocado_style = 'nature' " Available: `nature` or `neon`.
set background=dark

highlight TabLine   guibg=Black guifg=White

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


function! SuggestOneCharacter()
  let _ = copilot#Accept("")
  let text = copilot#TextQueuedForInsertion()
  return text ==# '' ? '' : text[0]
endfunction

function! SuggestOneWord()
  let _ = copilot#Accept("")
  let text = copilot#TextQueuedForInsertion()
  let match = matchstr(text, '^\s*\zs\S\+')
  return match
endfunction

function! SuggestOneLine()
  let _ = copilot#Accept("")
  let text = copilot#TextQueuedForInsertion()
  let line = matchstr(text, '^\s*\zs\S\+')
  return line
endfunction


" Keybindings (Insert mode expressions)
imap <expr> <C-l> SuggestOneWord()
imap <expr> <C-Left> SuggestOneCharacter()
imap <expr> <C-S-l> SuggestOneLine()

nnoremap <silent> <leader>ef :call OpenFileTypeDirectoryOrVimFile()<CR>
nnoremap <silent> <leader>sf :edit %<CR>
nnoremap <silent> Y y$

set backupcopy=yes
set foldmethod=manual
set clipboard=unnamed
set nowrap
set number
set expandtab
set tabstop=2
set shiftwidth=2
" if windows and has gui running
if has("gui_running") && has("win32")
  set guifont=Cascadia\ Mono:h12
endif
