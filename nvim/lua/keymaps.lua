-- space bar leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Move selected text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Copy to clipboard: leader + y
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Sed helper
vim.keymap.set("n", "<leader>ss", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Set Buffer
vim.keymap.set("n", "<leader>n", ":bn<cr>")
vim.keymap.set("n", "<leader>p", ":bp<cr>")
vim.keymap.set("n", "<leader>x", ":bd<cr>")

-- Split screen
vim.keymap.set("n", "|", ":vsplit<CR>", { noremap = true, silent = true }) -- Vertical Split
vim.keymap.set("n", "-", ":split<CR>", { noremap = true, silent = true }) -- Horizontal Split
vim.keymap.set("n", "<C-Left>",  ":vertical resize -5<CR>", { noremap = true, silent = true })  -- Shrink width
vim.keymap.set("n", "<C-Right>", ":vertical resize +5<CR>", { noremap = true, silent = true })  -- Increase width
vim.keymap.set("n", "<C-Up>",    ":resize +5<CR>", { noremap = true, silent = true })  -- Increase height
vim.keymap.set("n", "<C-Down>",  ":resize -5<CR>", { noremap = true, silent = true })  -- Decrease height

