set makeprg=julia\ %
set autowrite

set errorformat=%E%t%*[^:]:\ %m,%-C%p^,%C%*[^:]:\ %m,%+GStacktrace:,%-G%.%#
set errorformat+=%EERROR:\ %m,%C%f:%l,%+GStacktrace:,%-G%.%#
set errorformat+=%W%f:%l:\ %m

function! RunJuliaTests()
    " Save current errorformat
    let s:old_errorformat = &errorformat

    " Set errorformat for Julia test failures
    let &errorformat = 
        \ '%ETest Failed at %f:%l,%C  Expression: %m,%+C  Expected: %m,%+C  Got: %m'

    " Run Julia tests and capture output
    " cgetexpr system('julia --color=no -e "using Pkg; Pkg.test()"')
    cgetexpr system('julia --color=no runtests.jl')

    " Restore original errorformat
    let &errorformat = s:old_errorformat

    " Open quickfix list
    copen
endfunction


function RunJulia()
  " write the current buffer
  write
  " run the current buffer
  cgetexpr system('julia --color=no ' .. expand('%'))
  " open the quickfix window
  copen
endfunction

" function to send the current file to the terminal
function JlRunFileInTerminal()
    write
    " Find the terminal buffer
    let l:term_buf = -1
    for l:buf in getbufinfo()
        if getbufvar(l:buf.bufnr, '&buftype') ==# 'terminal'
            let l:term_buf = l:buf.bufnr
            break
        endif
    endfor

    " If no terminal buffer found, print error and return
    if l:term_buf == -1
        echo "No terminal buffer found!"
        return
    endif

    " Send the command to the terminal
    let l:command = 'include("' . expand('%:t') . '")'
    let l:command = substitute(l:command, '\\', '\\\\', 'g')
    call term_sendkeys(l:term_buf, l:command)
    call term_sendkeys(l:term_buf, "\<CR>")
endfunction


nnoremap <leader>t :call RunJuliaTests()<CR>
nnoremap <leader>r :call RunJulia()<CR>
nnoremap <leader>ir :call JlRunFileInTerminal()<CR>
nnoremap <leader>it :execute 'terminal julia'<CR>
