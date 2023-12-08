local lazyOptions = {
  ui = {
    border = "rounded",
  },
  performance = {
    cache = {enabled = true},
    rtp = {
      disabled_plugins = {
        -- "netrwPlugin",
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin"
      }
    }
  },
  debug = false,
}


require("lazy").setup({
  -- file manager
  require("plugin-configs.oil-fm"),
  -- shortcuts helper including registers, marks, keymaps, folds...
  -- require("plugin-configs.which-key"),
}, lazyOptions)
