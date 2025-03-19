require('keymaps')
require('options')
require('api')

-- Load plugin manager
require('config.lazy')

-- Load plugin config
require('plugins.telescope')
require('plugins.treesitter')
require('plugins.lsp-zero')
require('plugins.tokyonight')
require('plugins.nvim-tree')
require('plugins.bufferline')


-- Load colors
require('colors')

-- Load post config of plugins
require('plugins.post-config')
