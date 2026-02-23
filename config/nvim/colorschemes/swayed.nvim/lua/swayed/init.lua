return {
    setup = function()
        -- package.path = package.path .. ";/usr/share/lua/5.4/colors.lua"
        local groups = require("swayed.groups").setup()
        for group, setting in pairs(groups) do
            vim.api.nvim_set_hl(0, group, setting)
        end
    end
}
