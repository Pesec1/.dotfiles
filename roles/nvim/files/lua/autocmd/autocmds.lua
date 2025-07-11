return {
  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- NOTE: https://gist.github.com/bnse/a3eb5b9941e6af4582c5406b29d76e05
  -- https://www.reddit.com/r/neovim/comments/13wcqdr/disable_hintslsperrors_etc/
  vim.api.nvim_create_user_command('DiagnosticToggle', function()
    local config = vim.diagnostic.config
    local vt = config().virtual_text

    config {
      virtual_text = not vt,
      underline = not vt,
      signs = not vt,
    }

    local cmp = require 'cmp'
    if vt then
      cmp.setup { enabled = false }
    else
      cmp.setup { enabled = true }
    end
  end, { desc = 'toggle diagnostic / autocomplete' }),

  vim.keymap.set('n', '<leader>tl', '<cmd>DiagnosticToggle<CR>'),

  -- NOTE: for dadbod
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dbui',
    callback = function()
      -- buffer‐local settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
    end,
  }),

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  -- vim.api.nvim_create_autocmd('TextYankPost', {
  --   desc = 'Highlight when yanking (copying) text',
  --   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  --   callback = function()
  --     vim.hl.on_yank()
  --   end,
  -- }),
}
