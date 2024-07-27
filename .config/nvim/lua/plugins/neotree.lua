return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", 
    "MunifTanjim/nui.nvim",
  },
  config = function()
    -- setting up neotree
    vim.keymap.set('n', '<C-n>', ':Neotree toggle filesystem reveal left<CR>')
    
    -- custom options
    require("neo-tree").setup {
        filesystem = {
            filtered_items  = {
                visible = false,
                hide_by_name = {
                    "bin",
                    "obj"
                }
            }
        }
    }
  end
}
