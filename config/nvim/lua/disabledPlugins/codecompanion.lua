return {
    "olimorris/codecompanion.nvim",
    opts = {
        memory = {
            agentsmd = {
                desciription = "Support for agents.md file",
                files = {"agents.md"}
            },
            opts = {chat = {enabled = true, default_memory = {"agentsmd"}}}
        },
        display = {
            chat = {
                window = {
                    border = "rounded",
                    layout = "vertical",
                    position = "left"
                }
            }
        },
        adapters = {
            http = {
                copilot = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        schema = {
                            model = {
                                -- default = "gpt-5"
                                default = "claude-sonnet-4.5"
                            }
                        }
                    })
                end
            }
        },
        strategies = {
            chat = {
                adapter = "copilot",
                tools = {
                    groups = {
                        ["my_tools"] = {
                            desciription = "My custom tools",
                            tools = {
                                "cmd_runner", "create_file", "file_search",
                                "grep_search", "insert_edit_into_file",
                                "read_file"
                            },
                            opts = {collapse_tools = false}
                        }
                    },
                    opts = {default_tools = { --[["mcp",]] "full_stack_dev"}}
                }
            },
            inline = {adapter = "copilot"}
        },
        extensions = {
            mcphub = {
                callback = "mcphub.extensions.codecompanion",
                opts = {
                    show_result_in_chat = true, -- Show mcp tool results in chat
                    make_vars = true, -- Convert resources to #variables
                    make_slash_commands = false, -- Add prompts as /slash commands
                    make_tools = true
                }
            }
        }
    },
    dependencies = {"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"},
    keys = {
        {
            "<leader>a",
            "<cmd>CodeCompanionActions<cr>",
            mode = {"n", "v"},
            desc = "CodeCompanion Actions"
        }, {
            "<leader>aa",
            "<cmd>CodeCompanionChat Toggle<cr>",
            desc = "CodeCompanion Chat"
        }
    }
}
-- vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
-- vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
-- vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
-- vim.cmd([[cab cc CodeCompanion]])
