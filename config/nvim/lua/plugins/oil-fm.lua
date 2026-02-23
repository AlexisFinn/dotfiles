return {
    "stevearc/oil.nvim",
    dependencies = {"nvim-mini/mini.icons"},
    opts = {
        columns = {"icon", "permissions", "size"},
        view_options = {show_hidden = true},
        keymaps = {["<Esc>"] = "actions.close", ["q"] = "actions.close"}
    },
    keys = {{"<F9>", function() require("oil").open() end}},
    lazy = false
}
