return {
    "mistricky/codesnap.nvim",
    tag = "v2.0.1",
    lazy = false,
    opts = {
        show_line_number = true,
        snapshot_config = {
            code_config = {
                breadcrumbs = {enable = true, font_family = "Cascadia Code NF"},
                font_family = "Cascadia Code NF"
            },
            window = {mac_window_bar = false, margin = {x = 0, y = 0}},
            watermark = {content = ""}
        }
    }

}
