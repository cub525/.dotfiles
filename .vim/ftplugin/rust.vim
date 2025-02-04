compiler cargo
set makeprg=cargo\ test\ --\ --include-ignored
nnoremap <silent> <leader>b :silent! make<CR>
set autowrite
" " TODO set up function to do build and test, with default make being build,
" " and testing can be activated by <leader>b

" " TODO create good error parsing, hopefully multi line
let &efm = ''
" " Random non issue stuff
let &efm .= '%-G%.%#aborting due to previous error%.%#,'
let &efm .= '%-G%.%#test failed, to rerun pass%.%#,'

" " Capture enter directory events for doc tests
let &efm .= '%D%*\sDoc-tests %f%.%#,'

" Doc Tests
" TODO Add pattern for the tests status line %I
let &efm .= '%E---- %f - %o (line %l) stdout ----,'
let &efm .= '%Cerror%m,'
let &efm .= '%-Z%*\s--> %f:%l:%c,'

" Unit tests && `tests/` dir failures
" This pattern has to come _after_ the doc test one
" TODO Add pattern for the tests status line %I
let &efm .= '%E---- %o stdout ----,'
let &efm .= "%Cthread '%m' panicked at %.%#,"
" let &efm .= '%Cthread %.%# panicked at ,'
let &efm .= '%+C%*\sleft: %.%#,'
let &efm .= '%+C%*\sright: %.%#,'
let &efm .= '%Z,'
let &efm .= '%+Itest result: %.%#,'
" Compiler Errors and Warnings
let &efm .= '%Eerror:%m,'
let &efm .= '%Eerror[E%n]%m,'
let &efm .= '%Wwarning: %m,'
let &efm .= '%Z,'
let &efm .= '%C%*\s--> %f:%l:%c,'
let &efm .= '%C%*\s|%*\s%*\^ %m,'
let &efm .= '%+Chelp:%.%#,'
let &efm .= '%C%.%#,'
