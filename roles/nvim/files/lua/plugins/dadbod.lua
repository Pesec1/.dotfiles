return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql', 'clickhouse' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      --
      vim.keymap.set('n', '<leader>rq', ':normal vip<CR><PLUG>(DBUI_ExecuteQuery)', { desc = '[R]un [Q]uery' })
      vim.keymap.set('n', '<leader>td', '<cmd>DBUIToggle<cr>)', { desc = '[T]oogle [D]atabase' })

      vim.keymap.set('v', 'f', function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('"+y', true, false, true), 'x', false)
        local test = vim.fn.getreg '+'

        local t = {}
        for str in string.gmatch(test, '([^' .. '\n' .. ']+)') do
          table.insert(t, "'" .. str .. "'")
        end
        local result = table.concat(t, ',')
        vim.fn.setreg('+', '(' .. result .. ')')

        -- Optional: show a message
      end, { desc = 'Format & copy selection', noremap = true })
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
      vim.g.db_ui_table_helpers = {
        postgresql = {
          List = 'SELECT * FROM {schema}.{table} LIMIT 500',
          Count = 'SELECT COUNT(*) FROM {schema}.{table}',
          Copy = "\\COPY (SELECT * FROM {schema}.{table}) TO '/home/linuxfan/{schema}.{table}' WITH CSV DELIMITER ',' HEADER",
          Test = '{database} {user} {schema} {table}',
        },
      }
    end,
  },
}
