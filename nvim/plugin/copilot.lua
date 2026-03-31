vim.pack.add({
  "https://github.com/github/copilot.vim",
  "https://github.com/CopilotC-Nvim/CopilotChat.nvim",
})
-- disable default tab mapping in copilot to avoid conflicts with CopilotChat.nvim
vim.g.copilot_no_tab_map = true
-- map shift+tab to accept copilot suggestion
vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })

