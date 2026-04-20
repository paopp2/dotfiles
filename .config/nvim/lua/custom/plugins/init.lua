-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'glacambre/firenvim',
    build = ":call firenvim#install(0)",
    config = function()
      vim.g.firenvim_config = {
        localSettings = {
          ['.*'] = { takeover = 'never' }
        }
      }
    end,
  },
  {
    'bngarren/checkmate.nvim',
    ft = 'markdown',
    opts = {
      files = { '*.md' },
      todo_states = {
        unchecked = { marker = '[ ]', order = 1 },
        active    = { marker = '[/]', markdown = '/', type = 'incomplete', order = 2 },
        blocked   = { marker = '[!]', markdown = '!', type = 'incomplete', order = 3 },
        checked   = { marker = '[x]', order = 4 },
        cancelled = { marker = '[-]', markdown = '-', type = 'complete',   order = 5 },
      },
      keys = (function()
        local function set(state)
          return { rhs = ('<cmd>Checkmate toggle %s<cr>'):format(state), modes = { 'n', 'v' } }
        end
        -- Rewrite a line to bare `- item` (strips any `[ ]`/`[x]`/etc markers).
        local function backlog_line(line)
          local indent, rest = line:match('^(%s*)(.*)$')
          local stripped, n = rest:gsub('^([%-%*])%s*%[.%]%s*', '%1 ')
          if n == 0 and not rest:match('^[%-%*]%s') then
            stripped = '- ' .. rest
          end
          return indent .. stripped
        end
        local function backlog_range()
          local s = vim.fn.line('v')
          local e = vim.fn.line('.')
          if s > e then s, e = e, s end
          for l = s, e do
            vim.fn.setline(l, backlog_line(vim.fn.getline(l)))
          end
          if vim.fn.mode():match('[vV\22]') then
            vim.cmd('normal! \27')
          end
        end
        return {
          ['<leader>tp'] = vim.tbl_extend('force', set('unchecked'), { desc = 'Todo: pending' }),
          ['<leader>ta'] = vim.tbl_extend('force', set('active'),    { desc = 'Todo: active' }),
          ['<leader>tx'] = vim.tbl_extend('force', set('checked'),   { desc = 'Todo: done' }),
          ['<leader>t!'] = vim.tbl_extend('force', set('blocked'),   { desc = 'Todo: blocked' }),
          ['<leader>t-'] = vim.tbl_extend('force', set('cancelled'), { desc = 'Todo: cancelled' }),
          ['<leader>tb'] = { rhs = backlog_range, desc = 'Todo: backlog', modes = { 'n', 'v' } },
          ['<leader>tA'] = { rhs = '<cmd>Checkmate archive<cr>', desc = 'Todo: archive', modes = { 'n' } },
        }
      end)(),
    },
  },
  {
      "toppair/peek.nvim",
      event = { "VeryLazy" },
      build = "deno task --quiet build:fast",
      config = function()
          require("peek").setup({
              close_on_bdelete = false,
              theme = 'light',
              app = 'browser',
          })
          vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
          vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
      end,
  },
}
