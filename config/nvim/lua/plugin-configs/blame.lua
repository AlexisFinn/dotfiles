return {
  'FabijanZulj/blame.nvim',
  config = function()
    require('blame').setup()
    local keymap = vim.keymap.set
    keymap('n', '<leader>gb', function () vim.cmd('ToggleBlame virtual') end, {
      desc = "Toggle blame",
    })
  end
}
