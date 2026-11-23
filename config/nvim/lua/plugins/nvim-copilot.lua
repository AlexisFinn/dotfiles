return {
    -- 'github/copilot.vim', -- official
    "zbirenbaum/copilot.lua", -- lua re-write
    cmd = "Copilot",
    event = "VeryLazy",
    requires = {
        "copilotlsp-nvim/copilot-lsp" -- (optional) for NES functionality
    },
    config = function()
        require("copilot").setup({
            -- copilot_model = "gpt-5-mini",
            -- copilot_model = "gpt-41-copilot",
            -- copilot_model = "gpt-51-copilot",
            panel = {enabled = false, keymap = {open = "<C-s>"}},
            suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = false,
                keymap = {accept = "<C-y>"}
            },
            completion = {
                ghost_text = {enabled = true},
                menu = {auto_show = false}
            },
            server_opts_overrides = {
                settings = {enable = false, inlineSuggest = {enable = false}}
            },
            nes = {
                enabled = false,
                keymap = {
                    accept_and_goto = "<C-i>",
                    accept = false,
                    dismiss = "<Esc>"
                }
            }
        })
    end
}
