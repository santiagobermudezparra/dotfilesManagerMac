-- LazyVim language extras not already covered by the custom LSP/TS configs
-- json/yaml/typescript are handled via lsp.lua/typescript.lua directly
return {
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.docker"  },
  { import = "lazyvim.plugins.extras.lang.toml"    },
}
