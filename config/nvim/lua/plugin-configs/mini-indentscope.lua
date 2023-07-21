return {
  'echasnovski/mini.indentscope',
  config = function()
    require('mini.indentscope').setup({
      symbol = "│",
      options = { try_as_border = true }
    })
  end
}

