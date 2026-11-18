-- LSP via native vim.lsp (nvim 0.11+). Server definitions come from nvim-lspconfig's lsp/ dir.
-- Completion (nvim-cmp) is configured in lua/config/lazy.lua.
vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })

-- Server list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
vim.lsp.enable({ 'gleam', 'ocamllsp' })
