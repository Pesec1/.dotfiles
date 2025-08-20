vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = 'no'
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
    { src = 'https://github.com/echasnovski/mini.pick.git' },
    { src = 'https://github.com/mason-org/mason.nvim.git' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    { src = 'https://github.com/vague2k/vague.nvim' },
    { src = 'https://github.com/NMAC427/guess-indent.nvim.git' },
})

require('guess-indent').setup {}

require('nvim-treesitter').setup({
    auto_install = true,
    highlight = {
        enable = true,
    },
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

require 'mini.pick'.setup()
vim.keymap.set('n', '<leader>sf', ':Pick files<Cr>')
vim.keymap.set('n', '<leader><leader>', ':Pick buffers<Cr>')
vim.keymap.set('n', '<leader>sg', ':lua MiniPick.builtin.grep_live()<Cr>')

-- Lsp
vim.lsp.enable({ "lua_ls", "ruff", "basedpyright", "ts_ls", "rust-analyzer" })
vim.diagnostic.config { virtual_text = false, underline = false, signs = false }
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)

require("mason").setup()

local function fix_python()
    local bufnr   = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients { bufnr = bufnr, name = 'ruff', }
    local uri     = vim.uri_from_bufnr(bufnr)
    local vers    = vim.lsp.util.buf_versions[bufnr]
    for _, client in ipairs(clients) do
        for _, cmd in ipairs({ 'ruff.applyAutofix', 'ruff.applyOrganizeImports' }) do
            local params = {
                command = cmd,
                arguments = {
                    {
                        uri = uri,
                        version = vers,
                    },
                },
            }
            client.request('workspace/executeCommand', params, nil, 1)
        end
    end
end

vim.keymap.set("n", "<leader>l", fix_python, { desc = "fix ruff" })
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
