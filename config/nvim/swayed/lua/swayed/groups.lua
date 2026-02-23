local M = {}

-- Palette derived from the original swayed Lush theme (converted to hex)
local colors = {
  -- base
  fg = "#D1DBE0",        -- chalk_base
  bg = "#101414",        -- chalk_board
  black = "#000000",     -- chalk_board_darken_70

  -- accents
  comment = "#526D7A",   -- chalk_foam
  number = "#A3C99C",    -- chalk_green
  string = "#EBE0AD",    -- chalk_yellow
  cyan = "#7AAEB8",      -- chalk_teal
  blue = "#5C9BD6",      -- chalk_blue
  magenta = "#E6B2D4",   -- chalk_pink
  purple = "#A6A6D9",    -- chalk_purple
  yellow = "#EBE0AD",    -- chalk_yellow
  green = "#A3C99C",     -- chalk_green
  red = "#602E4F",       -- error

  -- derived / utility
  white = "#FFFFFF",
  operator = "#94ACB8",  -- chalk_base_darken_20
  keyword = "#D1DBE0",   -- chalk_base
  bright_red = "#B96E9F", -- error_lighten_30
  bright_cyan = "#BDD7DB", -- chalk_teal_lighten_20
  bright_yellow = "#EBE0AD",
  bright_magenta = "#A6A6D9",

  -- UI
  menu = "#1C221C",       -- chalk_board_lighten_5
  menubg = "#1C221C",     -- chalk_board_lighten_5
  selection = "#272F27",  -- chalk_board_lighten_10
  statusline = "#94ACB8", -- chalk_base_darken_20
  cursor = "#85B4E0",     -- chalk_blue_lighten_10
  visual = "#272F27",
  nontext = "#526D7A",
  constant = "#94ACB8",

  -- semantic/function mapping
  variable = "#7AAEB8",
  type = "#A6A6D9",
  Function = "#A3C99C",
  diag_error = "#602E4F",
}

M.colors = colors

M.setup = function()
  return {
    Normal = { fg = colors.fg, bg = colors.bg },
    NormalFloat = { fg = colors.fg, bg = colors.bg },
    Comment = { fg = colors.comment, italic = true },
    Constant = { fg = colors.number},
    String = { fg = colors.string },
    Character = { fg = colors.number },
    Number = { fg = colors.number },
    Boolean = { fg = colors.cyan },
    Float = { fg = colors.number },
    FloatBorder = { fg = colors.white },
    Operator = { fg = colors.operator },
    Keyword = { fg = colors.keyword },
    Keywords = { fg = colors.keyword },
    Identifier = { fg = colors.cyan },
    Function = { fg = colors.Function },
    Statement = { fg = colors.keyword },
    Conditional = { fg = colors.blue },
    Repeat = { fg = colors.blue },
    Label = { fg = colors.cyan },
    Exception = { fg = colors.magenta },
    PreProc = { fg = colors.Function },
    Include = { fg = colors.magenta },
    Define = { fg = colors.magenta },
    Title = { fg = colors.cyan },
    Macro = { fg = colors.magenta },
    PreCondit = { fg = colors.cyan },
    Type = { fg = colors.cyan },
    StorageClass = { fg = colors.blue },
    Structure = { fg = colors.Function },
    TypeDef = { fg = colors.Function },
    Special = { fg = colors.number , italic = true },
    SpecialComment = { fg = colors.comment, italic = true },
    Error = { fg = colors.bright_red },
    Todo = { fg = colors.magenta, bold = true, italic = true },
    Underlined = { fg = colors.cyan, underline = true },

    Cursor = { fg = colors.cursor },
    CursorLineNr = { fg = colors.fg, bold = true },

    SignColumn = { bg = colors.bg },

    Conceal = { fg = colors.comment },
    CursorColumn = { bg = colors.black },
    CursorLine = { bg = colors.selection },
    ColorColumn = { bg = colors.selection },

    StatusLine = { fg = colors.statusline , bg = colors.black },
    StatusLineNC = { fg = colors.comment },
    StatusLineTerm = { fg = colors.white, bg = colors.black },
    StatusLineTermNC = { fg = colors.comment },

    Directory = { fg = colors.cyan },
    DiffAdd = { fg = colors.bg, bg = colors.number },
    DiffChange = { fg = colors.magenta },
    DiffDelete = { fg = colors.red },
    DiffText = { fg = colors.comment },

    ErrorMsg = { fg = colors.bright_red },
    VertSplit = { fg = colors.black },
    WinSeparator = { fg = colors.black },
    Folded = { fg = colors.comment },
    FoldColumn = {},
    Search = { fg = colors.black, bg = colors.number },
    IncSearch = { fg = colors.number , bg = colors.comment },
    LineNr = { fg = colors.comment },
    MatchParen = { fg = colors.fg, underline = true },
    NonText = { fg = colors.nontext },
    Pmenu = { fg = colors.white, bg = colors.menubg },
    PmenuSel = { fg = colors.white, bg = colors.selection },
    PmenuSbar = { bg = colors.bg },
    PmenuThumb = { bg = colors.selection },

    Question = { fg = colors.magenta },
    QuickFixLine = { fg = colors.black, bg = colors.yellow },
    SpecialKey = { fg = colors.nontext },

    SpellBad = { fg = colors.bright_red, underline = true },
    SpellCap = { fg = colors.yellow },
    SpellLocal = { fg = colors.yellow },
    SpellRare = { fg = colors.yellow },

    TabLine = { fg = colors.comment },
    TabLineSel = { fg = colors.white },
    TabLineFill = { bg = colors.bg },
    Terminal = { fg = colors.white, bg = colors.black },
    Visual = { bg = colors.visual },
    VisualNOS = { fg = colors.visual },
    WarningMsg = { fg = colors.yellow },
    WildMenu = { fg = colors.black, bg = colors.white },

    -- TreeSitter
    ["@error"] = { fg = colors.diag_error },
    ["@punctuation.delimiter"] = { fg = colors.fg },
    ["@punctuation.bracket"] = { fg = colors.fg },
    ["@punctuation.special"] = { fg = colors.cyan },

    ["@constant"] = { fg = colors.constant },
    ["@constant.builtin"] = { fg = colors.constant },
    ["@symbol"] = { fg = colors.magenta },

    ["@constant.macro"] = { fg = colors.constant },
    ["@string.regex"] = { fg = colors.red },
    ["@string"] = { fg = colors.string },
    ["@string.escape"] = { fg = colors.cyan },
    ["@character"] = { fg = colors.number},
    ["@number"] = { fg = colors.number },
    ["@boolean"] = { fg = colors.yellow},
    ["@float"] = { fg = colors.number },
    ["@annotation"] = { fg = colors.yellow },
    ["@attribute"] = { fg = colors.cyan },
    ["@namespace"] = { fg = colors.number},

    ["@function.builtin"] = { fg = colors.Function, bold = true},
    ["@function"] = { fg = colors.Function, bold = true },
    ["@function.macro"] = { fg = colors.Function },
    ["@parameter"] = { fg = colors.number},
    ["@parameter.reference"] = { fg = colors.number },
    ["@method"] = { fg = colors.number },
    ["@field"] = { fg = colors.number },
    ["@property"] = { fg = colors.type },
    ["@constructor"] = { fg = colors.cyan },

    ["@conditional"] = { fg = colors.blue },
    ["@repeat"] = { fg = colors.blue },
    ["@label"] = { fg = colors.cyan },

    ["@keyword"] = { fg = colors.keyword,bold = true },
    ["@keyword.function"] = { fg = colors.Function },
    ["@keyword.function.ruby"] = { fg = colors.Function },
    ["@keyword.operator"] = { fg = colors.blue },
    ["@operator"] = { fg = colors.blue },
    ["@exception"] = { fg = colors.magenta },
    ["@type"] = { fg = colors.bright_cyan },
    ["@type.builtin"] = { fg = colors.cyan, italic = true },
    ["@type.qualifier"] = { fg = colors.blue },
    ["@structure"] = { fg = colors.magenta },
    ["@include"] = { fg = colors.blue },

    ["@variable"] = { fg = colors.variable  },
    ["@variable.builtin"] = { fg = colors.variable },

    ["@text"] = { fg = colors.number },
    ["@text.strong"] = { fg = colors.number, bold = true },
    ["@text.emphasis"] = { fg = colors.yellow, italic = true },
    ["@text.underline"] = { fg = colors.number},
    ["@text.title"] = { fg = colors.blue, bold = true },
    ["@text.literal"] = { fg = colors.number},
    ["@text.uri"] = { fg = colors.yellow, italic = true },
    ["@text.reference"] = { fg = colors.number , bold = true },

    ["@tag"] = { fg = colors.cyan },
    ["@tag.attribute"] = { fg = colors.number},
    ["@tag.delimiter"] = { fg = colors.blue },

    -- Semantic
    ["@class"] = { fg = colors.cyan },
    ["@struct"] = { fg = colors.cyan },
    ["@enum"] = { fg = colors.cyan },
    ["@enumMember"] = { fg = colors.magenta },
    ["@event"] = { fg = colors.cyan },
    ["@interface"] = { fg = colors.cyan },
    ["@modifier"] = { fg = colors.cyan },
    ["@regexp"] = { fg = colors.yellow },
    ["@typeParameter"] = { fg = colors.cyan },
    ["@decorator"] = { fg = colors.cyan },

    -- LSP Semantic (0.9+)
    ["@lsp.type.class"] = { fg = colors.cyan },
    ["@lsp.type.enum"] = { fg = colors.cyan },
    ["@lsp.type.decorator"] = { fg = colors.number},
    ["@lsp.type.enumMember"] = { fg = colors.magenta },
    ["@lsp.type.function"] = { fg = colors.number},
    ["@lsp.type.interface"] = { fg = colors.bright_yellow },
    ["@lsp.type.macro"] = { fg = colors.cyan },
    ["@lsp.type.method"] = { fg = colors.number},
    ["@lsp.type.namespace"] = { fg = colors.number},
    ["@lsp.type.parameter"] = { fg = colors.number },
    ["@lsp.type.property"] = { fg = colors.bright_magenta },
    ["@lsp.type.struct"] = { fg = colors.cyan },
    ["@lsp.type.type"] = { fg = colors.yellow },
    ["@lsp.type.variable"] = { fg = colors.fg },

    -- HTML
    htmlArg = { fg = colors.magenta },
    htmlBold = { fg = colors.yellow, bold = true },
    htmlEndTag = { fg = colors.cyan },
    htmlH1 = { fg = colors.blue },
    htmlH2 = { fg = colors.blue },
    htmlH3 = { fg = colors.blue },
    htmlH4 = { fg = colors.blue },
    htmlH5 = { fg = colors.blue },
    htmlH6 = { fg = colors.blue },
    htmlItalic = { fg = colors.magenta, italic = true },
    htmlLink = { fg = colors.magenta, underline = true },
    htmlSpecialChar = { fg = colors.yellow },
    htmlSpecialTagName = { fg = colors.cyan },
    htmlTag = { fg = colors.cyan },
    htmlTagN = { fg = colors.cyan },
    htmlTagName = { fg = colors.cyan },
    htmlTitle = { fg = colors.white },

    -- Markdown
    markdownBlockquote = { fg = colors.yellow, italic = true },
    markdownBold = { fg = colors.magenta, bold = true },
    markdownCode = { fg = colors.magenta },
    markdownCodeBlock = { fg = colors.magenta },
    markdownCodeDelimiter = { fg = colors.red },
    markdownH1 = { fg = colors.blue, bold = true },
    markdownH2 = { fg = colors.blue, bold = true },
    markdownH3 = { fg = colors.blue, bold = true },
    markdownH4 = { fg = colors.blue, bold = true },
    markdownH5 = { fg = colors.blue, bold = true },
    markdownH6 = { fg = colors.blue, bold = true },
    markdownHeadingDelimiter = { fg = colors.red },
    markdownHeadingRule = { fg = colors.comment },
    markdownId = { fg = colors.magenta },
    markdownIdDeclaration = { fg = colors.cyan },
    markdownIdDelimiter = { fg = colors.magenta },
    markdownItalic = { fg = colors.yellow, italic = true },
    markdownLinkDelimiter = { fg = colors.magenta },
    markdownLinkText = { fg = colors.blue },
    markdownListMarker = { fg = colors.cyan },
    markdownOrderedListMarker = { fg = colors.red },
    markdownRule = { fg = colors.comment },

    --  Diff
    diffAdded = { fg = colors.magenta },
    diffRemoved = { fg = colors.red },
    diffFileId = { fg = colors.yellow, bold = true, reverse = true },
    diffFile = { fg = colors.nontext },
    diffNewFile = { fg = colors.magenta },
    diffOldFile = { fg = colors.red },

    debugPc = { bg = colors.menu },
    debugBreakpoint = { fg = colors.red, reverse = true },

    -- Git Signs
    GitSignsAdd = { fg = colors.number },
    GitSignsChange = { fg = colors.magenta },
    GitSignsDelete = { fg = colors.bright_red },
    GitSignsAddLn = { fg = colors.black, bg = colors.number },
    GitSignsChangeLn = { fg = colors.black, bg = colors.magenta },
    GitSignsDeleteLn = { fg = colors.black, bg = colors.bright_red },
    GitSignsCurrentLineBlame = { fg = colors.white },

    -- NvimTree
    NvimTreeNormal = { fg = colors.fg, bg = colors.menu },
    NvimTreeVertSplit = { fg = colors.bg, bg = colors.bg },
    NvimTreeRootFolder = { fg = colors.fg, bold = true },
    NvimTreeGitDirty = { fg = colors.yellow },
    NvimTreeGitNew = { fg = colors.number },
    NvimTreeImageFile = { fg = colors.blue },
    NvimTreeFolderIcon = { fg = colors.magenta },
    NvimTreeIndentMarker = { fg = colors.nontext },
    NvimTreeEmptyFolderName = { fg = colors.comment },
    NvimTreeFolderName = { fg = colors.fg },
    NvimTreeSpecialFile = { fg = colors.blue, underline = true },
    NvimTreeOpenedFolderName = { fg = colors.fg },
    NvimTreeCursorLine = { bg = colors.selection },
    NvimTreeIn = { bg = colors.selection },

    -- LSP
    DiagnosticError = { fg = colors.red },
    DiagnosticWarn = { fg = colors.yellow },
    DiagnosticInfo = { fg = colors.cyan },
    DiagnosticHint = { fg = colors.cyan },
    DiagnosticUnderlineError = { undercurl = true, sp = colors.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = colors.yellow },
    DiagnosticUnderlineInfo = { undercurl = true, sp = colors.cyan },
    DiagnosticUnderlineHint = { undercurl = true, sp = colors.cyan },
    DiagnosticSignError = { fg = colors.red },
    DiagnosticSignWarn = { fg = colors.yellow },
    DiagnosticSignInfo = { fg = colors.cyan },
    DiagnosticSignHint = { fg = colors.cyan },
    DiagnosticFloatingError = { fg = colors.red },
    DiagnosticFloatingWarn = { fg = colors.yellow },
    DiagnosticFloatingInfo = { fg = colors.cyan },
    DiagnosticFloatingHint = { fg = colors.cyan },
    DiagnosticVirtualTextError = { fg = colors.red },
    DiagnosticVirtualTextWarn = { fg = colors.yellow },
    DiagnosticVirtualTextInfo = { fg = colors.cyan },
    DiagnosticVirtualTextHint = { fg = colors.cyan },

    LspDiagnosticsDefaultError = { fg = colors.red },
    LspDiagnosticsDefaultWarning = { fg = colors.yellow },
    LspDiagnosticsDefaultInformation = { fg = colors.cyan },
    LspDiagnosticsDefaultHint = { fg = colors.cyan },
    LspDiagnosticsUnderlineError = { fg = colors.red, undercurl = true },
    LspDiagnosticsUnderlineWarning = { fg = colors.yellow, undercurl = true },
    LspDiagnosticsUnderlineInformation = { fg = colors.cyan, undercurl = true },
    LspDiagnosticsUnderlineHint = { fg = colors.cyan, undercurl = true },
    LspReferenceText = { fg = colors.yellow, bg = colors.selection },
    LspReferenceRead = { fg = colors.yellow, bg = colors.selection },
    LspReferenceWrite = { fg = colors.yellow, bg = colors.selection },
    LspCodeLens = { fg = colors.cyan },

    -- Cmp
    CmpItemAbbr = { fg = colors.white, bg = colors.bg },
    CmpItemKind = { fg = colors.white, bg = colors.bg },
    CmpItemKindMethod = { link = "@method" },
    CmpItemKindText = { link = "@text" },
    CmpItemKindFunction = { link = "@function" },
    CmpItemKindConstructor = { link = "@type" },
    CmpItemKindVariable = { link = "@variable" },
    CmpItemKindClass = { link = "@type" },
    CmpItemKindInterface = { link = "@type" },
    CmpItemKindModule = { link = "@namespace" },
    CmpItemKindProperty = { link = "@property" },
    CmpItemKindOperator = { link = "@operator" },
    CmpItemKindReference = { link = "@parameter.reference" },
    CmpItemKindUnit = { link = "@field" },
    CmpItemKindValue = { link = "@field" },
    CmpItemKindField = { link = "@field" },
    CmpItemKindEnum = { link = "@field" },
    CmpItemKindKeyword = { link = "@keyword" },
    CmpItemKindSnippet = { link = "@text" },
    CmpItemKindEvent = { link = "@constant" },
    CmpItemKindEnumMember = { link = "@field" },
    CmpItemKindConstant = { link = "@constant" },
    CmpItemKindStruct = { link = "@structure" },
    CmpItemKindTypeParameter = { link = "@parameter" },

    -- WinPicker
    WinPicker = { fg = colors.bg, bg = colors.number },
  }
end

return M
