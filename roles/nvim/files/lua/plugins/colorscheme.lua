return {
  'slugbyte/lackluster.nvim',
  priority = 1000,
  init = function()
    vim.cmd.colorscheme 'lackluster-hack'
    vim.cmd.hi 'Comment gui=none'
  end,
}
