return {
  cmd = {
    vim.fn.expand("jedi-language-server"),
  },
  filetypes = {
    "python",
  },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
  },
}
