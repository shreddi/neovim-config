-- Editor responsiveness overrides.
--
-- Two defaults dominate perceived input lag in this setup:
--   1. lualine runs a `refresh_check_timer` every `refresh.refresh_time` ms
--      (default 16 = ~62 Hz) on the main loop -- the same thread that handles
--      keystrokes and redraws. Every CursorMoved/CursorMovedI queues a refresh
--      that this timer flushes, so the statusline re-renders while you type.
--   2. snacks.scroll animates the viewport over 200 ms, so every scroll is a
--      deliberate animation rather than an instant jump.
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      -- ~16 Hz is still far faster than anyone can read a statusline,
      -- and cuts the idle wakeups by ~4x.
      opts.options.refresh = vim.tbl_extend("force", opts.options.refresh or {}, {
        refresh_time = 60,
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      })
      return opts
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      -- Instant viewport movement instead of a 200 ms animation.
      scroll = { enabled = false },
      -- Keep the indent guides, drop the 500 ms animation on every scope change.
      indent = { animate = { enabled = false } },
    },
  },
}
