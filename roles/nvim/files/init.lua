vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = 'yes'
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.background = 'dark'
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.winborder = "rounded"
vim.opt.ignorecase = true
vim.opt.scrolloff = 10
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.g.mapleader = " "

vim.pack.add({
    { src = 'https://github.com/stevearc/oil.nvim.git' },
    { src = 'https://github.com/mason-org/mason.nvim.git' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim.git' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter',              version = 'main', },
    { src = 'https://github.com/vague2k/vague.nvim' },
    { src = 'https://github.com/NMAC427/guess-indent.nvim.git' },
    { src = 'https://github.com/dense-analysis/ale.git' },
    { src = 'https://www.github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim.git' },
})

require('guess-indent').setup {}

local treesitter_parsers = {
    'lua',
    'python',
    'javascript',
    'typescript',
    'tsx',
    'rust',
    'json',
    'markdown',
    'markdown_inline',
}
-- NOTE: cargo binstall tree-sitter-cli 
-- otherwise this won't work
require('nvim-treesitter').setup()
require('nvim-treesitter').install(treesitter_parsers)

vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        'lua',
        'python',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'rust',
        'json',
        'jsonc',
        'markdown',
    },
    callback = function()
        vim.treesitter.start()
    end,
})

require "vague".setup({ transparent = true })
vim.cmd.colorscheme 'vague'
vim.cmd(":hi statusline guibg=NONE")

require 'oil'.setup({
    keymaps = {
        ['<C-o>'] = 'actions.copy_to_system_clipboard',
    },
    view_options = {
        show_hidden = true,
    },
})
vim.keymap.set('n', '-', ':Oil<Cr>')

-- Ripgrep glob patterns. Excluded paths are not scanned at all.
local telescope_ignore_globs = {
    '**/.git/**',
    '**/node_modules/**',
    '**/dist/**',
    '**/coverage/**',
    '**/*.min.js',
    '**/sources/**',
}

local function telescope_rg_args()
    local args = { '--hidden', '--no-ignore', '--no-ignore-parent' }
    for _, glob in ipairs(telescope_ignore_globs) do
        table.insert(args, '--glob=!' .. glob)
    end
    return args
end

require('telescope').setup({
    pickers = {
        find_files = {
            find_command = function()
                local command = { 'rg', '--files', '--color', 'never' }
                vim.list_extend(command, telescope_rg_args())
                return command
            end,
        },
        live_grep = {
            additional_args = telescope_rg_args,
        },
    },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Telescope buffers' })

-- Lsp
require('mason').setup()
require('mason-tool-installer').setup({
    ensure_installed = {
        'lua-language-server',
        'ruff',
        'basedpyright',
        'typescript-language-server',
        'rust-analyzer',
        'marksman',
    },
})

vim.lsp.enable({ "lua_ls", "ruff", "basedpyright", "ts_ls", "rust_analyzer", "marksman" })
vim.diagnostic.config { virtual_text = false, underline = false, signs = false }
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format buffer' })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.g.ale_linters = { python = {} }
vim.g.ale_fixers = { python = { "ruff", "ruff_format" } }
vim.g.ale_virtualtext_cursor = 'disabled'
vim.keymap.set('n', '<leader>af', '<cmd>ALEFix<CR>', { desc = 'ALE fix file' })

-- Marks operations
vim.keymap.set('n', '<leader>cm', '<cmd>delm!<CR>', { desc = 'Delete in file [m]arks' })
vim.keymap.set('n', '<leader>cM', '<cmd>delm A-Z0-9<CR>', { desc = 'Delete file [M]arks' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -5<CR>', { desc = 'Change size of split to left' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +5<CR>', { desc = 'Change size of split to right' })
vim.keymap.set('n', '<C-Up>', '<cmd>horizontal resize +5<CR>', { desc = 'Change size of split to upper' })
vim.keymap.set('n', '<C-Down>', '<cmd>horizontal resize -5<CR>', { desc = 'Change size of split to lower' })
