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

      -- Wrapper to ensure safe buffer state for sf.nvim operations
      -- Fixes: "Cannot make changes, 'modifiable' is off" error when running sf commands
      -- in read-only buffers (see .planning/DEBUG_SF_NVIM.md for root cause analysis)
      local function safe_sf_command(cmd)
        return function()
          -- Save current buffer state
          local current_buf = vim.api.nvim_get_current_buf()
          local was_modifiable = vim.bo[current_buf].modifiable

          -- Ensure buffer is modifiable for error messages
          if not was_modifiable then
            vim.bo[current_buf].modifiable = true
          end

          -- Execute the SF command with error recovery
          local ok, result = pcall(function()
            vim.cmd(cmd)
          end)

          -- Restore modifiable state if we changed it
          if not was_modifiable then
            vim.bo[current_buf].modifiable = false
          end

          -- If there was an error, show it clearly
          if not ok then
            vim.notify(
              "SF command failed: " .. tostring(result),
              vim.log.levels.ERROR,
              { title = "sf.nvim Error" }
            )
          end
        end
      end

      -- Salesforce keymaps with buffer safety wrapper
      local map = vim.keymap.set
      map("n", "<leader>sp", safe_sf_command("SF metadata push"), { desc = "SF Push Metadata" })
      map("n", "<leader>sr", safe_sf_command("SF metadata retrieve"), { desc = "SF Retrieve Metadata" })
      map("n", "<leader>sta", safe_sf_command("SF apex test run_all"), { desc = "SF Run All Apex Tests" })
      map("n", "<leader>stt", safe_sf_command("SF apex test run_current"), { desc = "SF Run Current Apex Test" })
      map("n", "<leader>so", safe_sf_command("SF org open"), { desc = "SF Open Org in Browser" })
      map("n", "<leader>sl", safe_sf_command("SF org list"), { desc = "SF List Orgs" })
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
