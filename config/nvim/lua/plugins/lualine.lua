local function show_macro_recording()
    local recording = vim.fn.reg_recording()
    if recording ~= "" then
        return "Recording @" .. recording
    else
        return ""
    end
end

local function get_project_name()
    return string.match(vim.fn.getcwd(), "[^/\\]+$")
end

local function get_arrow_status()
    local status = require("arrow.statusline")
    if status.is_on_arrow_file() then
        return status.text_for_statusline_with_icons()
    else
        return ""
    end
end

return {
    "hoob3rt/lualine.nvim",
    opts = {
        options = {
            -- icons_enabled = true,
            theme = "ayu_mirage",
            component_separators = {left = "", right = ""},
            section_separators = {left = "󰢚", right = "󰢚"},
            disabled_filetypes = {},
            globalstatus = true
        },
        sections = {
            lualine_a = {
                {"project_name", fmt = get_project_name, color = "CursorLineNr"},
                "mode"
            },
            lualine_b = {{"filename", path = 3}},
            lualine_c = {
                {"arrow-status", fmt = get_arrow_status, color = "CurSearch"},
                {"macro-recording", fmt = show_macro_recording, color = "error"}
            },
            lualine_x = {"filetype"},
            lualine_y = {
                {
                    "lsp_status",
                    color = "DiffText",
                    symbols = {separator = " 󰢚 "}
                }
            },
            lualine_z = {"location"}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {
            -- lualine_z = { { "buffers", component_separators = { left = "║", right = "║" } } },
        }
    }
}
