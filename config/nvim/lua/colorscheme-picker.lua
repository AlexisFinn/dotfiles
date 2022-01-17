
local popfix = require('popfix')
local previous = ''
local current = ''

local blacklist = {
  OceanicNextLight = true,
  blue = true,
  default = true,
  delek = true,
  elflord = true,
  industry = true,
  koehler = true,
  morning = true,
  pablo = true,
  ron = true,
  shine = true,
  torte = true,
  darkblue = true,
  murphy = true
}

function PickColorScheme()
  local colorschemes = vim.fn.getcompletion('', 'color')
  for key, value in ipairs(colorschemes) do
    if blacklist[value] then
      table.remove(colorschemes, key)
    end
  end
  previous = vim.g.colors_name
  popfix:new({
    height = 40,
    width = 40,
    mode = 'editor',
    close_on_bufleave = true,
    data = colorschemes,
    list = {
      border = true,
      numbering = true,
      title = 'MyTitle',
      highlight = 'Normal',
      selection_highlight = 'Visual',
      matching_highlight = 'Identifier',
    },
    callbacks = {
      select = Preview
    },
    keymaps = {
      n = {
        ['<Cr>'] = function(popup)
          Pick(current)
          popup:close()
        end,
        ['<Esc>'] = function(popup)
          Pick(previous)
          popup:close()
        end
      },
      i = {
        ['<Cr>'] = function(popup)
          Pick(current)
          popup:close()
        end,
        ['<Esc>'] = function(popup)
          Pick(previous)
          popup:close()
        end
      }
    }
  })
end

function Preview(_, line)
  if line then
    Pick(line)
    current = vim.g.colors_name
  end
end

function Pick(color)
  vim.cmd('color '..color)
end

vim.api.nvim_exec('command! ColorSchemePicker lua PickColorScheme()', false)

-- command! ColorSchemePicker call Color_scheme_picker()
-- vim.cmd.ColorSchemePicker = PickColorScheme()

-- vim.api.nvim_exec(
-- [[
-- """ A color scheme picker
-- let g:Color_scheme_picker_open     = 0
-- let g:Color_scheme_picker_selected = ''

-- fu! Color_scheme_picker()
    -- if g:Color_scheme_picker_open == 1
        -- echo 'Color_scheme_picker is alread open!'
        -- return
    -- endif

    -- let g:Color_scheme_picker_open     = 1
    -- let g:Color_scheme_picker_selected = g:colors_name

    -- let l:colors = getcompletion('', 'color')
    -- silent 12 new color_scheme_picker
    -- setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
    -- put =l:colors
    -- norm ggdd
-- endfu

-- fu! Close_Color_scheme_picker()
    -- let g:Color_scheme_picker_open = 0
    -- execute 'color ' . g:Color_scheme_picker_selected
    -- redraw!
    -- echo 'Selected color scheme "' . g:Color_scheme_picker_selected . '".'
-- endfu

-- fu! Maybe_update_color()
    -- let l:current_color = g:colors_name
    -- let l:selected      = getline('.')

    -- if l:selected != l:current_color
        -- let l:changed = 0

        -- try
            -- execute 'color ' . l:selected
            -- let l:changed = 1
        -- catch /.*/
            -- execute 'color ' . g:Color_scheme_picker_selected
        -- finally
            -- redraw!
            -- if l:changed == 1
                -- echo 'Color scheme "' . l:selected . '"'
            -- else
                -- echom 'No such color scheme "' . l:selected . '" -- showing "' . g:Color_scheme_picker_selected . '"'
            -- endif
        -- endtry
    -- endif
-- endfu

-- fu! Select_Color_scheme()
    -- let g:Color_scheme_picker_selected = g:colors_name
    -- exe 'q'
-- endfu

-- au BufWipeout  color_scheme_picker call Close_Color_scheme_picker()
-- au CursorMoved color_scheme_picker call Maybe_update_color()
-- au BufEnter    color_scheme_picker nnoremap <buffer> <silent> <cr> :call Select_Color_scheme()<cr>
-- command! ColorSchemePicker call Color_scheme_picker()
-- ]],
-- false)
