-- auto run php-cs-fixer on save
vim.api.nvim_command('autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()')

--vim.g.php_cs_fixer_config_file = ".php_cs"

