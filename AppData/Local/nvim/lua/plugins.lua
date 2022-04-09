vim.cmd([[packadd packer.nvim]])

vim.cmd([[
augroup RecompilePlugins
autocmd! BufWritePost plugins.lua let g:plugins_recompile=1 | source <afile> | PackerCompile
augroup END
]])


local function setup_packer(packer_bootstrap)
  require("packer").startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = {'julia', 'lua'},
          highlight = { enable = true},
          incremental_selection = { enable = false },
          indent = { enable = false },
          matchup = { enable = true }
        }
      end
    }

    use({
      "folke/which-key.nvim",
      config = function()
        local ws = require("which-key")
        ws.setup({
          operators = {
            ["<Leader>y"] = "Yank to clipboard",
          },
        })
        ws.register({
          ["<"] = { "<gv", "Deindent lines" },
          [">"] = { ">gv", "Indent lines" },
          ["<Leader>y"] = "Yank to clipboard",
        }, {
          mode = "v",
        })

        ws.register({
          ["cn"] = { "*``cgn", "Search and replace" },
          ["cN"] = { "*``cgN", "Search and replace backwards" },
          J = { "mzJ`z", "Join lines" },
          ["<Leader>y"] = "Yank to clipboard",
        })
      end,
    })

    use({
      "kyazdani42/nvim-tree.lua",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        -- vim.g.nvim_tree_git_hl = 1
        vim.g.nvim_tree_group_empty = 1

        require("nvim-tree").setup({
          hijack_netrw = true,
          diagnostics = {
            enable = true,
          },
          view = {
            number = true,
            relativenumber = true,
            mappings = {
              list = {
                {
                  key = { "<C-e>", "o", "<CR>" },
                  action = "edit_in_place",
                },
                {
                  key = "<C-v>",
                  action = "split_right",
                  action_cb = function(node)
                    vim.cmd("vsplit " .. vim.fn.fnameescape(node.absolute_path))
                  end,
                },
                {
                  key = "<C-x>",
                  action = "split_bottom",
                  action_cb = function(node)
                    vim.cmd("split " .. vim.fn.fnameescape(node.absolute_path))
                  end,
                },
                {
                  key = "<C-t>",
                  action = "new_tab",
                  action_cb = function(node)
                    vim.cmd("tabnew " .. vim.fn.fnameescape(node.absolute_path))
                  end,
                },
              },
            },
          },
          actions = {
            change_dir = {
              enable = false,
            },
            open_file = {
              -- NOTE: prevent nvim-tree from re-appearing after opening a new window
              -- (changes the way autocommands are registered)
              quit_on_open = true,
            },
          },
        })
        -- NOTE: disable fixed nvim-tree width and height
        -- to allow creating splits naturally
        local winopts = require("nvim-tree.view").View.winopts
        winopts.winfixwidth = false
        winopts.winfixheight = false

        require("which-key").register({
          ["-"] = {
            function()
              local previous_buf = vim.api.nvim_get_current_buf()
              require("nvim-tree").open_replacing_current_buffer()
              require("nvim-tree").find_file(false, previous_buf)
            end,
            "NvimTree in place",
          },
        })
      end,
    })

    use 'github/copilot.vim'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'

    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    use 'JuliaEditorSupport/julia-vim'
    use 'andymass/vim-matchup'
    use 'rhysd/clever-f.vim'
    use 'tpope/vim-characterize'
    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    -- use 'tpope/vim-vinegar'

    use 'moll/vim-bbye'

    use 'lervag/vimtex'
    use {
      'nvim-lualine/lualine.nvim',
      config = function()
        require('lualine').setup {
          options = {
              icons_enabled = true,
              theme = 'enfocado',
              component_separators = { left = '', right = ''},
              section_separators = { left = '', right = ''},
              disabled_filetypes = {},
              always_divide_middle = true,
            },
            sections = {
              lualine_a = {'mode'},
              lualine_b = {'branch', 'diff', 'diagnostics'},
              lualine_c = {'filename'},
              lualine_x = {'encoding', 'fileformat', 'filetype'},
              lualine_y = {'progress'},
              lualine_z = {'location'}
            },
            inactive_sections = {
              lualine_a = {},
              lualine_b = {},
              lualine_c = {'filename'},
              lualine_x = {'location'},
              lualine_y = {},
              lualine_z = {}
            },
            tabline = {
              lualine_a = {'buffers'},
              lualine_b = {},
              lualine_c = {},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {'tabs'}
            },
            extensions = {}
        }
      end
    }

    use {  'wuelnerdotexe/vim-enfocado', branch = 'development',
    config = function()
      vim.g.clever_f_mark_char_color = "Underlined"
      vim.g.enfocado_style = "nature"
      vim.g.enfocado_plugins = {'all'}
      vim.g.enfocado_plugins = {
        'cmp',
        'copilot',
        'lsp',
        'matchup',
        'netrw',
        'packer',
        'treesitter',
      }
      vim.cmd([[
      augroup enfocado
        autocmd!
        autocmd VimEnter * ++nested colorscheme enfocado
      augroup end
      ]])
    end,
  }

  use 'kyazdani42/nvim-web-devicons'
  if packer_bootstrap then
    require("packer").sync()
  end
end)
end

if vim.g.plugins_recompile == 1 then
  setup_packer(false)
end

return setup_packer
