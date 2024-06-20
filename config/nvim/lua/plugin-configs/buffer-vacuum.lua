return {
  "ChuufMaster/buffer-vacuum",
  config = function()
    require("buffer-vacuum").setup({
      max_buffers = 6,
    })
    vim.cmd("BufferVacuumEnable")
  end,
}
