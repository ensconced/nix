vim.lsp.enable("eslint")
require("typescript-tools").setup({})

require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    terraform = { "terraform_fmt" }
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 10000,
    lsp_format = "fallback",
  },
})
