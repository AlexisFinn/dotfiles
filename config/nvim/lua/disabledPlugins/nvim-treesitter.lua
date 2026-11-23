return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        local parsers = {
            'lua', 'javascript', 'json', 'vue', 'css', 'scss', 'html',
            'typescript', 'tsx', 'go', 'gomod', 'gowork', 'gosum', 'python',
            'regex', 'sql', 'twig', 'yaml', 'xml', 'php', 'phpdoc', 'markdown',
            'markdown_inline'
        }
        require('nvim-treesitter').install(parsers)
        vim.api.nvim_create_autocmd('FileType', {
            pattern = parsers,
            callback = function()
                -- syntax highlighting, provided by Neovim
                vim.treesitter.start()
                -- folds, provided by Neovim
                vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                vim.wo.foldmethod = 'expr'
                -- indentation, provided by nvim-treesitter
                vim.bo.indentexpr =
                    "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        })
    end
}
