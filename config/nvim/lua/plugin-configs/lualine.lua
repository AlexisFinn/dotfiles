local function show_macro_recording()
  local recording = vim.fn.reg_recording()
  if recording ~= "" then
    return "Recording @" .. recording
  else
    return ""
  end
end

return {
  "hoob3rt/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        -- icons_enabled = true,
        theme = "ayu_mirage",
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        disabled_filetypes = {},
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { { "filename", path = 1 } },
        lualine_c = { { "macro-recording", fmt = show_macro_recording } },
        lualine_x = { { color = "Normal" } },
        lualine_y = { "filetype" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      -- extensions = { "fugitive" },
    })
  end,
}
