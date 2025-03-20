" Open a terminal running an IPython kernel
if has('win32') || has('win64')
    " Windows : Start Spyder Console in the background
    command! StartSpyderConsole :silent !start /b python -m spyder_kernels.console
else 
    " Linux/macOS: Start Spyder Console in the background
    command! StartSpyderConsole :silent !nohup python -m spyder_kernels.console >/dev/null &2>1 & 
endif

" Function to extract the connection file and connect using Jupyter console
function! ConnectIPython()
    let l:kernel_file = system('Powershell -Command "(Get-ChildItem C:\Users\emmet\AppData\Roaming\jupyter\runtime\*.json | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName"')
    let l:kernel_file = substitute(l:kernel_file, '\n', '', '')

    if l:kernel_file == ''
        echo "No IPython kernel found."
        return
    endif

    " Open a new terminal buffer and connect to the kernel
    execute "terminal jupyter console --existing " . l:kernel_file
endfunction

" Map keys to start and connect
nnoremap <leader>ik :StartSpyderConsole<CR>
nnoremap <leader>ic :call ConnectIPython()<CR>

function! RunCellInTerminal()
    " Count occurrences of '#%%' before the current cursor position
  let l:n = searchcount({'pattern': '^#%%', 'pos': getpos('.')[1:-1]})['current']

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
    let l:command = '%runcell -i ' . l:n . ' ' . expand('%:p')
    let l:command = substitute(l:command, '\\', '\\\\', 'g')
    call term_sendkeys(l:term_buf, l:command)
    call term_sendkeys(l:term_buf, "\<CR>")
endfunction

" function to send the current file to the terminal
function RunFileInTerminal()
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
    let l:command = 'include ' . expand('%:p')
    let l:command = substitute(l:command, '\\', '\\\\', 'g')
    call term_sendkeys(l:term_buf, l:command)
    call term_sendkeys(l:term_buf, "\<CR>")
endfunction

" Map the function to <leader>r for easy execution
nnoremap <leader>c :call RunCellInTerminal()<CR>
