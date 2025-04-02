return {
  -- 'github/copilot.vim', -- official
  "zbirenbaum/copilot.lua", -- lua re-write
  cmd = "Copilot",
  event = "VeryLazy",
  config = function()
    require("copilot").setup({
      panel = {
        enabled = false,
        keymap = {
          open = "<C-t>",
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-y>",
        },
      },
      server_opts_overrides = {
        trace = "verbose",
        settings = {
          enable = false,
          inlineSuggest = { enable = false },
        },
      },
    })
  end,
}
