require("noice").setup({
  cmdline = {
    enabled = false,
  },
  messages = {
    enabled = false
  },
  popupmenu = {
    enabled = true,
    backend = "nui"
  },
  routes = {
    {
      filter = { find = "Diagnostics" },
      view = "split"
    }
  }
})
