local popfix = require('popfix')

function test()
  popfix:new({
    height = 40,
    width = 40,
    mode = 'editor',
    close_on_bufleave = true,
    data = {"hello", "world"},
    list = {
      border = true,
      numbering = true,
      title = 'MyTitle',
      highlight = 'Normal',
      selection_highlight = 'Visual',
      matching_highlight = 'Identifier',
    },
    preview = {
      type = 'terminal',
      border = true,
      numbering = true,
      title = 'MyTitle',
      highlight = 'Normal',
      preview_highlight = 'Visual',
    },
    prompt = {
      border = true,
      numbering = true,
      title = 'MyTitle',
      highlight = 'Normal',
      prompt_highlight = 'Normal'
    },
  })
end
