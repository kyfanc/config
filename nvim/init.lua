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
vim.opt.mouse = "a"
vim.opt.pumheight = 15
vim.opt.shell = "/bin/bash"
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.scrolloff = 2
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.undofile = true
vim.opt.wildmode = { "lastused", "full" }
vim.opt.winborder = "rounded"
vim.opt.wrap = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = "menuone,noselect"
vim.o.termguicolors = true
vim.o.background = "dark" -- or "light" for light mode
vim.diagnostic.config({ virtual_text = true })
vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'
vim.opt.vb = true
vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'
-- lsp
local autocmd = vim.api.nvim_create_autocmd
autocmd("BufEnter", { -- disable automatic newline comment continuation
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

local function setup_lsp()
  vim.lsp.enable({
    "gopls",
    "lua_ls",
    "yamlls",
    "marksman",
    "terraformls",
    "bashls",
    "ts_ls",
    "helm_ls",
  })

  autocmd("FileType", {
    pattern = { "helm" },
    callback = function() vim.treesitter.start() end,
  })

end

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

-- main setup
setup_lsp()

require("mini.comment").setup()
require("mini.completion").setup()
require("mini.diff").setup()
require("mini.files").setup()
require("mini.git").setup()
require("mini.move").setup()
require("mini.pick").setup()
require("mini.statusline").setup()
require("mini.surround").setup()
require("mini.tabline").setup()
require("mini.trailspace").setup()
require("gitsigns").setup()
require("iwe").setup()
require("nvim-treesitter").install({
  "helm",
  "gotmpl",
  "yaml",
})

require("helm-ls").setup {
  settings = {
    ["helm-ls"] = {
      yamlls = {
        path = "yaml-language-server",
      }
    }
  }
}

vim.cmd("colorscheme gruvbox")

-- keymap
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set('v', '<C-h>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<C-h>', '<cmd>nohlsearch<cr>')
vim.keymap.set('v', '<C-c>', 'gcc', { silent = true })
vim.keymap.set('n', '<C-c>', 'gcc', { silent = true })
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

require("which-key").setup({
  preset = "helix",
})

require("which-key").add({
  { "<leader><leader>", "<c-^>", desc = "Toggle last buffer" },
  { "<leader>[", ":bN<cr>", desc = "Go to previous buffer" },
  { "<leader>]", ":bn<cr>", desc = "Go to next buffer" },
  { "<leader>f", "<cmd>Pick files<cr>", desc = "Find File", mode = "n" },
  { "<leader>b", "<cmd>Pick buffers<cr>", desc = "Find Buffers", mode = "n" },
  { "<leader>'", "<cmd>Pick resume<cr>", desc = "Resume last find picker", mode = "n" },
  { "<leader>a", vim.lsp.buf.code_action, desc = "LSP Code action", mode = "n" },
  { "<leader>h", vim.lsp.buf.hover, desc = "LSP Hover", mode = "n" },
  { "<leader>s", vim.lsp.buf.signature_help, desc = "LSP Signature", mode = "n" },
  { "<leader>g", group = "g", desc = "Goto", mode = "n" },
  { "<leader>gD", vim.lsp.buf.declaration, desc = "Goto type definition", mode = "n" },
  { "<leader>gd", vim.lsp.buf.type_definition, desc = "Goto type definition", mode = "n" },
  { "<leader>gi", vim.lsp.buf.implementation, desc = "Goto implementations", mode = "n" },
  { "<leader>gr", vim.lsp.buf.references, desc = "Goto references", mode = "n" },
  { "<leader>r", vim.lsp.buf.rename, desc = "LSP Rename", mode = "n" },
  { "<leader>db", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic message", mode = "n" },
  { "<leader>df", vim.diagnostic.goto_next, desc = "Go to next diagnostic message", mode = "n" },
  { "<leader>de", vim.diagnostic.open_float, desc = "Open floating diagnostic message", mode = "n" },
  { "<leader>dl", vim.diagnostic.setloclist, desc = "Open diagnostics list", mode = "n" },
  { "<leader>dq", vim.diagnostic.setqflist, desc = "Open quick fix list", mode = "n" },
})

vim.api.nvim_create_autocmd(
	'TextYankPost',
	{
		pattern = '*',
		command = 'silent! lua vim.highlight.on_yank({ timeout = 500 })'
	}
)
