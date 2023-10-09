return {
  'folke/noice.nvim',
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      config = function()
        require("notify").setup({
          timeout = 3000,
          stages = "slide",
          render = "wrapped-compact",
          max_width = 80,
          top_down = false
        })
      end
      },
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true
          },
          signature = {
            enabled = false
          },
          hover = {
            enabled = false
          }
        },
        messages = {
          enabled = true,
          view = "notify",
          view_error = "popup",
          view_warn = "notify",
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true
        },
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
          -- view = "cmdline", -- classic
        },
        commands = {
          errors = {
            view = "messages",
          },
        },
        views = {
          popup = {
            position = {
              row = 10,
              col = "50%",
            },
            size = {
              width = 75,
              height = "auto"
            },
          }
        },
      })
    end
  }
