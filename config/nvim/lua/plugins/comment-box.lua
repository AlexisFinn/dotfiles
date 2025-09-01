return {
    "LudoPinelli/comment-box.nvim",
    keys = {
        {
            "<leader>Cb",
            "<cmd>CBlcbox7<cr>",
            mode = {"n", "v"},
            desc = "Add comment box"
        }, {
            "<leader>Cls",
            "<cmd>CBlcline2<cr>",
            mode = {"n", "v"},
            desc = "Comment line start of section"
        }, {
            "<leader>Cle",
            "<cmd>CBlcline3<cr>",
            mode = {"n", "v"},
            desc = "Comment line end of section"
        }
    }
}
