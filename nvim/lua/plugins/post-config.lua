--------------------
-- Plugins config --
--------------------
vim.g.tokyonight_colors = { border = "orange" }


---------------------
-- Plugins KeyMaps --
---------------------

-- nvim-tree
vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<cr>") -- Toggle tree
vim.keymap.set("n", "<leader>f", ":NvimTreeFocus<CR>", { noremap = true, silent = true }) -- Focus tree
vim.keymap.set("n", "<leader>w", ":NvimTreeCollapse<CR>") -- Collapse file tree
