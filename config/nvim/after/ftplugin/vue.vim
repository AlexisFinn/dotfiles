setlocal shiftwidth=2
setlocal softtabstop=2
let b:ale_linter_aliases = ['vue', 'javascript', 'scss', 'typescript']
let b:ale_linters = ['stylelint', 'eslint', 'vetur']
let b:ale_fixers = ['prettier', 'remove_trailing_lines', 'trim_whitespace']
let b:ale_fix_on_save = 1
let b:ale_javascript_prettier_options = '--config /home/alexis/Projets/backend/.prettierrc'
