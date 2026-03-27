-- conform.nvim: format-on-save with prettier (per D-18, FMT-01, NODE-02)
-- Apex intentionally omitted from formatters_by_ft (per D-22, FMT-02)
return {
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        -- apex intentionally omitted: no formatter exists (per D-22, FMT-02)
      },
    },
  },
}
