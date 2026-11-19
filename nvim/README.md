# Nvim installation
The repository's `./install.sh` installs the latest stable Neovim release
and adds `/opt/nvim/bin` to the Zsh PATH.
Preview changes first with `./install.sh --dry-run`. See the root README for
backup behavior and the complete machine setup.

Upstream installation reference: https://github.com/neovim/neovim/blob/master/INSTALL.md

# Dependencies
- Lazy: Plugin manager

# Plugins
- telescope: File finder
- treesitter: Syntax highlighting
- nvim-lspconfig + nvim-cmp: LSP (native `vim.lsp`, see `lua/plugins/lsp.lua`)
- tokyonight: ColorScheme
- nvim-tree: File tree in side menu
- bufferline: Tabs


# Create a symlink
```bash
ln -s ~/<base-path>/dotfiles/nvim ~/.config/nvim
```

# References
- https://github.com/nvim-lua/kickstart.nvim
- https://github.com/rockerBOO/awesome-neovim

# Note
- `noremap = true`: Prevents recursive mappings
- `silent = true`: Prevents command output from showing in the command line


# TODO
- https://github.com/williamboman/mason.nvim

