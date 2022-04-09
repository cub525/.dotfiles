-- Settings {{{
local g = vim.g
local cmd = vim.cmd
local o, wo, bo = vim.o, vim.wo, vim.bo
local utils = require 'config.utils'
local opt = utils.opt
local autocmd = utils.autocmd
local map = utils.map


-- Provider loading skip
g.loaded_python_provider = 0
g.python_host_prog = [[C:\Users\janih\anaconda3\envs\python2\python.exe]]
g.python3_host_prog = [[C:\Users\janih\anaconda3\python.exe]]
g.netrw_fastbrowse=2

-- Disable built-in plugins
local disabled_built_ins = {
  'gzip',
  'man',
  'matchit',
  'matchparen',
  'tarPlugin',
  'tar',
  'zipPlugin',
  'zip',
}

for i = 1, 8 do
  g['loaded_' .. disabled_built_ins[i]] = 1
end

-- Settings
local buffer = { o, bo }
local window = { o, wo }
opt('number', true, window)
opt('relativenumber', true, window)
opt('ignorecase', true)
opt('hlsearch', true)
opt('incsearch', true)
opt('wrap', false)
opt('swapfile', false)
opt('laststatus', 2)
opt('lazyredraw', true)
opt('showmatch', true)
opt('undofile', true, buffer)
opt('joinspaces', false)
opt('synmaxcol', 500, buffer)
opt('signcolumn', 'yes:1', window)

vim.o.splitbelow = true
vim.o.splitright = true

vim.cmd([[
  set nrformats-=octal
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  set sessionoptions+=localoptions
]])

vim.o.list = true
-- Source: https://github.com/tjdevries/cyclist.vim
vim.opt.listchars = {
  ["tab"] = "» ",
  ["trail"] = "·",
  ["extends"] = "<",
  ["precedes"] = ">",
  ["conceal"] = "┊",
  ["nbsp"] = "␣",
}

opt('mouse', 'nivh')
opt('scrolloff', 1)
opt('sidescrolloff', 5)
opt('termguicolors', true)
opt('smartcase', true)
opt('showmode', false)
opt('hidden', true)
-- opt('tabstop', 2, buffer)
-- opt('shiftwidth', 2, buffer)
opt('softtabstop', 0, buffer)
opt('expandtab', true, buffer)
opt('smarttab', true)
opt('smartindent', true, buffer)
opt('shortmess', o.shortmess .. 'c')
--- }}}

-- Autocmd {{{
-- )
autocmd('misc_aucmds', {
  [[BufWinEnter * checktime]],
  [[TextYankPost * silent! lua vim.highlight.on_yank()]],
}, true)

autocmd('fold_init_lua', {
  [[BufEnter init.lua setlocal foldmethod=marker foldlevelstart=0]]
}, true)
--  }}}

vim.cmd([[
augroup enfocado
  autocmd!
  autocmd VimEnter * ++nested colorscheme enfocado
augroup end
]])

require("plugins")(packer_bootstrap)
require("lspoptions")

-- my remappings {{{ 
local wk = require'which-key'

map("i", ",j", "<Esc>", {silent = true})
map("v", ",j", "<Esc>", {silent = true})

map("i", "<C-J>", 'copilot#Accept("\\<CR>")', {silent = true, script = true, noremap = true, expr = true} )
g.copilot_no_tab_map = true
g.mapleader = "\\"

map( "n", "<leader>q", "<Cmd>quitall<CR>", {noremap = true, silent = true} )
map( "n", "<leader>x", "<Cmd>mksession! | xall!<CR>", {noremap = true, silent = true } )
map( "n", "<C-s>", "R<CR><Esc>", { noremap = true, silent = true } )
map( "n", "<leader>ev", ":e $MYVIMRC<cr>", { noremap = true, silent = true } )
map( "n", "<leader>sv", ":w | source $MYVIMRC<cr>", { noremap = true, silent = true } )
map( 'n', '<leader>w', '<cmd>w<cr>', { silent = true })
map( "n", "Y", "y$", {noremap = true})
map( "n", "<leader>n", "<cmd>nohlsearch<cr>", { noremap = true, silent = true } )
map( 'n', '<leader>b', '<cmd>Bdelete!<CR>', { noremap = true })
map( 'n', '<leader>m', '<cmd>make<CR>', { noremap = true })
map( 'n', '<leader>l', '<cmd>LspInfo<CR>', { noremap = true })
map( 't', '<a-[>', '<c-\\><c-n><cmd>bprev<CR>', { noremap = true })
map( 't', '<a-]>', '<c-\\><c-n><cmd>bnext<CR>', { noremap = true })
map( 'n', '<a-[>', '<cmd>bprev<CR>', { noremap = true })
map( 'n', '<a-]>', '<cmd>bnext<CR>', { noremap = true })
map( 'n', '<A-h>', '<c-w><', { noremap = true })
map( 'n', '<A-j>', '<c-w>-', { noremap = true })
map( 'n', '<A-k>', '<c-w>+', { noremap = true })
map( 'n', '<A-l>', '<c-w>>', { noremap = true })
map("n", "<Leader>y", '"+y', { noremap = true })
map("v", "<Leader>y", '"+y', { noremap = true })
-- }}}
