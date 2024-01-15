-- return {
--   'vijaymarupudi/nvim-fzf', -- lua api
--   dependencies = 'vijaymarupudi/nvim-fzf-commands', -- actual vim commands
-- }
--
return {
  "linrongbin16/fzfx.nvim",
  dependencies = {"junegunn/fzf", "nvim-tree/nvim-web-devicons"},
  config = function()
    require('fzfx').setup({
      override_fzf_opts = {
        {'--preview-window', 'top,50%'}
      },
      popup = {
        border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
        -- border = "single"
      }
    })
  end
}
