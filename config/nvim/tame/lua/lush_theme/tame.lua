--
-- Built with,
--
--        ,gggg,
--       d8" "8I                         ,dPYb,
--       88  ,dP                         IP'`Yb
--    8888888P"                          I8  8I
--       88                              I8  8'
--       88        gg      gg    ,g,     I8 dPgg,
--  ,aa,_88        I8      8I   ,8'8,    I8dP" "8I
-- dP" "88P        I8,    ,8I  ,8'  Yb   I8P    I8
-- Yb,_,d88b,,_   ,d8b,  ,d8b,,8'_   8) ,d8     I8,
--  "Y8P"  "Y888888P'"Y88P"`Y8P' "YY8P8P88P     `Y8
--
-- This is a starter colorscheme for use with Lush,
-- for usage guides, see :h lush or :LushRunTutorial
--
-- Note: Because this is a lua file, vim will append it to the runtime,
--       which means you can require(...) it in other lua code (this is useful),
--       but you should also take care not to conflict with other libraries.
--
--       (This is a lua quirk, as it has somewhat poor support for namespacing.)
--
--       Basically, name your file,
--
--       "super_theme/lua/lush_theme/super_theme_dark.lua",
--
--       not,
--
--       "super_theme/lua/dark.lua".
--
--       With that caveat out of the way...
--
-- Enable lush.ify on this file, run:
--
--  `:Lushify`
--
--  or
--
--  `:lua require('lush').ify()`
-- stylua: ignore start
local lush = require("lush")
local hsl = lush.hsl

local NvimDarkBlue = hsl(199, 31, 23)
local NvimDarkCyan = hsl(180, 33, 23)
local NvimDarkGreen = hsl(142, 43, 17)
local NvimDarkMagenta = hsl(302, 100, 14)
local NvimDarkRed = hsl(352, 100, 17)
local NvimDarkYellow = hsl(45, 100, 21)
local NvimLightBlue = hsl(205, 100, 83)
local NvimLightCyan = hsl(179, 86, 76)
local NvimLightGreen = hsl(142, 74, 83)
local NvimLightMagenta = hsl(300, 100, 89)
local NvimLightRed = hsl(6, 100, 86)
local NvimLightYellow = hsl(42, 96, 78)
local NvimLightGrey1 = hsl(222, 34, 95)
local NvimLightGrey2 = hsl(225, 22, 90)
local NvimLightGrey3 = hsl(226, 10, 78)
local NvimLightGrey4 = hsl(222, 6, 63)
local NvimDarkGrey4 = hsl(220, 6, 33)
local NvimDarkGrey3 = hsl(220, 8, 19)
local NvimDarkGrey2 = hsl(220, 14, 9)
local NvimDarkGrey1 = hsl(225, 30, 4)

-- LSP/Linters mistakenly show `undefined global` errors in the spec, they may
-- support an annotation like the following. Consult your server documentation.
---@diagnostic disable: undefined-global
local theme = lush(function(injected_functions)
    local sym = injected_functions.sym
    return {
        -- The following are the Neovim (as of 0.8.0-dev+100-g371dfb174) highlight
        -- groups, mostly used for styling UI elements.
        -- Comment them out and add your own properties to override the defaults.
        -- An empty definition `{}` will clear all styling, leaving elements looking
        -- like the 'Normal' group.
        -- To be able to link to a group, it must already be defined, so you may have
        -- to reorder items as you go.
        --
        -- See :h highlight-groups
        --
        -- TelescopeNormal {fg = chalk_base.darken(20)}, TelescopeSelection {
        --     bg = chalk_board.lighten(5),
        --     fg = chalk_base,
        --     gui = 'italic'
        -- }, -- Currently selected item in Telescope.
        -- ColorColumn {bg = chalk_board.lighten(5)}, -- Columns set with 'colorcolumn'
        -- Conceal        { }, -- Placeholder characters substituted for concealed text (see 'conceallevel')
        -- Cursor         { }, -- Character under the cursor
        -- CurSearch {bg = chalk_pink, fg = chalk_board}, -- Highlighting a search pattern under the cursor (see 'hlsearch')
        -- lCursor        { }, -- Character under the cursor when |language-mapping| is used (see 'guicursor')
        -- CursorIM       { }, -- Like Cursor, but used when in IME mode |CursorIM|
        -- CursorColumn   { }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
        -- CursorLine     { }, -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
        -- Directory      { }, -- Directory names (and other special names in listings)
        -- DiffAdd        { }, -- Diff mode: Added line |diff.txt|
        -- DiffChange     { }, -- Diff mode: Changed line |diff.txt|
        -- DiffDelete     { }, -- Diff mode: Deleted line |diff.txt|
        -- DiffText       { }, -- Diff mode: Changed text within a changed line |diff.txt|
        -- EndOfBuffer    { }, -- Filler lines (~) after the end of the buffer. By default, this is highlighted like |hl-NonText|.
        -- TermCursor     { }, -- Cursor in a focused terminal
        -- TermCursorNC   { }, -- Cursor in an unfocused terminal
        -- ErrorMsg       { }, -- Error messages on the command line
        -- VertSplit      { }, -- Column separating vertically split windows
        -- Folded         { }, -- Line used for closed folds
        -- FoldColumn     { }, -- 'foldcolumn'
        -- SignColumn     { }, -- Column where |signs| are displayed
        -- IncSearch      { bg = chalk_foam,  }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
        -- Substitute {bg = chalk_purple, fg = chalk_board}, -- |:substitute| replacement text highlighting
        -- LineNr         { }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
        -- LineNrAbove    { }, -- Line number for when the 'relativenumber' option is set, above the cursor line
        -- LineNrBelow    { }, -- Line number for when the 'relativenumber' option is set, below the cursor line
        -- CursorLineNr {bg = chalk_board, fg = chalk_blue, bold = true}, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
        -- CursorLineFold { }, -- Like FoldColumn when 'cursorline' is set for the cursor line
        -- CursorLineSign { }, -- Like SignColumn when 'cursorline' is set for the cursor line
        -- MatchParen     { }, -- Character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
        -- ModeMsg        { }, -- 'showmode' message (e.g., "-- INSERT -- ")
        -- MsgArea        { }, -- Area for messages and cmdline
        -- MsgSeparator   { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
        -- MoreMsg        { }, -- |more-prompt|
        -- NonText        { }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
        Normal {fg = NvimLightGrey1.darken(10), bg = NvimDarkGrey2}, -- Normal text
        -- NormalFloat    { }, -- Normal text in floating windows.
        -- FloatBorder    { }, -- Border of floating windows.
        -- FloatTitle     { }, -- Title of floating windows.
        -- NormalNC       { }, -- normal text in non-current windows
        -- Pmenu          { }, -- Popup menu: Normal item.
        -- PmenuSel {fg = chalk_pink, bg = chalk_foam}, -- Popup menu: Selected item.
        -- PmenuKind      { }, -- Popup menu: Normal item "kind"
        -- PmenuKindSel   { }, -- Popup menu: Selected item "kind"
        -- PmenuExtra     { }, -- Popup menu: Normal item "extra text"
        -- PmenuExtraSel  { }, -- Popup menu: Selected item "extra text"
        -- PmenuSbar      { }, -- Popup menu: Scrollbar.
        -- PmenuThumb     { }, -- Popup menu: Thumb of the scrollbar.
        -- Question       { }, -- |hit-enter| prompt and yes/no questions
        -- QuickFixLine   { }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
        -- Search {bg = chalk_purple, fg = chalk_board}, -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
        -- SpecialKey     { }, -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
        -- SpellBad       { }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
        -- SpellCap       { }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
        -- SpellLocal     { }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
        -- SpellRare      { }, -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
        -- StatusLine     { }, -- Status line of current window
        -- StatusLineNC   { }, -- Status lines of not-current windows. Note: If this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
        -- TabLine        { }, -- Tab pages line, not active tab page label
        -- TabLineFill    { }, -- Tab pages line, where there are no labels
        -- TabLineSel     { }, -- Tab pages line, active tab page label
        -- Title          { }, -- Titles for output from ":set all", ":autocmd" etc.
        -- Visual {bg = chalk_board.lighten(10)}, -- Visual mode selection
        -- VisualNOS      { }, -- Visual mode selection when vim is "Not Owning the Selection".
        -- WarningMsg     { }, -- Warning messages
        -- Whitespace     { }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
        -- Winseparator   { }, -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.
        -- WildMenu       { }, -- Current match in 'wildmenu' completion
        -- WinBar         { }, -- Window bar of current window
        -- WinBarNC       { }, -- Window bar of not-current windows
        -- Common vim syntax groups used for all kinds of code and markup.
        -- Commented-out groups should chain up to their preferred (*) group
        -- by default.
        --
        -- See :h group-name
        --
        -- Uncomment and edit if you want more specific syntax highlighting.
        -- Comment({fg = chalk_foam}), -- Any comment
        -- Constant       { }, -- (*) Any constant
        String {fg = NvimLightGreen.darken(10).desaturate(10)}, --   A string constant: "this is a string"
        -- Character      { }, --   A character constant: 'c', '\n'
        -- Number         { }, --   A number constant: 234, 0xff
        -- Boolean        { }, --   A boolean constant: TRUE, false
        -- Float          { }, --   A floating point constant: 2.3e10
        -- Identifier     { }, -- (*) Any variable name
        Function {fg = NvimLightCyan.darken(40).desaturate(40)}, --   Function name (also: methods for classes)
        -- Function       { Normal }, --   Function name (also: methods for classes)
        Statement {fg = NvimLightGrey2.darken(10).desaturate(10), gui = "bold"}, -- (*) Any statement
        -- Conditional    { }, --   if, then, else, endif, switch, etc.
        -- Repeat         { }, --   for, do, while, etc.
        -- Label          { }, --   case, default, etc.
        -- Operator       { }, --   "sizeof", "+", "*", etc.
        -- Keyword {fg = chalk_base, gui = "italic"}, --   any other keyword
        -- Exception      { }, --   try, catch, throw
        -- PreProc        { }, -- (*) Generic Preprocessor
        -- Include        { }, --   Preprocessor #include
        -- Define         { }, --   Preprocessor #define
        -- Macro          { }, --   Same as Define
        -- PreCondit      { }, --   Preprocessor #if, #else, #endif, etc.
        -- Type           { }, -- (*) int, long, char, etc.
        -- StorageClass   { }, --   static, register, volatile, etc.
        -- Structure      { }, --   struct, union, enum, etc.
        -- Typedef        { }, --   A typedef
        -- Special {fg = chalk_teal}, -- (*) Any special symbol
        -- SpecialChar {}, --   Special character in a constant
        -- Tag            { }, --   You can use CTRL-] on this
        -- Delimiter      { }, --   Character that needs attention
        -- SpecialComment { }, --   Special things inside a comment (e.g. '\n')
        -- Debug          { }, --   Debugging statements
        -- Underlined     { gui = "underline" }, -- Text that stands out, HTML links
        -- Ignore         { }, -- Left blank, hidden |hl-Ignore| (NOTE: May be invisible here in template)
        -- Error          { }, -- Any erroneous construct
        -- Todo           { }, -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX
        -- These groups are for the native LSP client and diagnostic system. Some
        -- other LSP clients may use these groups, or use their own. Consult your
        -- LSP client's documentation.
        -- See :h lsp-highlight, some groups may not be listed, submit a PR fix to lush-template!
        --
        -- LspReferenceText            { } , -- Used for highlighting "text" references
        -- LspReferenceRead            { } , -- Used for highlighting "read" references
        -- LspReferenceWrite           { } , -- Used for highlighting "write" references
        -- LspCodeLens                 { } , -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
        -- LspCodeLensSeparator        { } , -- Used to color the seperator between two or more code lens.
        -- LspSignatureActiveParameter { } , -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.
        -- See :h diagnostic-highlights, some groups may not be listed, submit a PR fix to lush-template!
        --
        -- DiagnosticError {fg = error}, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        -- DiagnosticWarn {fg = error}, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        -- DiagnosticInfo             { } , -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        -- DiagnosticHint {fg = error.rotate(-90).lighten(20)}, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        -- DiagnosticOk               { } , -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        -- DiagnosticVirtualTextError {fg = error}, -- Used for "Error" diagnostic virtual text.
        -- DiagnosticVirtualTextWarn {fg = error}, -- Used for "Warn" diagnostic virtual text.
        -- DiagnosticVirtualTextInfo  { } , -- Used for "Info" diagnostic virtual text.
        -- DiagnosticVirtualTextHint {fg = error.rotate(-90).lighten(20)}, -- Used for "Hint" diagnostic virtual text.
        -- DiagnosticVirtualTextOk    { } , -- Used for "Ok" diagnostic virtual text.
        -- DiagnosticUnderlineError {}, -- Used to underline "Error" diagnostics.
        -- DiagnosticUnderlineWarn {}, -- Used to underline "Warn" diagnostics.
        -- DiagnosticUnderlineInfo {}, -- Used to underline "Info" diagnostics.
        -- DiagnosticUnderlineHint {}, -- Used to underline "Hint" diagnostics.
        -- DiagnosticUnderlineOk {}, -- Used to underline "Ok" diagnostics.
        -- DiagnosticFloatingError    { } , -- Used to color "Error" diagnostic messages in diagnostics float. See |vim.diagnostic.open_float()|
        -- DiagnosticFloatingWarn     { } , -- Used to color "Warn" diagnostic messages in diagnostics float.
        -- DiagnosticFloatingInfo     { } , -- Used to color "Info" diagnostic messages in diagnostics float.
        -- DiagnosticFloatingHint     { } , -- Used to color "Hint" diagnostic messages in diagnostics float.
        -- DiagnosticFloatingOk       { } , -- Used to color "Ok" diagnostic messages in diagnostics float.
        -- DiagnosticSignError        { } , -- Used for "Error" signs in sign column.
        -- DiagnosticSignWarn         { } , -- Used for "Warn" signs in sign column.
        -- DiagnosticSignInfo         { } , -- Used for "Info" signs in sign column.
        -- DiagnosticSignHint         { } , -- Used for "Hint" signs in sign column.
        -- DiagnosticSignOk           { } , -- Used for "Ok" signs in sign column.
        javaScriptBraces {fg = Function.fg, gui = "bold"}, -- JavaScript Braces
        -- Tree-Sitter syntax groups.
        --
        -- See :h treesitter-highlight-groups, some groups may not be listed,
        -- submit a PR fix to lush-template!
        --
        -- Tree-Sitter groups are defined with an "@" symbol, which must be
        -- specially handled to be valid lua code, we do this via the special
        -- sym function. The following are all valid ways to call the sym function,
        -- for more details see https://www.lua.org/pil/5.html
        --
        -- sym("@text.literal")
        -- sym('@text.literal')
        -- sym"@text.literal"
        -- sym'@text.literal'
        --
        -- For more information see https://github.com/rktjmp/lush.nvim/issues/109
        -- sym"@text.literal"      { }, -- Comment
        -- sym"@text.reference"    { }, -- Identifier
        -- sym"@text.title"        { }, -- Title
        -- sym"@text.uri"          { }, -- Underlined
        -- sym"@text.underline"    { }, -- Underlined
        -- sym"@text.todo"         { }, -- Todo
        -- sym"@comment"           { }, -- Comment
        -- sym"@punctuation"       { }, -- Delimiter
        -- sym"@constant"          { }, -- Constant
        -- sym"@constant.builtin"  { }, -- Special
        -- sym"@constant.macro"    { }, -- Define
        -- sym"@define"            { }, -- Define
        -- sym"@macro"             { }, -- Macro
        -- sym"@string"            { }, -- String
        -- sym"@string.escape"     { }, -- SpecialChar
        -- sym"@string.special"    { }, -- SpecialChar
        -- sym"@character"         { }, -- Character
        -- sym"@character.special" { }, -- SpecialChar
        -- sym"@number"            { }, -- Number
        -- sym"@boolean"           { }, -- Boolean
        -- sym"@float"             { }, -- Float
        -- sym"@function"          { }, -- Function
        -- sym"@function.builtin"  { }, -- Special
        -- sym"@function.macro"    { }, -- Macro
        -- sym"@parameter"         { }, -- Identifier
        -- sym"@method"            { }, -- Function
        -- sym"@field"             { }, -- Identifier
        -- sym"@property"          { }, -- Identifier
        -- sym"@constructor"       { }, -- Special
        -- sym"@conditional"       { }, -- Conditional
        -- sym"@repeat"            { }, -- Repeat
        -- sym"@label"             { }, -- Label
        -- sym"@operator"          { }, -- Operator
        -- sym "@keyword" {fg = chalk_pink}, -- Keyword
        -- sym"@exception"         { }, -- Exception
        sym "@variable" {fg = NvimLightGrey2.darken(20)} -- Identifier
        -- sym "@lsp.type.member.javascript" {fg = NvimDarkRed},
        -- sym "@lsp.type.property.javascript" {
        --     fg = NvimDarkBlue.lighten(20).desaturate(20)
        -- }
        -- sym "@lsp.type.property.javascript" {
        --     fg = NvimLightGrey2.darken(20),
        --     gui = "italic"
        -- }

        -- Markdown syntax highlighting (traditional syntax groups)
        -- markdownH1 {fg = chalk_blue, gui = "bold"}, -- # Heading 1
        -- markdownH2 {fg = chalk_blue.lighten(10), gui = "bold"}, -- ## Heading 2
        -- markdownH3 {fg = chalk_blue.lighten(20), gui = "bold"}, -- ### Heading 3
        -- markdownH4 {fg = chalk_blue.lighten(30), gui = "bold"}, -- #### Heading 4
        -- markdownH5 {fg = chalk_blue.lighten(40), gui = "bold"}, -- ##### Heading 5
        -- markdownH6 {fg = chalk_blue.lighten(50), gui = "bold"}, -- ###### Heading 6

        -- markdownHeadingDelimiter {fg = chalk_pink}, -- # ## ### etc.
        -- markdownHeadingRule {fg = chalk_pink}, -- --- === underlines
        -- markdownBold {fg = chalk_base, gui = "bold"}, -- **bold** __bold__
        -- markdownItalic {fg = chalk_base, gui = "italic"}, -- *italic* _italic_
        -- markdownBoldItalic {fg = chalk_base, gui = "bold,italic"}, -- ***bold italic***

        -- markdownCode {fg = chalk_green, bg = chalk_board.lighten(5)}, -- `inline code`
        -- markdownCodeBlock {fg = chalk_green, bg = chalk_board.lighten(5)}, -- ```code blocks```
        -- markdownCodeDelimiter {fg = chalk_foam}, -- ``` delimiters
        -- markdownUrl {fg = chalk_purple, gui = "underline"}, -- URLs
        -- markdownLink {fg = chalk_teal}, -- [link text]
        -- markdownLinkText {fg = chalk_teal}, -- Link text inside []
        -- markdownLinkDelimiter {fg = chalk_foam}, -- [] and ()
        -- markdownLinkTextDelimiter {fg = chalk_foam}, -- [] delimiters
        -- markdownListMarker {fg = chalk_pink}, -- * - + list markers
        -- markdownOrderedListMarker {fg = chalk_pink}, -- 1. 2. 3. numbered lists
        -- markdownBlockquote {fg = chalk_foam, gui = "italic"}, -- > blockquotes
        -- markdownRule {fg = chalk_pink}, -- --- horizontal rules
        -- Additional elements
        -- markdownId {fg = chalk_purple}, -- Link references
        -- markdownIdDeclaration {fg = chalk_teal}, -- Link reference declarations
        -- markdownIdDelimiter {fg = chalk_foam}, -- Link reference delimiters
        -- markdownFootnote {fg = chalk_purple}, -- Footnotes
        -- markdownFootnoteDefinition {fg = chalk_purple}, -- Footnote definitions
        -- HTML in markdown
        -- htmlTag {fg = chalk_teal}, -- HTML tags
        -- htmlEndTag {fg = chalk_teal}, -- HTML end tags
        -- htmlTagName {fg = chalk_pink}, -- HTML tag names
        -- htmlArg {fg = chalk_purple}, -- HTML attributes
        -- htmlSpecialChar {fg = chalk_yellow}, -- HTML entities
        -- Strike-through (if supported)
        -- markdownStrike {fg = chalk_foam, gui = "strikethrough"} -- ~~strikethrough~~
    }
end)

-- Return our parsed theme for extension or use elsewhere.
return theme

-- vi:nowrap
-- stylua: ignore end
