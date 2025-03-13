local float = vim.cmd.FloatermNew
return {
  "voldikss/vim-floaterm",
  keys = {
    {
      "<leader>e",
      function()
        float({
          args = {
            "--width=0.8",
            "--height=0.8",
            "--title=NodeJS",
            "--titleposition=right",
            "node",
          },
        })
      end,
      desc = "Launch Node runner",
    },
    {
      "<leader>gg",
      function()
        float({
          args = {
            "--width=1.0",
            "--height=1.0",
            "--title=LazyGit",
            "--titleposition=right",
            "lazygit",
          },
        })
      end,
      desc = "Open LazyGit",
    },
  },
}
