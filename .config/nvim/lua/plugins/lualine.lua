return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- setting up lualine
    local custom_theme = require'lualine.themes.palenight'

    require('lualine').setup {
      options = { theme = custom_theme },
    }
  end
}
