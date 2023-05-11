require 'which-key'.setup{
  window = {
    border = "single", -- none, single, double, shadow
    position = "bottom", -- bottom, top
  },
  layout = {
    height = { min = 4, max = 20 }
  },
  -- triggers = {"<leader>"},
}

require 'which-key'.register({
  ["<leader>g"] = {name = "git"},
  ["<leader>gh"] = {name = "git hunk"},
  ["<leader>t"] = {name = "lsp"},
  ["<leader>rp"] = {name = "rig grep search"},
  ["m"] = {name = "bookmarks"}
})
