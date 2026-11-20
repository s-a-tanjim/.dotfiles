-- nvim-treesitter (main branch) only installs parsers and ships queries;
-- highlighting itself is Neovim's built-in vim.treesitter.
-- Requires the `tree-sitter` CLI and a C compiler to build parsers.
local ts = require('nvim-treesitter')

ts.install({ "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "javascript", "python", "typescript", "dockerfile", "yaml" })

local available = {}
for _, lang in ipairs(ts.get_available()) do
  available[lang] = true
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then return end

    local function start()
      if vim.api.nvim_buf_is_valid(args.buf) then
        pcall(vim.treesitter.start, args.buf, lang)
      end
    end

    if pcall(vim.treesitter.language.add, lang) and vim.treesitter.language.add(lang) then
      start()
    elseif available[lang] then
      -- Install missing parsers on first use, then highlight
      ts.install({ lang }):await(vim.schedule_wrap(start))
    end
  end,
})
