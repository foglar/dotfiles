local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")

local opts = {
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.diagnostics.ruff,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.golines,
    null_ls.builtins.formatting.goimports_reviser,
  },
  on_attach = function (client, bufrn)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
      group=augroup,
      buffer=bufrn,
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufrn,
      callback = function ()
          vim.lsp.buf.format({bufrn = bufrn})
        end,
    })
    end
  end,
}
return opts
