local present, lsp_signature = pcall(require, "lsp_signature")

if not present then return end

lsp_signature.setup {
  hint_enable = false,
}
