return {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    -- commit = "9e34b54ac652876953f0e55f879fe5652a6c86dd",
    -- commit = "32401e954ac86d6cf4953572674e9a6bbc33122a",
    config = function()
        require("tree-sitter-manager").setup({
            ensure_installed = {
                'lua', 'javascript', 'json', 'vue', 'css', 'scss', 'html',
                'typescript', 'tsx', 'go', 'gomod', 'gowork', 'gosum', 'python',
                'regex', 'sql', 'twig', 'yaml', 'xml', 'php', 'phpdoc',
                'markdown', 'markdown_inline'
            },
            -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
            -- auto_install = false, -- if enabled, install missing parsers when editing a new file
            highlight = true, -- treesitter highlighting is enabled by default
            -- languages = {}, -- override or add new parser sources
            parser_dir = vim.fn.stdpath("data") .. "/tree-sitter-manager/parser",
            query_dir = vim.fn.stdpath("data") .. "/tree-sitter-manager/queries"
        })
    end
}
