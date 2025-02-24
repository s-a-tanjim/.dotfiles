-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('custom-highlight-yank', { clear = true }),
  callback = function ()
    vim.highlight.on_yank()
  end,
})


-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }),
  desc = 'LSP actions',
  callback = function(event)
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('K', '<cmd>lua vim.lsp.buf.hover()<cr>', 'Hover')
    map('gd', '<cmd>lua vim.lsp.buf.definition()<cr>', '[G]oto [d]efinition')
    map('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', '[G]oto [D]eclaration')
    map('gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', '[G]oto [I]mplementation')
    map('go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', '[G]oto type definitation')
    map('gr', '<cmd>lua vim.lsp.buf.references()<cr>', '[G]oto [R]eference')
    map('gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', '[G]oto [s]ignature help')
    map('<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename')
    map('<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format', {'n', 'x'})
    map('<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code action')
  end,
})

