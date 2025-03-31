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
  opts = {
    options = {
      -- icons_enabled = true,
      theme = "ayu_mirage",
      -- component_separators = { left = "", right = "" },
      -- section_separators = { left = "", right = "" },
      disabled_filetypes = {},
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { { "filename", path = 3 } },
      lualine_c = { { "macro-recording", fmt = show_macro_recording, color = "error" } },
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
  },
}
