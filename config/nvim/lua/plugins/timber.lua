return {
    "Goose97/timber.nvim",
    -- version = "main", -- Use for stability; omit to use `main` branch for the latest features
    commit = "5791b348f0f1dd9a52a387c2518f0799e3ba8a43",
    event = "VeryLazy",
    config = function()
        require("timber").setup({
            log_templates = {
                default = {
                    javascript = [[
                      console.log("----------------------- > %log_target");
                      console.dir(%log_target, {depth: 5});
                      console.log("----------------------- < %log_target");
                    ]],
                    vue = [[
                      console.log("----------------------- > %log_target");
                      console.dir(%log_target, {depth: 5});
                      console.log("----------------------- < %log_target");
                    ]]
                }
            },
            keymaps = {
                insert_log_below = "<leader>cl",
                insert_log_above = "<leader>cL"
            }
        })
    end
}
