local vim = vim -- suppress lsp warnings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.autoread = true
vim.opt.backspace = "indent,eol,start"
vim.opt.clipboard = "unnamedplus"
vim.opt.colorcolumn = "100"
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.expandtab = true
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "indent"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.mouse = 'a'
vim.opt.pumheight = 15
vim.opt.shell = "/bin/bash"
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.undofile = true
vim.opt.wildmode = { "lastused", "full" }
vim.opt.winborder = "rounded"
vim.opt.wrap = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.o.background = "dark" -- or "light" for light mode

-- lsp
local augroup = vim.api.nvim_create_augroup("erock.cfg", { clear = true })
local autocmd = vim.api.nvim_create_autocmd
autocmd("Filetype", { group = augroup, pattern = "make", command = "setlocal noexpandtab tabstop=4 shiftwidth=4" })
autocmd("BufEnter", { -- disable automatic newline comment continuation
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})
local function setup_lsp()
  vim.lsp.enable({
    "gopls",
    'lua_ls',
    'yamlls',
    'marksman',
    'terraformls',
    'bashls',
    'ts_ls',
  })

  autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
      local bufopts = { noremap = true, silent = true, buffer = ev.buf }
      vim.keymap.set("i", "<C-k>", vim.lsp.completion.get, bufopts) -- open completion menu manually
      local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
      local methods = vim.lsp.protocol.Methods
      if client:supports_method(methods.textDocument_completion) then
        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      end
    end,
  })
end

vim.pack.add({
  "https://github.com/ellisonleao/gruvbox.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/which-key.nvim",
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/iwe-org/iwe.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
})

-- main setup
setup_lsp()

require("mini.pick").setup()
require("mini.files").setup()
require("mini.git").setup()
require("mini.diff").setup()
require('mini.statusline').setup()
require("mini.tabline").setup()
require("mini.trailspace").setup()
require('gitsigns').setup()
require("iwe").setup()

vim.cmd("colorscheme gruvbox")

-- keymap
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

require("which-key").add({
  { "<leader><leader>", '<c-^>', desc = "Toggle last buffer" },
  { "<leader>[", ':bN<cr>', desc = "Go to previous buffer" },
  { "<leader>]", ':bn<cr>', desc = "Go to next buffer" },
  { "<leader>f", "<cmd>Pick files<cr>", desc = "Find File", mode = "n" },
  { "<leader>b", "<cmd>Pick buffers<cr>", desc = "Find Buffers", mode = "n" },
  { "<leader>'", "<cmd>Pick resume<cr>", desc = "Resume last find picker", mode = "n" },
  { "<leader>a", vim.lsp.buf.code_action, desc = "Code action", mode = "n" },
  { "<leader>k", vim.lsp.buf.signature_help, desc = "Signature", mode = "n" },
  { "<leader>g", group = "g", desc = "Goto", mode = "n" },
  { "<leader>gD", vim.lsp.buf.declaration, desc = "Goto type definition", mode = "n" },
  { "<leader>gd", vim.lsp.buf.type_definition, desc = "Goto type definition", mode = "n" },
  { "<leader>gi", vim.lsp.buf.implementation, desc = "Goto implementations", mode = "n" },
  { "<leader>gr", vim.lsp.buf.references, desc = "Goto references", mode = "n" },
  { "<leader>r", vim.lsp.buf.rename, desc = "Rename", mode = "n" },
  { "<leader>db", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic message", mode = "n" },
  { "<leader>df", vim.diagnostic.goto_next, desc = "Go to next diagnostic message", mode = "n" },
  { "<leader>de", vim.diagnostic.open_float, desc = "Open floating diagnostic message", mode = "n" },
  { "<leader>dl", vim.diagnostic.setloclist, desc = "Open diagnostics list", mode = "n" },
  { "<leader>dq", vim.diagnostic.setqflist, desc = "Open quick fix list", mode = "n" },
  { "<A-k>", "<cmd>m .-2<cr>==", desc = "move line up", mode = "n" },
  { "<A-j>", "<cmd>m .+1<cr>==", desc = "move line down", mode = "n" },
})
