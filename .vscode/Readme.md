# Theme Install

## Dracula Theme Install
```sh
$ git clone https://github.com/dracula/visual-studio-code.git ~/.vscode/extensions/theme-dracula
$ cd ~/.vscode/extensions/theme-dracula
$ npm install
$ npm run build
```


# Start tmux automatically in vscode (windows)
Put this in `settings.json`
```json
"terminal.integrated.profiles.windows": {
  "Ubuntu-24.04 (WSL)": {
    "path": "C:\\Windows\\System32\\wsl.exe",
    "args": [
        "-d",
        "Ubuntu-24.04",
        "--exec",
        "bash",
        "-c",
        "WORKSPACE_NAME=$(basename \"$PWD\" | sed 's/[^a-zA-Z0-9_-]/_/g'); exec tmux new-session -A -s \"vscode-$WORKSPACE_NAME\""
    ],
    "icon": "terminal-bash"
  }
}
```