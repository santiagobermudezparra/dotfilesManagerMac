return {
  -- Mason: install LSP servers, formatters, linters (per D-23, LSP-01)
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "typescript-language-server", -- for ts_ls (LSP-02, configured in typescript.lua)
        "yaml-language-server",       -- yamlls (LSP-05)
        "json-lsp",                   -- jsonls (LSP-04)
        "bash-language-server",       -- bashls (LSP-06)
        "marksman",                   -- markdown LSP (LSP-06)
        "eslint-lsp",                 -- eslint (NODE-03, configured in typescript.lua)
        "prettier",                   -- formatter (FMT-01, configured in formatting.lua)
        -- apex_ls is NOT here -- managed by bootstrap curl download (research Pitfall 5)
      },
    },
  },

  -- SchemaStore for JSON and YAML schema validation (per D-20, NODE-04)
  { "b0o/SchemaStore.nvim", lazy = true },

  -- LSP server configurations (per D-23, LSP-04, LSP-05, LSP-06)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- JSON LSP with SchemaStore (per LSP-04, NODE-04)
        jsonls = {
          settings = {
            json = {
              schemas = function() return require("schemastore").json.schemas() end,
              validate = { enable = true },
            },
          },
        },
        -- YAML language server with SchemaStore (per LSP-05)
        yamlls = {
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },
              schemas = function() return require("schemastore").yaml.schemas() end,
            },
          },
        },
        -- bash-language-server and marksman are auto-configured by Mason + nvim-lspconfig
        -- No extra settings needed (LSP-06)
      },
    },
  },
}
