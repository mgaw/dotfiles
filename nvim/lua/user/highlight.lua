local colors = require('user.colors')

require('lib.set_highlights')({
    -- Unset @constant highlights. These will usually also be @variable/Identifier (lua) or
    -- @type/Type (typescript).
    ['@constant'] = {},
    -- Don't highlight URIs in comments in a special way, it's too jarring.
    ['@text.uri.comment'] = {},
    ['@string.special.url'] = {},

    Normal = {
        colors.white,
        '@variable',
        '@module',
        '@markup.link',
        '@keyword.directive.scss',
        'SnacksPickerDir',
        'SnacksPickerFile',
    },
    -- Don't link these to Normal, as otherwise they don't apply when embedded in strings.
    -- E.g. `f"{bla}"` in python or `"$bla"` in bash.
    -- I think maybe Normal has a low precedence?
    Identifier = {
        colors.white,
    },
    Operator = {
        colors.light_orange,
        '@keyword.operator', -- "in" in python
    },
    String = colors.green,

    Function = {
        colors.violet,
        '@attribute', -- python decorators (that are not called)
        '@attribute.builtin', -- python decorators (that are not called)
        'AerialFunction',
        'AerialMethod',
    },
    ['@function.builtin'] = colors.cyan, -- "print", "len" etc in python; "require", "pairs" in lua

    Type = {
        colors.violet,
        '@constructor',
        '@tag',
        '@tag.builtin',
        '@type.builtin',
        'AerialClass',
        'AerialInterface',
    },

    Constant = { -- "true" in typescript
        colors.light_green,
        '@constant.builtin', -- "None" in python
        '@string.scss',
        '@number.scss',
    },

    ['@variable.parameter'] = { -- function parameters
        colors.grey_blue,
        '@tag.attribute',
        '@property', -- TS object keys
        '@variable.member', -- lua table keys, TS object keys
        'diffAdded',
        '@variable.scss',
        '@tag.scss',
    },
    ['@variable.builtin'] = '#b2b2b2', -- "self", "cls" in python; "this" in JS/TS

    Delimiter = {
        '#adb4b6', -- lighter shade of grey_blue, picked from https://www.color-hex.com/color/8a9597
        '@operator', -- "=" in python
        '@punctuation', -- e.g. commas, parens around function calls
        '@punctuation.special', -- TSX optional interface element
        '@tag.delimiter', -- e.g. `<` and `>` in TSX
        '@constructor.lua', -- curly braces in lua (table constructor)
        'vimParenSep',
    },

    Statement = {
        colors.light_grey_blue,
        bold = true,
        'Conditional',
        'Repeat',
        '@type.qualifier',
    },

    Comment = { colors.mid_grey_blue, italic = true, 'PmenuExtra' },
    Todo = { colors.grey_blue, italic = true, bold = true, '@comment.todo.comment' },
    Underlined = { colors.white, underline = true },
    NonText = colors.lightgrey,
    SpecialKey = colors.grey,
    Special = colors.light_green,
    Structure = colors.beige,
    PreProc = colors.grey_blue,
    Directory = '#dad085',
    Error = { bg = '#602020' },
    MatchParen = { bg = colors.selection },

    Title = { colors.light_grey_blue, italic = true },

    Cursor = { bg = '#b0d0f0' },
    Visual = {
        bg = colors.selection,
        'LspReferenceText',
        'LspReferenceRead',
        'LspReferenceWrite',
    },
    LineNr = colors.dark_grey_blue,
    CursorLineNr = colors.light_grey_blue,
    CursorLine = { bg = colors.cursorline },

    QuickFixLine = { bg = colors.cursorline }, -- used by aerial.nvim

    SignColumn = { bg = 'none' },

    SnacksPicker = {
        colors.darkened_white,
        'SnacksPickerBorder',
        'SnacksPickerTitle',
    },

    NormalFloat = {
        colors.darkened_white,
        bg = colors.float,
        'FloatBorder',
        'FloatTitle',
        'Pmenu',
    },

    PmenuSel = { colors.white, bg = colors.dark_grey_blue },

    StatusLine = { colors.darkened_white, bg = colors.almost_black, italic = true },
    StatusLineNC = { colors.almost_black, bg = colors.almost_black, italic = true },
    VertSplit = { colors.dark_grey_blue, bg = nil, 'WinSeparator' },

    ColorColumn = { colors.red, bg = colors.almost_black },

    TabLineFill = { '#a09998', bg = colors.practically_black },
    TabLine = { '#a09998', bg = colors.practically_black },
    TabLineSel = { '#a09998', bg = colors.almost_black },

    Folded = {
        colors.white,
        bg = colors.dark_grey_blue,
        'FoldColumn',
    },

    Conceal = colors.mid_grey_blue,

    Search = { bg = 'NvimDarkYellow' },

    DiffAdd = { bg = '#001600' },

    ['@markup.heading'] = { colors.violet, bg = colors.almost_black },
})
