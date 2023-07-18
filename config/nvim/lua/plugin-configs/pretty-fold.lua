require('pretty-fold').setup {
  sections = {
    left = {'content'},
    right = {
      ' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
      function(config) return config.fill_char:rep(3) end
    }
  },
  fill_char = '',
  remove_fold_markers = true,
  keep_indentation = true,
  process_comment_signs = 'spaces', -- 'spaces', 'delete', false
  add_close_patter = true, -- true, false, 'last_line'
}
