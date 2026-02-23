return {
    "ziontee113/syntax-tree-surfer",
    config = function() require("syntax-tree-surfer").setup() end,
    keys = {
        {
            "gfs",
            "<cmd>STSJumpToStartOfCurrentNode<CR>",
            desc = "Jump to start of context"
        },
        {
            "gfe",
            "<cmd>STSJumpToEndOfCurrentNode<CR>",
            desc = "Jump to end of context"
        }
    }
}

