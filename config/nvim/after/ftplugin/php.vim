setlocal shiftwidth=4
setlocal softtabstop=4
let b:ale_linters = ['phpstan']
let b:ale_fixers = ['php_cs_fixer', 'remove_trailing_lines', 'trim_whitespace']
let b:ale_php_phpstan_executable = '/home/alexis/Projets/backend/vendor/phpstan/phpstan/phpstan'
let b:ale_fix_on_save = 1
