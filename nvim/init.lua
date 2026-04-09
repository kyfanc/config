local vim = vim -- suppress lsp warnings

-- Leader key configuration
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core editor settings
-- Reload file when changed externally
vim.opt.autoread = true
-- Backspace behavior
vim.opt.backspace = "indent,eol,start"
-- Use system clipboard
vim.opt.clipboard = "unnamedplus"
-- Visual guide at 100 columns
vim.opt.colorcolumn = "100"
-- Use spaces instead of tabs
vim.opt.expandtab = true
-- Indent width for operations
vim.opt.shiftwidth = 2
-- Spaces per tab in insert mode
vim.opt.softtabstop = 2
-- Display width of tabs
vim.opt.tabstop = 2
-- Keep cursor centered with 2 line padding
vim.opt.scrolloff = 2
-- Disable swap files
vim.opt.swapfile = false
-- Persist undo history
vim.opt.undofile = true

-- Search behavior
-- Case-insensitive search
vim.opt.ignorecase = true
-- Case-sensitive if uppercase used
vim.opt.smartcase = true
-- Highlight search results
vim.opt.hlsearch = true

-- UI/Display
-- Show absolute line numbers
vim.opt.number = true
-- Show relative line numbers
vim.wo.relativenumber = true
-- Always show sign column (LSP, git)
vim.opt.signcolumn = "yes"
-- Show whitespace characters
vim.opt.list = true
-- Whitespace markers
vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'
-- Disable line wrapping
vim.opt.wrap = false
-- Rounded borders on windows
vim.opt.winborder = "rounded"
-- Open splits on right
vim.opt.splitright = true
-- Open splits below
vim.opt.splitbelow = true

-- Completion menu
-- Completion behavior
vim.opt.completeopt = { "menuone", "noselect", "popup" }
-- Completion menu height
vim.opt.pumheight = 15
-- Don't auto-select completion
vim.o.completeopt = "menuone,noselect"

-- Mouse and input
-- Enable mouse in all modes
vim.opt.mouse = "a"
-- Shell for commands
vim.opt.shell = "/bin/bash"
-- ms to wait for mapped sequence
vim.o.timeoutlen = 300

-- Folding and other options
-- Open all folds by default
vim.opt.foldlevelstart = 99
-- Fold based on indentation
vim.opt.foldmethod = "indent"
-- Command line completion
vim.opt.wildmode = { "lastused", "full" }
-- Ignore patterns
vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'
-- Visual bell instead of sound
vim.opt.vb = true

-- Colors and diagnostics
-- Enable 24-bit color
vim.o.termguicolors = true
-- Dark theme (or "light")
vim.o.background = "dark"
-- ms for swap file and CursorHold
vim.o.updatetime = 250
-- Show diagnostics inline
vim.diagnostic.config({ virtual_text = true })

-- LSP and autocmds
local autocmd = vim.api.nvim_create_autocmd

-- Disable automatic comment continuation on new lines
autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- LSP configuration
local function setup_lsp()
  -- Enable language servers for various file types
  vim.lsp.enable({
    "gopls",       -- Go
    "lua_ls",      -- Lua
    "yamlls",      -- YAML
    "marksman",    -- Markdown
    "terraformls", -- Terraform
    "bashls",      -- Bash
    "ts_ls",       -- TypeScript/JavaScript
    "helm_ls",     -- Helm templates
  })

  -- Auto-enable TreeSitter for Helm files
  autocmd("FileType", {
    pattern = { "helm" },
    callback = function() vim.treesitter.start() end,
  })

  -- temp fix for terraform-ls
  -- https://github.com/neovim/neovim/issues/36257

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.server_capabilities and client.name == 'terraformls' then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end,
  })
end

-- Package setup (nvim 0.12 native pack mechanism)
-- Color scheme
-- LSP configuration
-- Minimal plugins collection
-- Syntax highlighting
-- Utility library
-- Editing features
-- Git integration
-- Keybinding helper
-- Helm LSP integration
vim.pack.add({
  "https://github.com/ellisonleao/gruvbox.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/iwe-org/iwe.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/qvalentin/helm-ls.nvim",
})

-- Initialize LSP servers
setup_lsp()

-- Toggle comments with gc
require("mini.comment").setup()
-- Word completion
require("mini.completion").setup()
-- Inline diffs
require("mini.diff").setup()
-- Extras especially for additional pickers features
require('mini.extra').setup({})
-- File browser
require("mini.files").setup()
-- Git operations
require("mini.git").setup()
-- Move selection with Alt+hjkl
require("mini.move").setup()
-- Fuzzy finder
require("mini.pick").setup()
-- Statusline
require("mini.statusline").setup()
-- Add/delete/change surrounds with sa/sd/sr
require("mini.surround").setup()
-- Tab line
require("mini.tabline").setup()
-- Highlight trailing whitespace
require("mini.trailspace").setup()

-- Git signs in sign column
require("gitsigns").setup()
-- Improved word/expression editing
require("iwe").setup()
-- Install parsers for syntax highlighting
require("nvim-treesitter").install({
  "helm",
  "gotmpl",
  "yaml",
})

-- Helm language server configuration
require("helm-ls").setup {
  settings = {
    ["helm-ls"] = {
      yamlls = {
        path = "yaml-language-server",
      }
    }
  }
}

-- Color scheme
vim.cmd("colorscheme gruvbox")

-- Core keybindings
-- Space as leader
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- Clear search highlight
vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')

-- Center view on search navigation
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })

-- Navigate wrapped lines naturally
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- Keybinding help and leader key mappings
-- Use helix-style key hints
require("which-key").setup({
  preset = "helix",
})

require("which-key").add({
  -- Buffer navigation
  { "<leader><leader>", "<c-^>",                                           desc = "Toggle last buffer" },
  { "<leader>[",        ":bN<cr>",                                         desc = "Go to previous buffer" },
  { "<leader>]",        ":bn<cr>",                                         desc = "Go to next buffer" },

  -- Fuzzy finder (mini.pick)
  { "<leader>fx",       "<cmd>Pick explorer<cr>",                          desc = "Find File with explorer",           mode = "n" },
  { "<leader>ff",       "<cmd>Pick files<cr>",                             desc = "Find File",                         mode = "n" },
  { "<leader>fF",       "<cmd>Pick grep_live<cr>",                         desc = "Find in all files",                 mode = "n" },
  { "<leader>fb",       "<cmd>Pick buffers<cr>",                           desc = "Find Buffers",                      mode = "n" },
  { "<leader>fs",       "<cmd>Pick lsp scope='document_symbol'<cr>",       desc = "Find symbols in document",          mode = "n" },
  { "<leader>fw",       "<cmd>Pick lsp scope='workspace_symbol_live'<cr>", desc = "Find symbols in workspace",         mode = "n" },
  { "<leader>fr",       "<cmd>Pick lsp scope='references'<cr>",            desc = "Find references",                   mode = "n" },
  { "<leader>fi",       "<cmd>Pick lsp scope='implementation'<cr>",        desc = "Find implementations",              mode = "n" },
  { "<leader>fd",       "<cmd>Pick lsp scope='definition'<cr>",            desc = "Find definitions",                  mode = "n" },
  { "<leader>fD",       "<cmd>Pick lsp scope='declaration'<cr>",           desc = "Find declarations",                 mode = "n" },
  { "<leader>ft",       "<cmd>Pick lsp scope='type_definition'<cr>",       desc = "Find type definitions",             mode = "n" },
  { "<leader>fc",       "<cmd>Pick commands<cr>",                          desc = "Find commands",                     mode = "n" },
  { "<leader>fj",       "<cmd>Pick list scope='jump'<cr>",                 desc = "Find jumplist",                     mode = "n" },
  { "<leader>fq",       "<cmd>Pick list scope='quickfix'<cr>",             desc = "Find quickfix",                     mode = "n" },
  { "<leader>fc",       "<cmd>Pick list scope='change'<cr>",               desc = "Find change",                       mode = "n" },
  { "<leader>fl",       "<cmd>Pick list scope='location'<cr>",             desc = "Find location",                     mode = "n" },
  { "<leader>fm",       "<cmd>Pick marks<cr>",                             desc = "Find marks",                        mode = "n" },
  { "<leader>fk",       "<cmd>Pick keymaps<cr>",                           desc = "Find keymaps",                      mode = "n" },
  { "<leader>'",        "<cmd>Pick resume<cr>",                            desc = "Resume last find picker",           mode = "n" },

  -- LSP actions
  { "<leader>a",        vim.lsp.buf.code_action,                           desc = "LSP Code action",                   mode = "n" },
  { "<leader>h",        vim.lsp.buf.hover,                                 desc = "LSP Hover",                         mode = "n" },
  { "<leader>s",        vim.lsp.buf.signature_help,                        desc = "LSP Signature",                     mode = "n" },
  { "<leader>S",        "<cmd>Pick lsp scope='workspace_symbol'<cr>",      desc = "LSP Workspace symbol",              mode = "n" },
  { "<leader>=",        vim.lsp.buf.format,                                desc = "LSP format",                        mode = "n" },
  { "==",               vim.lsp.buf.format,                                desc = "LSP format",                        mode = "n" },
  { "<leader>r",        vim.lsp.buf.rename,                                desc = "LSP Rename",                        mode = "n" },

  -- Navigation (goto)
  { "<leader>g",        group = "Goto",                                    desc = "Goto",                              mode = "n" },
  { "<leader>gd",       vim.lsp.buf.declaration,                           desc = "Goto declaration",                  mode = "n" },
  { "<leader>gD",       vim.lsp.buf.type_definition,                       desc = "Goto type definition",              mode = "n" },
  { "<leader>gi",       vim.lsp.buf.implementation,                        desc = "Goto implementations",              mode = "n" },
  { "<leader>gr",       vim.lsp.buf.references,                            desc = "Goto references",                   mode = "n" },

  -- Git operations (gitsigns)
  { "<leader>G",        group = "Git",                                     desc = "Git",                               mode = "n" },
  { "<leader>Gb",       "<cmd>Gitsigns blame_line<cr>",                    desc = "Git blame line",                    mode = "n" },
  { "<leader>GB",       "<cmd>Gitsigns blame<cr>",                         desc = "Git blame",                         mode = "n" },
  { "<leader>Gd",       "<cmd>Gitsigns diffthis<cr>",                      desc = "Git diff current file",             mode = "n" },
  { "<leader>Gs",       "<cmd>Gitsigns stage_hunk<cr>",                    desc = "Git stage hunk",                    mode = "n" },
  { "<leader>GS",       "<cmd>Gitsigns stage_buffer<cr>",                  desc = "Git stage file",                    mode = "n" },
  { "<leader>Gu",       "<cmd>Gitsigns reset_hunk<cr>",                    desc = "Git reset hunk",                    mode = "n" },
  { "<leader>GU",       "<cmd>Gitsigns reset_buffer<cr>",                  desc = "Git reset file",                    mode = "n" },
  { "<leader>Gn",       "<cmd>Gitsigns next_bunk<cr>",                     desc = "Git next hunk",                     mode = "n" },
  { "<leader>GN",       "<cmd>Gitsigns previous_bunk<cr>",                 desc = "Git previous hunk",                 mode = "n" },
  { "<leader>Gf",       "<cmd>Pick git_hunks<cr>",                         desc = "Git find hunks",                    mode = "n" },

  -- Diagnostics
  { "<leader>d",        group = "Diagnostic",                              desc = "Diagnostic",                        mode = "n" },
  { "<leader>db",       vim.diagnostic.goto_prev,                          desc = "Go to previous diagnostic message", mode = "n" },
  { "<leader>df",       vim.diagnostic.goto_next,                          desc = "Go to next diagnostic message",     mode = "n" },
  { "<leader>de",       vim.diagnostic.open_float,                         desc = "Open floating diagnostic message",  mode = "n" },
  { "<leader>dl",       "<cmd>Pick diagnostic<cr>",                        desc = "Open diagnostics list",             mode = "n" },
  { "<leader>dq",       vim.diagnostic.setqflist,                          desc = "Open quick fix list",               mode = "n" },
})

-- Highlight on yank for visual feedback
vim.api.nvim_create_autocmd(
  'TextYankPost',
  {
    pattern = '*',
    command = 'silent! lua vim.highlight.on_yank({ timeout = 500 })'
  }
)
