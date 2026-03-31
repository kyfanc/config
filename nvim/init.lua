local vim = vim -- suppress lsp warnings
vim.g.clipboard = "pbcopy"
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
vim.opt.laststatus = 0
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
  })

  autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
      local bufopts = { noremap = true, silent = true, buffer = ev.buf }
      vim.keymap.set("n", "grd", vim.lsp.buf.definition, bufopts)
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
  {
    src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  "https://github.com/nvim-telescope/telescope.nvim",
})

-- main setup
setup_lsp()

require("mini.pick").setup()
require("mini.files").setup()
require("mini.git").setup()
require("mini.diff").setup()
require("mini.statusline").setup()
require("mini.tabline").setup()
require("mini.trailspace").setup()

vim.cmd("colorscheme gruvbox")
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- require('telescope').load_extension('fzf')

-- keymap
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader><leader>', '<c-^>', { desc = 'fast toggle buffer' })

require("which-key").add({
  { "<leader>f", group = "file" }, -- group
  { "<leader>ff", "<cmd>Telescope finde_files<cr>", desc = "Find File", mode = "n" },
  { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers", mode = "n" },
  { "<leader>db", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic message", mode = "n" },
  { "<leader>df", vim.diagnostic.goto_next, desc = "Go to next diagnostic message", mode = "n" },
  { "<leader>de", vim.diagnostic.open_float, desc = "Open floating diagnostic message", mode = "n" },
  { "<leader>dl", vim.diagnostic.setloclist, desc = "Open diagnostics list", mode = "n" },
  { "<leader>dq", vim.diagnostic.setqflist, desc = "Open quick fix list", mode = "n" },
})
