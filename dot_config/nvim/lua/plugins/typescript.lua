-- TypeScript/JavaScript LSP configuration (per D-17, D-19)
-- IMPORTANT: Do NOT enable LazyVim's lang.typescript extra (it installs a different TS server)
-- ts_ls is configured directly via nvim-lspconfig (research Pitfall 2)
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- ts_ls: TypeScript/JavaScript LSP (per D-17, LSP-02, NODE-01, NODE-05)
        -- Provides: completions, go-to-definition, hover, diagnostics for JS/TS/TSX
        ts_ls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          root_dir = require("lspconfig.util").root_pattern(
            "tsconfig.json",
            "jsconfig.json",
            "package.json",
            ".git"
          ),
        },

        -- eslint-lsp: ESLint integration (per D-19, NODE-03)
        -- Runs as LSP server, provides diagnostics on file change
        eslint = {
          settings = {
            packageManager = "npm",
          },
          -- ESLint checks on save, not on every keystroke (per CONTEXT.md specifics)
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        },
      },
    },
  },
}
