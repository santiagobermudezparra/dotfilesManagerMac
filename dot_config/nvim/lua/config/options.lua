-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

opt.number = false          -- no line numbers
opt.relativenumber = false  -- no relative line numbers
opt.scrolloff = 8           -- lines of context above/below cursor
opt.mouse = "a"             -- enable mouse in all modes
opt.smartcase = true        -- smart case search
opt.ignorecase = true       -- ignore case in search (needed for smartcase)
opt.signcolumn = "yes"      -- always show signcolumn

-- Apex filetype detection (per SF-05, research Pitfall 3)
-- Neovim has no built-in detection for Salesforce Apex files
vim.filetype.add({
  extension = {
    cls = "apexcode",
    trigger = "apexcode",
    apex = "apexcode",
  },
})
