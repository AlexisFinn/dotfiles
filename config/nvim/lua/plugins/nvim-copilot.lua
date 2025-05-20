return {
  -- 'github/copilot.vim', -- official
  "zbirenbaum/copilot.lua", -- lua re-write
  cmd = "Copilot",
  event = "VeryLazy",
  config = function()
    require("copilot").setup({
      copilot_model = "claude-3.7-sonnet",
      panel = {
        enabled = false,
        keymap = {
          open = "<C-s>",
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
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
