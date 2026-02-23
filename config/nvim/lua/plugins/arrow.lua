return {
    "otavioschwanck/arrow.nvim",
    dependencies = {{"nvim-tree/nvim-web-devicons"}},
    opts = {
        show_icons = true,
        leader_key = '\\' -- Recommended to be a single key
    },
    keys = {
        {
            "<leader>bs",
            function() require("arrow.persist").toggle() end,
            desc = "Toggle Arrow persistence"
        }, {
            "<leader>bl",
            function() require("arrow.persist").previous() end,
            desc = "Switch to previous Arrow persisted file"
        }, {
            "<leader>bn",
            function() require("arrow.persist").next() end,
            desc = "Switch to next Arrow persisted file"
        }
    }
}
