return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Salesforce (per D-16, TS-01)
        "apex",
        "soql",
        "sosl",
        -- Web development (per D-21, TS-02, TS-03)
        -- javascript, typescript, tsx, html already in LazyVim defaults
        "css",
        -- Metadata (per D-25, TS-04)
        -- xml already in LazyVim defaults
        -- Existing parsers to retain (per D-24, TS-05)
        -- bash, lua, python, json, yaml, vim, vimdoc already in LazyVim defaults
        "go",
        "c_sharp",
        "bicep",
        "terraform",
      },
    },
  },
}
