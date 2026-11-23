return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        input = {enabled = true},
        picker = {
            enabled = true,
            actions = {
                opencode_send = function(...)
                    return require("opencode").snacks_picker_send(...)
                end
            },
            win = {
                input = {
                    keys = {
                        ["<C-d>"] = {"bufdelete", mode = {"n", "i"}},
                        ["<o-s>"] = {"opencode_send", mode = {"n", "i"}}
                    }
                }
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
