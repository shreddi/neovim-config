return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "x" }, "<up>", function()
        mc.lineAddCursor(-1)
      end)
      set({ "n", "x" }, "<down>", function()
        mc.lineAddCursor(1)
      end)
      set({ "n", "x" }, "<leader><up>", function()
        mc.lineSkipCursor(-1)
      end)
      set({ "n", "x" }, "<leader><down>", function()
        mc.lineSkipCursor(1)
      end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<leader>n", function()
        mc.matchAddCursor(1)
      end)
      set({ "n", "x" }, "<leader>s", function()
        mc.matchSkipCursor(1)
      end)
      set({ "n", "x" }, "<leader>N", function()
        mc.matchAddCursor(-1)
      end)
      set({ "n", "x" }, "<leader>S", function()
        mc.matchSkipCursor(-1)
      end)

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)
      set("n", "<c-leftdrag>", mc.handleMouseDrag)
      set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ "n", "x" }, "<c-q>", mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "typescript", "javascript", "tsx", "css", "html", "python", "ninja", "rst" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {},
        vtsls = {
          settings = {
            vtsls = {
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                  entriesLimit = 200,
                },
              },
            },
          },
          on_attach = function(client, _bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },
        -- mason-lspconfig auto-enables every mason-installed server, so pylsp needs
        -- this explicit opt-out or it attaches alongside pyright. The nested plugin
        -- settings matter too: pycodestyle emits E501 line-length noise if it ever loads.
        pylsp = {
          enabled = false,
          settings = {
            pylsp = {
              plugins = {
                rope_autoimport = {
                  enabled = true,
                },
                -- -- Enable rope for code actions (imports, refactoring)
                -- rope = {
                --   enabled = true,
                -- },
                -- -- Enable mypy for type checking
                -- mypy = {
                --   enabled = true,
                -- },
                -- -- Enable autopep8 for formatting
                autopep8 = {
                  enabled = false,
                },
                -- -- Enable pyflakes for linting
                pyflakes = {
                  enabled = true,
                },
                -- -- Enable autopep8 for formatting
                pycodestyle = {
                  enabled = false,
                },
              },
            },
          },
        },
        ruff = {
          capabilities = {
            general = {
              positionEncodings = { "utf-16" },
            },
          },
          init_options = {
            settings = {
              lint = {
                enable = false,
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "basic",
              },
            },
          },
        },
      },
    },
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       suggestion = {
  --         enabled = false,
  --         auto_trigger = false,
  --         hide_during_completion = true,
  --       },
  --     })
  --   end,
  -- },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        -- python = { "black" },
        python = { "ruff_format" },
      },
      format_on_save = {
        timeout_ms = 1500,
        lsp_format = "never",
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "ruff",
      },
    },
  },
  { "nvim-mini/mini.pairs", enabled = false },
  {
    "nvim-mini/mini.surround",
  },
  -- {
  --   "amitds1997/remote-nvim.nvim",
  --   version = "*", -- Pin to GitHub releases
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- For standard functions
  --     "MunifTanjim/nui.nvim", -- To build the plugin UI
  --     "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
  --   },
  --   config = true,
  -- },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  {
    -- hide the LAZYVIM ascii splash; keep some top padding so the menu isn't flush
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      opts.config.header = { "", "", "", "", "" }
      return opts
    end,
  },
  {
    -- lazygit `e` should reuse the current window instead of opening a new tab.
    -- lazygit's built-in nvim-remote preset does `--remote-send "q"` then `--remote-tab`;
    -- swapping in plain `--remote` alone would race (`:drop` can land inside the float
    -- before it closes), so close the float over RPC first, then send the file.
    "folke/snacks.nvim",
    init = function()
      ---Called synchronously from lazygit (via --remote-expr) before the file is sent.
      ---Closes the lazygit float and focuses a real file window so `:drop` reuses it.
      function _G.LazygitEditPrep()
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          local floating = vim.api.nvim_win_get_config(win).relative ~= ""
          if floating and vim.bo[buf].filetype == "snacks_terminal" then
            pcall(vim.api.nvim_win_close, win, false)
          end
        end
        local fallback ---@type number?
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.api.nvim_win_get_config(win).relative == "" then
            fallback = fallback or win
            if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "" then
              fallback = win
              break
            end
          end
        end
        if fallback then
          pcall(vim.api.nvim_set_current_win, fallback)
        end
        return 1
      end

      ---Jump to `line` after the file is opened. Done over RPC rather than
      ---`--remote-send ":<line><CR>"` because those queued keys race with
      ---LazyVim's `last_loc` autocmd restoring the shada `"` mark.
      ---@param line number
      function _G.LazygitEditLine(line)
        line = math.max(1, math.min(tonumber(line) or 1, vim.api.nvim_buf_line_count(0)))
        pcall(vim.api.nvim_win_set_cursor, 0, { line, 0 })
        pcall(vim.cmd, "normal! zz")
        return 1
      end
    end,
    opts = {
      lazygit = {
        config = {
          os = {
            -- stylua: ignore start
            edit = [[[ -z "$NVIM" ] && nvim -- {{filename}} || ( nvim --server "$NVIM" --remote-expr "v:lua.LazygitEditPrep()" >/dev/null && nvim --server "$NVIM" --remote {{filename}} )]],
            editAtLine = [[[ -z "$NVIM" ] && nvim +{{line}} -- {{filename}} || ( nvim --server "$NVIM" --remote-expr "v:lua.LazygitEditPrep()" >/dev/null && nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-expr "v:lua.LazygitEditLine({{line}})" >/dev/null )]],
            -- stylua: ignore end
          },
        },
      },
    },
  },
}
