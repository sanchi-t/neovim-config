local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require("sanchit.lsp.mason")
require("sanchit.lsp.handlers").setup()
require "sanchit.lsp.null-ls"

