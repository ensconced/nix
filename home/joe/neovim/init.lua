vim.g.mapleader = " ";
vim.opt.exrc = true;
vim.opt.termguicolors = true;
vim.opt.relativenumber = true;
vim.opt.tabstop = 2;
vim.opt.shiftwidth = 2;
vim.opt.expandtab = true;
vim.opt.winborder = "rounded";

vim.cmd([[colorscheme dracula]])

require("mini.ai").setup({ n_lines = 500 })
require("mini.basics").setup({})
require("mini.bracketed").setup({})
require("mini.clue").setup({})
require("mini.comment").setup({})
require("mini.completion").setup({})
require("mini.files").setup({})
require("mini.icons").setup({})
require("mini.jump").setup({})
require("mini.pairs").setup({})

local win_config = function()
  local height = math.floor(0.9 * vim.o.lines)
  local width = math.floor(0.9 * vim.o.columns)
  return {
    anchor = 'NW',
    height = height,
    width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end
require("mini.pick").setup({
  window = { config = win_config }
})


require("mini.starter").setup({})
require("mini.statusline").setup({})
require("mini.surround").setup({})
require("mini.tabline").setup({})
local miniclue = require("mini.clue");
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },

    -- `[` and `]` keys
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = {
    delay = 100,
    config = {
      width = "auto",
      border = "double",
    },
  },
})

require("conform").setup({})
require("gitblame").setup({})

vim.keymap.set("n", "<leader>f", function() MiniPick.builtin.files() end, { desc = "File picker" })
vim.keymap.set("n", "<leader>e", function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
  end
end, { desc = "File explorer" })
vim.keymap.set("n", "<leader>g", function() MiniPick.builtin.grep_live() end, { desc = "Pattern picker" })
vim.keymap.set("n", "<leader>h", function() MiniPick.builtin.help() end, { desc = "Help picker" })
vim.keymap.set("n", "<leader>b", function() MiniPick.builtin.buffers() end, { desc = "Buffer picker" })

-- multicursor setup
local mc = require("multicursor-nvim")
mc.setup()

-- Add or skip cursor above/below the main cursor.
vim.keymap.set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
vim.keymap.set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })
vim.keymap.set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end, { desc = "Skip cursor above" })
vim.keymap.set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end, { desc = "Skip cursor below" })

-- Add or skip adding a new cursor by matching word/selection
vim.keymap.set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end, { desc = "Add cursor at next match" })
vim.keymap.set({ "n", "x" }, "<leader>s", function() mc.matchSkipCursor(1) end, { desc = "Skip cursor at next match" })
vim.keymap.set({ "n", "x" }, "<leader>N", function() mc.matchAddCursor(-1) end, { desc = "Add cursor at prev match" })
vim.keymap.set({ "n", "x" }, "<leader>S", function() mc.matchSkipCursor(-1) end, { desc = "Skip cursor at prev match" })

-- Add and remove cursors with control + left click.
vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
vim.keymap.set("n", "<c-leftdrag>", mc.handleMouseDrag)
vim.keymap.set("n", "<c-leftrelease>", mc.handleMouseRelease)

-- Disable and enable cursors.
vim.keymap.set({ "n", "x" }, "<c-q>", mc.toggleCursor)

-- Mappings defined in a keymap layer only apply when there are
-- multiple cursors. This lets you have overlapping mappings.
mc.addKeymapLayer(function(layerSet)
  -- Select a different cursor as the main one.
  layerSet({ "n", "x" }, "<left>", mc.prevCursor)
  layerSet({ "n", "x" }, "<right>", mc.nextCursor)

  -- Delete the main cursor.
  layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor, { desc = "Delete main cursor" })

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
vim.api.nvim_set_hl(0, "MultiCursorCursor", { reverse = true })
vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn" })
vim.api.nvim_set_hl(0, "MultiCursorMatchPreview", { link = "Search" })
vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { reverse = true })
vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
