return {
    "greggh/claude-code.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim" -- Required for git operations
    },
    config = function()
        require("config.nvim.lua.disabledPlugins.claude-code").setup({
            window = {position = "rightb", enter_insert = false}
        })
        vim.api.nvim_set_keymap("n", "<leader>oc", "<cmd>ClaudeCode<CR>",
                                {noremap = true, silent = true})
    end
}
