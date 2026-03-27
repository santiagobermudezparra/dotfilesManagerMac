return {
  -- sf.nvim: Salesforce CLI integration (per D-11, SF-01, SF-02)
  -- Requires: sf CLI v2 (`sf` command) and Neovim v0.11+
  -- Activates only in Salesforce projects (sfdx-project.json or .forceignore)
  {
    "xixiaofinland/sf.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("sf").setup({
        enable_hotkeys = false, -- define own mappings to avoid conflicts
      })

      -- Salesforce keymaps (Claude's discretion for exact bindings)
      local map = vim.keymap.set
      map("n", "<leader>sp", "<cmd>SF metadata push<cr>", { desc = "SF Push Metadata" })
      map("n", "<leader>sr", "<cmd>SF metadata retrieve<cr>", { desc = "SF Retrieve Metadata" })
      map("n", "<leader>sta", "<cmd>SF apex test run_all<cr>", { desc = "SF Run All Apex Tests" })
      map("n", "<leader>stt", "<cmd>SF apex test run_current<cr>", { desc = "SF Run Current Apex Test" })
      map("n", "<leader>so", "<cmd>SF org open<cr>", { desc = "SF Open Org in Browser" })
      map("n", "<leader>sl", "<cmd>SF org list<cr>", { desc = "SF List Orgs" })
    end,
  },

  -- toggleterm.nvim: general-purpose terminal (per D-15, SF-03)
  -- sf.nvim has built-in SFTerm for sf CLI output; toggleterm provides floating/split terminals
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<c-\>]],
      direction = "float",
      float_opts = {
        border = "curved",
      },
    },
  },
}
