-- Without doing this,
-- autocommands that deal with filetypes prohibit messages from being shown, so
-- some of the messages we show to help users get started may not be shown.
vim.opt_global.shortmess:remove("F")

local group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    local metals = require("metals")

    local metals_config = metals.bare_config()
    metals_config.on_attach = function(client, bufnr)
      -- your on_attach function
    end
    metals_config.useGlobalExecutable = true;
    metals_config.init_options.statusBarProvider = "on"

    metals.initialize_or_attach(metals_config)
  end,
  group = group,
})


-- This is basically just the default statusline from mini.statusline except
-- I've added in vim.g['metals_status']. And I've got the statusline set to nil
-- for inactive windows (for no good reason)
local active = function()
  local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
  local git           = MiniStatusline.section_git({ trunc_width = 40 })
  local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
  local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
  local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
  local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
  local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
  local location      = MiniStatusline.section_location({ trunc_width = 75 })
  local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

  return MiniStatusline.combine_groups({
    { hl = mode_hl,                 strings = { mode } },
    { hl = mode_hl,                 strings = { vim.g['metals_status'] } },
    { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
    '%<', -- Mark general truncate point
    { hl = 'MiniStatuslineFilename', strings = { filename } },
    '%=', -- End left alignment
    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
    { hl = mode_hl,                  strings = { search, location } },
  })
end
require('mini.statusline').setup(
  {
    -- Content of statusline as functions which return statusline string. See
    -- `:h statusline` and code of default contents (used instead of `nil`).
    content = {
      -- Content for active window
      active = active,
      -- Content for inactive window(s)
      inactive = nil,
    },

    -- Whether to use icons by default
    use_icons = true,
  }
)


-- We just want to use the LSP for formatting (metals will delegate to scalafmt for this)
require("conform").setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})
