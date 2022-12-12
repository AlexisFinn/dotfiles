require("iron.core").setup {
  config = {
    scratch_repl = true,
    repl_definition = {
      js = { command = {"node"} },
      typescript = { command = {"node"} },
      vue = { command = {"node"} },
      php = { command = {"php", "-a"} }
    },
    repl_open_cmd = require('iron.view').center('80%', '60%');
  }
}
