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
          return function()
            require('checkmate').toggle(state)
          end
        end
        local function backlog()
          local line = vim.api.nvim_get_current_line()
          local indent, rest = line:match('^(%s*)(.*)$')
          local stripped, n = rest:gsub('^([%-%*])%s*%[.%]%s*', '%1 ')
          if n == 0 and not rest:match('^[%-%*]%s') then
            stripped = '- ' .. rest
          end
          vim.api.nvim_set_current_line(indent .. stripped)
        end
        return {
          ['<leader>tp'] = { rhs = set('unchecked'), desc = 'Todo: pending',   modes = { 'n' } },
          ['<leader>ta'] = { rhs = set('active'),    desc = 'Todo: active',    modes = { 'n' } },
          ['<leader>tx'] = { rhs = set('checked'),   desc = 'Todo: done',      modes = { 'n' } },
          ['<leader>t!'] = { rhs = set('blocked'),   desc = 'Todo: blocked',   modes = { 'n' } },
          ['<leader>t-'] = { rhs = set('cancelled'), desc = 'Todo: cancelled', modes = { 'n' } },
          ['<leader>tb'] = { rhs = backlog,          desc = 'Todo: backlog',   modes = { 'n' } },
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
