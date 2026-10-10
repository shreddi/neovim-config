return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "night" },
  },
  { "EdenEast/nightfox.nvim", lazy = true },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
  },
  { "scottmckendry/cyberdream.nvim", lazy = true },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-moon",
    },
  },
  {
    "akinsho/bufferline.nvim",
    lazy = true,
    optional = true,
    opts = function(_, opts)
      if (vim.g.colors_name or ""):find("catppuccin") then
        opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
      end
    end,
  },
}
