vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

require('auto-session').setup {
  log_level = "error",
  -- post_restore_cmds = {"LspRestart"}
}