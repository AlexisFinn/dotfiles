vim.g.rnvimr_enable_picker = 1
vim.g.rnvimr_ranger_views = {
  {minwidth = 90, ratio = {}},
  {minwidth = 50, maxwidth = 100, ratio = {1,1}},
  {maxwidth = 49, ratio = {1}}
}
vim.g.rnvimr_layout = {
  relative = 'editor',
  width = vim.o.columns,
  height = vim.o.lines - 2,
  col = 0,
  row = 0,
  style = 'minimal'
}
