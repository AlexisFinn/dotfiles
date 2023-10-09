return {
'echasnovski/mini.comment',
version = false,
  dependencies = {
    -- determine comment syntax by the line, full for embedded syntax typically in javascript frameworks
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  config = function()
    require('mini.comment').setup({
      mappings = {
        comment = '<leader>cc',
        comment_line = '<leader>c'
      },
      hooks = {
        pre = function()
          if vim.api.nvim_buf_get_option(0, "filetype") == "vue" then
            require("ts_context_commentstring.internal").update_commentstring()
          end
        end
      }
    })
  end
}
