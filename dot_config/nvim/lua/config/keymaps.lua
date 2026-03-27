-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Window navigation (move between splits/panes with Ctrl+hjkl)
map("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

-- Scroll centering (keep cursor centered when scrolling)
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Prev search result centered" })

-- Telescope symbol finder (per existing personal config)
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
map("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace Symbols" })

-- Completion enable/disable (from personal config)
map("n", "<leader>p", '<cmd>lua require("cmp").setup { enabled = true }<cr>', { desc = "Enable completion" })
map("n", "<leader>P", '<cmd>lua require("cmp").setup { enabled = false }<cr>', { desc = "Disable completion" })
