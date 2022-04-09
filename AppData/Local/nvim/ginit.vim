" Nerd fonts aren't perfectly monospace
GuiTabline 0
GuiFont! FiraCode\ Nerd\ Font:h14
set conceallevel=0

nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
