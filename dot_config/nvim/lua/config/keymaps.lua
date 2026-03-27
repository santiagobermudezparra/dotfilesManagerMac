-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Scroll centering (keep cursor centered when scrolling)
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Prev search result centered" })

-- Telescope symbol finder (per existing personal config)
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
map("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Workspace Symbols" })
