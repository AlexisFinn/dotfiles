return {
  "rareitems/printer.nvim",
  config = function()
    require("printer").setup({
      keymap = "<leader>cl",
      formatters = {
        javascript = function(inside, var)
          local firstLine = string.format("console.log('[[ %s ]] ---------------->');", inside)
          local secondLine = string.format("console.dir(%s, {depth: 5});", var)
          local thirdLine = "console.log(' <----------------');"
          return firstLine .. "\n" .. secondLine .. "\n" .. thirdLine
        end,
      },
    })
  end,
}
