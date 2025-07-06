# Nvim installation
Ref: https://github.com/neovim/neovim/blob/master/INSTALL.md
```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
```

# Dependencies
- Lazy: Plugin manager

# Plugins
- telescope: File finder
- treesitter: Syntax highlighting
- lsp-zero: LSP server
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
Add LSP
- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v4.x/doc/md/guides/lazy-loading-with-lazy-nvim.md
- https://github.com/williamboman/mason.nvim

