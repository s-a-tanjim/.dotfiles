-- enable line numbers
vim.opt.nu = true
-- relative line numbers
vim.opt.relativenumber = true
-- Line wrap
vim.opt.wrap = true
vim.opt.list = true -- show tab characters and trailing whitespace
vim.opt.autoindent = true -- auto indentation

-- Tab size
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.smartindent = true

vim.opt.incsearch = true

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Set colorscheme
vim.opt.termguicolors = true

vim.opt.scrolloff = 8 -- min number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 8 -- min number of columns to keep above and below the cursor

vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

