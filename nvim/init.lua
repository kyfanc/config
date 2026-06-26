local vim = vim -- suppress lsp warnings

-- Leader key configuration
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core editor settings
vim.opt.autoread = true
vim.opt.backspace = "indent,eol,start"
vim.opt.clipboard = "unnamedplus"
vim.opt.colorcolumn = "100"
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.scrolloff = 2
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.number = true
vim.wo.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.list = true
vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'
vim.opt.wrap = false
vim.opt.winborder = "rounded"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.pumheight = 15
vim.opt.mouse = "a"
vim.opt.shell = "/bin/bash"
vim.o.timeoutlen = 300
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "indent"
vim.opt.wildmode = { "lastused", "full" }
vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'
vim.opt.vb = true
vim.o.termguicolors = true
vim.o.background = "dark"
vim.o.updatetime = 250
vim.diagnostic.config({ virtual_text = true })

local autocmd = vim.api.nvim_create_autocmd

autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Package setup 
vim.pack.add({
  "https://github.com/ellisonleao/gruvbox.nvim",
  "https://github.com/neovim/nvim-lspconfig", -- Used strictly for root_dir/cmd definitions
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/iwe-org/iwe.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/qvalentin/helm-ls.nvim",
})

-- Configure LSP Servers via v0.11/0.12 native API
-- Modify default settings BEFORE enabling them
vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      schemas = {
        kubernetes = "/*.yaml",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
      },
    },
  }
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = { enable = false }
    }
  }
})

-- Enable servers using native API
vim.lsp.enable({
  "gopls",
  "lua_ls",
  "yamlls",
  "terraformls",
  "bashls",
  "ts_ls",
  "helm_ls",
  "rust_analyzer",
  "roslyn_ls",
  "pylsp"
})

-- LSP Attach Hook: Buffer-local keybindings and Inlay Hints
autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(args)
    local buf = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Enable native inlay hints if server supports it (Go, Rust, C#, TS)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end

    -- Fix for Terraform tokens
    if client and client.name == 'terraformls' then
      client.server_capabilities.semanticTokensProvider = nil
    end

    -- Buffer-local WhichKey LSP mappings
    require("which-key").add({
      { "<leader>l", group = "LSP/Refactor", buffer = buf, mode = "n" },
      { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", buffer = buf, mode = "n" },
      { "<leader>lr", vim.lsp.buf.rename, desc = "Rename Symbol", buffer = buf, mode = "n" },
      { "<leader>lf", vim.lsp.buf.format, desc = "Format Document", buffer = buf, mode = "n" },
      { "<leader>ls", vim.lsp.buf.signature_help, desc = "Signature Help", buffer = buf, mode = "n" },
      { "<leader>lh", vim.lsp.buf.hover, desc = "Hover Docs", buffer = buf, mode = "n" },
    })
  end,
})

-- Auto-enable TreeSitter for Helm
autocmd("FileType", {
  pattern = { "helm" },
  callback = function() vim.treesitter.start() end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "Jenkinsfile.*",
  callback = function() vim.bo.filetype = "groovy" end,
})

-- Initialize plugins
require("mini.comment").setup()
require("mini.completion").setup()
require("mini.diff").setup()
require('mini.extra').setup({})
require("mini.files").setup()
require("mini.git").setup()
require("mini.icons").setup()
require("mini.move").setup()
require("mini.pick").setup()
require("mini.statusline").setup()
require("mini.surround").setup()
require("mini.tabline").setup()
require("mini.trailspace").setup()
require("gitsigns").setup()
require("iwe").setup()

-- Install parsers
require("nvim-treesitter").install({
  "helm", "gotmpl", "yaml", "python", "c_sharp", "go", "bash", "rust"
})

require("helm-ls").setup {
  settings = {
    ["helm-ls"] = {
      yamlls = { path = "yaml-language-server" }
    }
  }
}

vim.cmd("colorscheme gruvbox")

-- Core keybindings
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')

-- Centered Navigation
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- Global WhichKey mappings (Non-LSP dependencies)
require("which-key").setup({ preset = "helix" })
require("which-key").add({
  { "<leader><leader>", "<c-^>", desc = "Toggle last buffer" },
  { "<leader>[", ":bN<cr>", desc = "Go to previous buffer" },
  { "<leader>]", ":bn<cr>", desc = "Go to next buffer" },
-- Buffer & Window Management
  { "<leader>b", group = "Buffer/Window", mode = "n" },
  { "<leader>bo", "<cmd>%bd|e#|bd#<cr>", desc = "Close All Other Buffers", mode = "n" },
  { "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer", mode = "n" },
  { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer", mode = "n" },
  { "<leader>bs", "<cmd>split<cr>", desc = "Split Window Horizontally", mode = "n" },
  { "<leader>bv", "<cmd>vsplit<cr>", desc = "Split Window Vertically", mode = "n" },
  { "<leader>bc", "<cmd>close<cr>", desc = "Close Current Window", mode = "n" },

-- Find / Explore
  { "<leader>f", group = "Find/Explore", mode = "n" },
  { "<leader>ff", "<cmd>Pick files<cr>", desc = "Find Files", mode = "n" },
  { "<leader>fg", "<cmd>Pick grep_live<cr>", desc = "Grep Workspace (Live)", mode = "n" },
  { "<leader>fw", function() MiniPick.builtin.grep({ pattern = vim.fn.expand('<cword>') }) end, desc = "Grep Word Under Cursor", mode = "n" },
  { "<leader>fr", "<cmd>Pick resume<cr>", desc = "Resume Last Picker", mode = "n" },
  { "<leader>fb", "<cmd>Pick buffers<cr>", desc = "Find Buffers", mode = "n" },
  { "<leader>fs", "<cmd>Pick lsp scope='document_symbol'<cr>", desc = "Find Document Symbols", mode = "n" },
  { "<leader>fS", "<cmd>Pick lsp scope='workspace_symbol_live'<cr>", desc = "Find Workspace Symbols", mode = "n" },
  { "<leader>fq", "<cmd>Pick list scope='quickfix'<cr>", desc = "Find Quickfix", mode = "n" },
  { "<leader>fh", "<cmd>Pick help<cr>", desc = "Find Help Tags", mode = "n" },
  { "<leader>fc", "<cmd>Pick commands<cr>", desc = "Find Commands", mode = "n" },
  { "<leader>fx", "<cmd>Pick explorer<cr>", desc = "File Explorer", mode = "n" },  -- Git
  { "<leader>G", group = "Git", mode = "n" },
  { "<leader>Gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line", mode = "n" },
  { "<leader>GB", "<cmd>Gitsigns blame<cr>", desc = "Blame file", mode = "n" },
  { "<leader>Gc", "<cmd>Gitsigns show_commit<cr>", desc = "Show commit", mode = "n" },
  { "<leader>Gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff current file", mode = "n" },
  { "<leader>Gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk", mode = "n" },
  { "<leader>Gu", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk", mode = "n" },
  { "<leader>Gf", "<cmd>Pick git_hunks<cr>", desc = "Find hunks", mode = "n" },

  -- Diagnostics
  { "<leader>d", group = "Diagnostic", mode = "n" },
  { "<leader>de", vim.diagnostic.open_float, desc = "Floating diagnostic", mode = "n" },
  { "<leader>dl", "<cmd>Pick diagnostic<cr>", desc = "Diagnostics list", mode = "n" },

  -- Toggle
  { "<leader>t", group = "Toggle", mode = "n" },
  { "<leader>tw", "<cmd>set wrap!<cr>", desc = "Toggle wrap", mode = "n" },
  { "<leader>ti", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, desc = "Toggle Inlay Hints", mode = "n" },
})

vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  command = 'silent! lua vim.highlight.on_yank({ timeout = 500 })'
})
