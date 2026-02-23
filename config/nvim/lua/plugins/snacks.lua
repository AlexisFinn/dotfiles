return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        picker = {
            win = {
                input = {keys = {["<C-d>"] = {"bufdelete", mode = {"n", "i"}}}}
            },
            -- debug = {scores = true},
            layout = {preset = "ivy_split", cycle = false}
        },
        bigfile = {},
        quickfile = {},
        matcher = {frecency = true}
    },
    keys = {
        {
            "<leader>p",
            function() Snacks.picker.files({follow = true}) end,
            desc = "Snacks: Find File"
        },
        {
            "<leader>rg",
            function() Snacks.picker.grep() end,
            desc = "Snacks: Live Grep"
        }, {
            "<F8>",
            function() Snacks.picker.buffers() end,
            desc = "Snacks: Buffer Switcher",
            mode = {"n", "v"}
        }
    }
}
