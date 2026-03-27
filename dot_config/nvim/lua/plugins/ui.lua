return {
  -- nvim-tree file explorer (per D-08)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File Explorer" },
    },
    opts = {
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    },
  },

  -- Telescope is already included by LazyVim (per D-07)
  -- Additional telescope config if needed
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
          },
        },
        sorting_strategy = "ascending",
      },
    },
  },

  -- Disable neo-tree (LazyVim default) in favor of nvim-tree
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
}
