-- Set the mapleader to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Create mappings for colon and semicolon
vim.api.nvim_set_keymap('n', ';', ':', { noremap = true })
vim.api.nvim_set_keymap('n', ':', ';', { noremap = true })

-- Create an insert mode mapping for 'kj' to escape
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', {})

-- Create normal mode mappings
vim.api.nvim_set_keymap('n', '<Leader>s', ':w<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'tk', ':tabprev<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'tj', ':tabnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>md', ':PeekOpen<CR>', { noremap = true, desc = 'Markdown Preview' })

-- Up/Down to half scroll up/down
vim.api.nvim_set_keymap('n', '<Up>', '<C-u>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Down>', '<C-d>', { noremap = true })

-- Set clipboard options
vim.o.clipboard = 'unnamed,unnamedplus'

-- Enable line numbers and relative line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable line wrapping and linebreak
vim.wo.wrap = true
vim.wo.linebreak = true

-- Automatically change the current directory to the file's directory
vim.o.autochdir = true

-- After visual yank, stay where the cursor is at
vim.api.nvim_set_keymap('x', 'y', 'ygv<Esc>', { noremap = true })

-- Map <leader>a to select all text
vim.api.nvim_set_keymap('n', '<Leader>a', 'ggVG', { noremap = true })

-- Map <leader>; in visual mode to append semicolon at the end of each selected line
vim.api.nvim_set_keymap('n', '<Leader>;', 'v<Esc>A;<Esc>gv<Esc>', { noremap = true })

-- Map <leader>, in visual mode to append comma at the end of each selected line
vim.api.nvim_set_keymap('n', '<Leader>,', 'v<Esc>A,<Esc>gv<Esc>', { noremap = true })

-- Map <leader>( to surround text in parentheses
vim.api.nvim_set_keymap('n', '<Leader>(', '<Esc>[(v%o', { noremap = true })

-- Map ( in visual mode to surround text in parentheses
vim.api.nvim_set_keymap('x', '(', '<Esc>[(v%o', { noremap = true })

-- Map <leader>{ to surround text in curly braces
vim.api.nvim_set_keymap('n', '<Leader>{', '<Esc>[{v%o', { noremap = true })

-- Map { in visual mode to surround text in curly braces
vim.api.nvim_set_keymap('x', '{', '<Esc>[{v%o', { noremap = true })

-- Toggle markdown checkbox with Ctrl+L.
-- On a line with [ ] or [x], flip it. On a line without a checkbox, insert one
-- (promoting bare list items and plain text into `- [ ] ...`).
-- Works on the current line in normal mode and on each selected line in visual mode.
local function toggle_checkbox_line(line)
  if line:find('%[ %]') then
    return (line:gsub('%[ %]', '[x]', 1))
  elseif line:find('%[x%]') then
    return (line:gsub('%[x%]', '[ ]', 1))
  end
  local indent, rest = line:match('^(%s*)(.*)$')
  local marker, text = rest:match('^([%-%*])%s+(.*)$')
  if marker then
    return indent .. marker .. ' [ ] ' .. text
  end
  return indent .. '- [ ] ' .. rest
end
local function toggle_checkbox_range()
  local s = vim.fn.line('v')
  local e = vim.fn.line('.')
  if s > e then s, e = e, s end
  for l = s, e do
    vim.fn.setline(l, toggle_checkbox_line(vim.fn.getline(l)))
  end
  if vim.fn.mode():match('[vV\22]') then
    vim.cmd('normal! \27')
  end
end
vim.keymap.set({ 'n', 'x' }, '<C-L>', toggle_checkbox_range, { noremap = true, desc = 'Toggle/create markdown checkbox' })
