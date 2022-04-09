local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  -- virtual_text = true,
  signs = true,
  -- underline = true,
  severity_sort = true,
})

local nvim_lsp = require('lspconfig')
local ws = require('which-key')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr) -- {{{
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  ws.register({

    gD = { '<cmd>lua vim.lsp.buf.declaration()<CR>', "Description", buffer=bufnr },
    gd = { '<cmd>lua vim.lsp.buf.definition()<CR>', "Description", buffer=bufnr },
    K = { '<cmd>lua vim.lsp.buf.hover()<CR>', "Description", buffer=bufnr },
    gi = { '<cmd>lua vim.lsp.buf.implementation()<CR>', "Description", buffer=bufnr },
    [ "<C-k>" ] = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', "Description", buffer=bufnr },
    [ "<space>wa" ] = { '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', "Description", buffer=bufnr },
    [ "<space>wr" ] = { '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', "Description", buffer=bufnr },
    [ "<space>wl" ] = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', "Description", buffer=bufnr },
    [ "<space>D" ] = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', "Description", buffer=bufnr },
    [ "<space>rn" ] = { '<cmd>lua vim.lsp.buf.rename()<CR>', "Description", buffer=bufnr },
    [ "<space>ca" ] = { '<cmd>lua vim.lsp.buf.code_action()<CR>', "Description", buffer=bufnr },
    gr = { '<cmd>lua vim.lsp.buf.references()<CR>', "Description", buffer=bufnr },
    [ "<space>e" ] = { '<cmd>lua vim.diagnostic.open_float()<CR>', "Description", buffer=bufnr },
    [ "[d" ] = { '<cmd>lua vim.diagnostic.goto_prev()<CR>', "Description", buffer=bufnr },
    [ "]d" ] = { '<cmd>lua vim.diagnostic.goto_next()<CR>', "Description", buffer=bufnr },
    [ "<space>q" ] = { '<cmd>lua vim.diagnostic.setloclist()<CR>', "Description", buffer=bufnr },
    [ "<space>f" ] = { '<cmd>lua vim.lsp.buf.formatting()<CR>', "Description", buffer=bufnr },
  })

  ws.register({
    [ "," ] = {
      name = "LSP Commands",
      D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', "Go to declaration", buffer=bufnr, mode="n" },
      d = { '<cmd>lua vim.lsp.buf.definition()<CR>', "Go to definition", buffer=bufnr },
      h = { '<cmd>lua vim.lsp.buf.hover()<CR>', "Show hover info", buffer=bufnr },
      i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', "Go to implementation", buffer=bufnr },
      k = { '<cmd>lua vim.lsp.buf.signature_help<CR>', "Show signature help", buffer=bufnr },
      r = { '<cmd>lua vim.lsp.buf.references()<CR>', "Find references", buffer=bufnr },
      s = { '<cmd>lua vim.lsp.buf.document_symbol()<CR>', "Show symbols", buffer=bufnr },
      t = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', "Show type definition", buffer=bufnr },
      v = { '<cmd>lua vim.lsp.buf.code_action()<CR>', "Show code actions", buffer=bufnr },
      x = { '<cmd>lua vim.lsp.buf.execute_command()<CR>', "Execute command", buffer=bufnr },
    }
  })
end -- }}}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches

local cmp = require'cmp'

cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  },

  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
  },
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = { 'julials', 'pyright' } 
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities
  }
end
-- }}}
