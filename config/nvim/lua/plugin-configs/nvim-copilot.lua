return {
  -- 'github/copilot.vim', -- official
  "zbirenbaum/copilot.lua", -- lua re-write
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      panel = {
        enabled = false,
        keymap = {
          open = "<C-Y>"
        }
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-y>"
        }
      },
    })

    -- official copilot keymap override
    -- vim.keymap.set('i', '<C-y>', 'copilot#Accept("")', {expr = true, replace_keycodes = false})
    -- vim.g.copliot_no_tab_map = true
  end,
}
