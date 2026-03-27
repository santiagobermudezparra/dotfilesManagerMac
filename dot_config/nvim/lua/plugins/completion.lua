return {
  -- blink.cmp completion engine (per D-05, D-06)
  {
    "saghen/blink.cmp",
    version = "1.*",  -- pin to v1 stable, avoid V2 breaking changes
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
