return { 
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    -- setting up treesitter
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = { "lua", "javascript", "c_sharp" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
