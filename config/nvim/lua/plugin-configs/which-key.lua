return {
  'folke/which-key.nvim',
  lazy = false,
  config = function()
    local telescope = require("telescope.builtin")
    local telescopeExt = require("telescope").extensions
    local cmd = vim.cmd
    local float = vim.cmd.FloatermNew

    require 'which-key'.setup{
      window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
      },
      layout = {
        height = { min = 4, max = 20 }
      },
      -- triggers = {"<leader>"},
    }

    -- ### VISUAL MODE ###
    require 'which-key'.register({
      ["<leader>"] = {
        q = {"<cmd>q<CR>", "Quit/Close window"},
        f = {
          w = {function() cmd("Telescope grep_string") end, "Grep current word or selection in project"},
        },
      }
    },{mode = "v"})

    -- ### NORMAL MODE ###
    require 'which-key'.register({
      -------------------------- LEADER PREFIXED -----------------------------
      ["<leader>"] = {
        ["["] = {function() cmd("SplitjoinSplit") end, "Split code structure into multiple lines"},
        ["]"] = {function() cmd("SplitjoinJoin") end, "Join code structure into single line"},
        b = {
          name = "GOLANG Debug",
          b = {function() cmd("GoBreakToggle") end, "Toggle Dap Breakpoint"},
          d = {function() cmd("GoDbgStop") end, "Stop Go Debug"},
          n = {function() cmd("GoDbgContinue") end, "Continue to next Breakpoint"},
          s = {function() cmd("GoDebug") end, "Start Go Debug"}
        },
        d = {
          name = "buffer(s)",
          a = {function()
            -- %bd (delete all buffers)
            -- e# (re-open last buffer)
            -- bd# (delete the empty buffer that was created in the process)
            cmd("%bd|e#|bd#")
          end, "Delete all other buffers"},
          A = {function() cmd("%bd") end, "Delete all buffers"},
          d = {"<cmd>bd<CR>", "Delete current buffer"},
          l = {function() cmd("e#") end, "Switch to last buffer"},
        },
        e = {function() float({
          args = {
            "--width=0.8",
            "--height=0.8",
            "--title=NodeJS",
            "--titleposition=right",
            "node"
          }
        }) end, "Launch Node runner"},
        f = {
          w = {function() cmd("Telescope grep_string") end, "Grep current word or selection in project"},
        },
        g = {
          name = "git",
          a = {function() cmd("Git add %") end, "Add current file to git commit"},
          g = {function() float({
            args = {
              "--width=1.0",
              "--height=1.0",
              "--title=LazyGit",
              "--titleposition=right",
              "lazygit",
            }
          }) end, "Open LazyGit"},
          h = {
            name = "git hunk",
            n = {function() cmd("Gitsigns next_hunk") end, "Git goto next hunk"},
            N = {function() cmd("Gitsigns prev_hunk") end, "Git goto previous hunk"},
            p = {function() cmd("Gitsigns preview_hunk") end, "Git preview hunk diff"},
            s = {function() cmd("Gitsigns stage_hunk") end, "Git stage current hunk"},
            u = {function() cmd("Gitsigns undo_stage_hunk") end, "Git undo current hunk"},

          }
        },
        j = {"<C-W><C-J>", "Focus Window UP"},
        k = {"<C-W><C-K>", "Focus Window DOWN"},
        l = {"<C-W><C-L>", "Focus Window RIGHT"},
        h = {"<C-W><C-H>", "Focus Window LEFT"},
        L = {function() cmd("Lazy") end, "Open Lazy plugin manager"},
        n = {function() require("config.nvim.lua.plugin-configs.global_note").toggle_note('project') end, "Toggle Global Note"},
        o = {function() telescopeExt.project.project() end, "Search for project"},
        p = {function() telescope.find_files() end, "Search for a file within the project"},
        q = {"<cmd>q<CR>", "Quit/Close window"},
        s = {function() require("auto-session.session-lens").search_session() end, "Search fo a session within saved sessions"},
        ["-"] = {function() cmd("split") end, "Split window horizontally"},
        t = {
          name = "Lsp",
          n = {function() vim.diagnostic.goto_next({float = {border = "rounded"}}) end, "Go to Next lsp error"},
          N = {function() vim.diagnostic.goto_prev({float = {border = "rounded"}}) end, "Go to Previous lsp error"},
          t = {function() vim.diagnostic.open_float({border = "rounded"}) end, "Show current lsp error"},
          r = {function() cmd("LSPRestart") end, "Restart lsp server"},
        },
        ["|"] = {function() cmd("vsplit") end, "Split window vertically"},
        r = {
          name = "RipGrep",
          g = {function() telescope.live_grep() end, "Search for a word or sentence withen the project files"}
        },
        R = {function() telescope.registers() end, "Search through registers with Telescope"},
        w = {"<cmd>w<cr>", "Write changes", noremap=true},
        W = {function() cmd("wa") end, "Write All changes"},
        Z = {function() cmd("TSHighlightCapturesUnderCursor") end, "Get nvim highlight group of word under cursor"}
      },
      -- ['<leader>w'] = {function() cmd("w") end, "Write changes", noremap=true},
      -------------------------- OTHER -----------------------------
      ["<F8>"] = {function() require('reach').buffers({show_current = true}) end, "Buffer switcher"},
      -- ["<F8>"] = {function() telescope.buffers() end, "Buffer switcher"},
      ["<F9>"] = {function() require('oil').open_float() end, "Oil file manager"},
      -- ["<F9>"] = {function()
      --   float({
      --     args = {
      --       "--width=0.9",
      --       "--height=0.9",
      --       "--title=Ranger",
      --       "--opener=edit",
      --       "--titleposition=right",
      --       "ranger",
      --       "%",
      --     },
      --   })
      -- end, "Open Ranger file manager"},
      ["<C-s>"] = {function() cmd("noh") end, "Remove all search highlights"},
      ["<C-PageUp>"] = {function() cmd("bp") end, "Move buffer left"},
      ["<C-PageDown>"] = {function() cmd("bn") end, "Move buffer right"},
      m = {
        name = "Bookmarks",
        a = {function() cmd("BookmarkShowAll") end, "Show all bookmarks"},
        c = {function() cmd("BookmarkClear") end, "Clear all bookmarks in current buffer"},
        i = {function() cmd("BookmarkAnnotate") end, "Add/Remove/Edit annotation on current line"},
        m = {function() cmd("BookmarkToggle") end, "Toggle bookmark on current line"},
        n = {function() cmd("BookmarkNext") end, "Go to next bookmark"},
        p = {function() cmd("BookmarkPrev") end, "Go to previous bookmark"},
        x = {function() cmd("BookmarkClearAll") end, "Clear all bookmarks in current project"}
      },
    })
  end
}
