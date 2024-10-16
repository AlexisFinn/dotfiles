return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    log_level = "error",
    auto_session_suppress_dirs = { "~/", "/" },
  },
  keys = {
    { "<leader>s", function() require("auto-session.session-lens").search_session() end, desc = "Search fo a session within saved sessions" },
  },
}
