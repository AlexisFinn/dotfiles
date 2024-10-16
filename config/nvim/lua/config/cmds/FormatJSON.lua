-- Format JSON using python's json.tool
vim.api.nvim_create_user_command("FormatJSON", "%!python -m --no-ensure-ascii json.tool", {})
