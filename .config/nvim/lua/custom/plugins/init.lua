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
}
