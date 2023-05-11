-- fuzzy find files in project
local telescope = require("telescope")

-- default setup, see :help telescope.setup
telescope.setup({
	defaults = {
		-- layout_strategy = 'vertical', -- see :help telescope.layout
		winblend = 10,
		prompt_prefix = " ",
		selection_caret = " ",
		entry_prefix = "   ",
		path_display = { "tail" },
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})

-- load extensions into telescope
-- telescope.load_extension 'ultisnips'
telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("project")
-- telescope.load_extension 'session-lens'
