nnoremap <leader>t :w<bar>3new<bar>0read !pytest<CR>gg
" Map the funtion to the leader f key
nnoremap <leader>f :Pytest function<CR>
" Run the function under the cursor using pytest as makeprg

set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set colorcolumn=80
set expandtab
set autoindent
set fileformat=unix

" Syntax tweaks for Python files
" Adds folding for classes and functions

" if &foldmethod != 'diff' && &ft == 'python'
"   setlocal foldmethod=expr
" endif
" if &ft == 'python'
"   setlocal foldexpr=PythonFoldLevel(v:lnum)
" endif
" function! PythonFoldLevel(lineno)
"   " very primitive at the moment, but actually works quite well in practice
"   let line = getline(a:lineno)
"   if line == ''
"     let line = getline(a:lineno + 1)
"     if line =~ '^\(def\|class\)\>'
"       return 0
"     elseif line =~ '^@'
"       return 0
"     elseif line =~ '^    \(def\|class\|#\)\>'
"       return 1
"     else
"       let lvl = foldlevel(a:lineno + 1)
"       return lvl >= 0 ? lvl : '-1'
"     endif
"   elseif line =~ '^\(def\|class\)\>'
"     return '>1'
"   elseif line =~ '^@'   " multiline decorator maybe
"     return '>1'
"   elseif line =~ '^    \(def\|class\)\>'
"     return '>2'
"   elseif line =~ '^[^] #)]'
"     " a non-blank character at the first column stops a fold, except
"     " for '#', so that comments in the middle of functions don't break folds,
"     " and ')', so that I can have multiline function signatures like
"     "
"     "     def fn(
"     "         arg1,
"     "         arg2,
"     "     ):
"     "         ...
"     return 0
"   elseif line =~ '^# \|^#$' " except when they're proper comments and not commentd-out code (for which I use ##
"     return 0
"   elseif line =~ '^    [^ )]' " end method folds except watch for black-style signatures
"     return 1
"   else
"     let lvl = foldlevel(a:lineno - 1)
"     return lvl >= 0 ? lvl : '='
"   endif
" endf
function! PythonFoldLevel(lineno)
  let line = getline(a:lineno)
  let indent_level = indent(a:lineno)

  " If the line is empty, look ahead (like your original)
  if line =~ '^\s*$'
    let next_line = getline(a:lineno + 1)
    " If end of file, just inherit
    if next_line == ''
      return '='
    endif
    " Check next line to decide
    if next_line =~ '^\s*\(def\|class\|import\|from\)\>'
      return 0
    elseif next_line =~ '^\s*@'
      return 0
    elseif next_line =~ '^\s*\("""\|\'\'\'\)'
      return 0
    elseif next_line =~ '^\s*#'
      return 0
    elseif indent(a:lineno + 1) > 0
      return 1
    else
      return '='
    endif
  endif

  " Handle multiline strings
  if line =~ '^\s*\("""\|\'\'\'\)'
    return '>1'
  endif

  " Top-level definitions
  if indent_level == 0
    if line =~ '^\s*@'
      " Decorators start a fold of their own
      return '>1'
    elseif line =~ '^\s*\(def\|class\)\>'
      " Definitions start a fold
      return '>1'
    elseif line =~ '^\s*\(import\|from\)\>'
      " Imports start a fold
      return '>1'
    elseif line =~ '^\S'
      " Other non-indented text ends fold
      return '0'
    endif
  endif

  " Nested decorators
  if indent_level > 0 && line =~ '^\s*@'
    return '>2'
  endif

  " Nested definitions
  if indent_level > 0 && line =~ '^\s*\(def\|class\)\>'
    return '>2'
  endif

  " Comments don't end folds
  if line =~ '^\s*#'
    return '='
  endif

  " Everything else inherits prior line's fold
  return '='
endfunction
