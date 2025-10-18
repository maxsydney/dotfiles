-- Pyright language server configuration
return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json" },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
      },
    },
  },
}
