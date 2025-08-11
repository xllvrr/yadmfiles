-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Basic Neovim options
now(function()
  vim.cmd.colorscheme("minispring")

  vim.g.mapleader = ' '
  vim.g.maplocalleader = '\\'

  vim.opt.clipboard = 'unnamedplus'

  vim.opt.number = true
  vim.opt.relativenumber = true

  vim.opt.expandtab = true
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.smartindent = true

  vim.opt.wrap = false

  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  vim.opt.hlsearch = false
  vim.opt.incsearch = true

  vim.opt.termguicolors = true

  vim.opt.undofile = true
  vim.opt.backup = false
  vim.opt.swapfile = false

  vim.opt.splitbelow = true
  vim.opt.splitright = true
end)

-- Install and configure mini.nvim plugins
now(function()
  require('mini.statusline').setup()
  require('mini.cursorword').setup()
  require('mini.pairs').setup()
  require('mini.surround').setup()
  require('mini.comment').setup()
  require('mini.indentscope').setup()
  require('mini.move').setup()
  require('mini.align').setup()
  require('mini.diff').setup()
  require('mini.git').setup()
  require('mini.extra').setup()
  require('mini.files').setup()
  require('mini.fuzzy').setup()
  require('mini.visits').setup()
  require('mini.hipatterns').setup()
  require('mini.icons').setup()
  require('mini.jump').setup()
  require('mini.keymap').setup()
  require('mini.notify').setup()
  require('mini.operators').setup()
  require('mini.pick').setup()
  require('mini.snippets').setup()
  require('mini.trailspace').setup()
end)

-- LSP Configuration
later(function()
  add('neovim/nvim-lspconfig')

  -- Treesitter
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  -- Possible to immediately execute code which depends on the added plugin
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc', 'python', 'r' },
    highlight = { enable = true },
  })

  -- Common LSP keymaps
  local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
  end

  -- Python LSP
  vim.lsp.enable('basedpyright')

  -- R LSP
  vim.lsp.enable('r_language_server')

  -- Lua LSP
  vim.lsp.enable('lua_ls')
  vim.lsp.config('lua_ls', {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if
          path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = {
            'lua/?.lua',
            'lua/?/init.lua',
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME
          }
        }
      })
    end,
    settings = {
      Lua = {}
    }
  })

end)

-- Setup for blink
later(function()
  add({
    source = 'saghen/blink.cmp',
    depends = {'rafamadriz/friendly-snippets', 'echasnovski/mini.snippets'},
  })
  require('blink.cmp').setup({
    fuzzy = { implementation = "lua" },
    snippets = { preset = 'mini_snippets' },
    sources = {
      default = { 'lsp', 'buffer', 'snippets', 'path' },
    },
    keymap = {
      ["<Tab>"] = {
        function(cmp)
          local has_words_before = function()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            if col == 0 then
              return false
            end
            return vim.api.nvim_get_current_line():sub(col, col):match("%s") == nil
          end
          if has_words_before() then
            return cmp.select_next()
          end
        end,
        "snippet_forward",
        "fallback",
      },

      ["<S-Tab>"] = { "insert_prev", "snippet_backward", "fallback" },
      ["<CR>"] = { "select_and_accept", "fallback" },
    },
  })
end)

-- Key mappings
later(function()
  -- File explorer
  vim.keymap.set('n', '<leader>E', function() require('mini.files').open() end, { desc = 'Open file explorer at root' })
  vim.keymap.set('n', '<leader>e', function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end, { desc = 'Open file explorer in current direction' })

  -- Mini.pick mappings
  vim.keymap.set('n', '<leader>ff', function() require('mini.pick').builtin.files() end, { desc = 'Find files' })
  vim.keymap.set('n', '<leader>fg', function() require('mini.pick').builtin.grep_live() end, { desc = 'Live grep' })
  vim.keymap.set('n', '<leader>fb', function() require('mini.pick').builtin.buffers() end, { desc = 'Find buffers' })
  vim.keymap.set('n', '<leader>fh', function() require('mini.pick').builtin.help() end, { desc = 'Find help' })

  -- Git mappings
  vim.keymap.set('n', '<leader>gs', function() require('mini.git').show_at_cursor() end, { desc = 'Git show at cursor' })

  -- Trailspace
  vim.keymap.set('n', '<leader>tw', function() require('mini.trailspace').trim() end, { desc = 'Trim whitespace' })

  -- Visits
  vim.keymap.set('n', '<leader>vv', function() require('mini.pick').builtin.visit_paths() end, { desc = 'Visit paths' })

  -- Clear search highlight
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Better window navigation
  vim.keymap.set('n', '<C-h>', '<C-w>h')
  vim.keymap.set('n', '<C-j>', '<C-w>j')
  vim.keymap.set('n', '<C-k>', '<C-w>k')
  vim.keymap.set('n', '<C-l>', '<C-w>l')

  -- Resize windows
  vim.keymap.set('n', '<C-Up>', ':resize +2<CR>')
  vim.keymap.set('n', '<C-Down>', ':resize -2<CR>')
  vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
  vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')

  -- Buffer navigation
  vim.keymap.set('n', '<S-l>', ':bnext<CR>')
  vim.keymap.set('n', '<S-h>', ':bprevious<CR>')
end)
