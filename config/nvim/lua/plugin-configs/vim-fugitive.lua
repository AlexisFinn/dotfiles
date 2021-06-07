--vim.api.nvim_exec(
--[[
  --function! s:close_gstatus()
    --for l:winnr in range(1, winnr('$'))
      --if !empty(getWinvar(l:winnr, 'fugitive_status'))
        --execute l:winnr.'close'
      --endif
    --endfor
  --endfunction

  --command! GstatusClose call s:close_gstatus()
--]]
--,
--false)

