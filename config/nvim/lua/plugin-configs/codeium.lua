return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function()
    vim.keymap.set('i', '<D-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
    vim.keymap.set('i', '<D-Bar>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
  end
}
