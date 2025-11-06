return {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
        log_level = "error",
        auto_session_suppress_dirs = {"~/", "/"},
        session_lens = {
            -- picker = "telescope", -- "telescope"|"snacks"|"fzf"|"select"|nil Pickers are detected automatically but you can also set one manually. Falls back to vim.ui.select
            -- load_on_setup = true, -- Only used for telescope, registers the telescope extension at startup so you can use :Telescope session-lens
            picker_opts = nil, -- Table passed to Telescope / Snacks / Fzf-Lua to configure the picker. See below for more information
            previewer = "summary", -- 'summary'|'active_buffer'|function - How to display session preview. 'summary' shows a summary of the session, 'active_buffer' shows the contents of the active buffer in the session, or a custom function
            mappings = {
                -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
                delete_session = {"i", "<C-d>"}, -- mode and key for deleting a session from the picker
                alternate_session = {"i", "<C-s>"}, -- mode and key for swapping to alternate session from the picker
                copy_session = {"i", "<C-y>"} -- mode and key for copying a session from the picker
            }
        }
    },
    keys = {
        {
            "<leader>s",
            function() require("auto-session").search() end,
            desc = "Search for a session within saved sessions"
        }
    }
}
