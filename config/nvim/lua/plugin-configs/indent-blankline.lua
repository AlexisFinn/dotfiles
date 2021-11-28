local foreground = '#2a3834'
local background = '#332b36'

require 'indent_blankline'.setup({
  show_current_context = true,
  show_current_context_start = false,
  --char_list= {'|', '¦', '┆', '┊'},
  char = '┊', -- ignored if char_list is not empty
  char_highlight_list = { -- define indent lines colors
    'Comment', -- up to 4 is fine
    'Comment',
    'Comment',
    'Comment',
    'Comment',
    'Comment',
    'Comment',
    'Comment',
    'WarningMsg', -- warning, too much indent ?
    'WarningMsg',
    'WarningMsg',
    'WarningMsg',
    'Error', -- error, this much indent should be avoided
    'Error',
    'Error',
    'Error',
  },
  space_char_highlight_list = {},
  use_treesitter = true,
  indent_level = 16, -- maximum indent level to draw indent guides for
  show_first_indent_level = false,
  context_highlight_list = {'Identifier'},
  context_patterns = {'class', 'function', 'method', '^if', '^else', '^for', '^foreach', '^while', '^do'}
})
