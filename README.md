# 💾 `~/.*`
> dotfiles.

Install with one command:

```sh
curl -fsSL https://raw.githubusercontent.com/leostera/dotfiles/main/remote-install.sh | sh
```

Very no-nonsense stuff.

1. Config files follow XDG conventions: `home/.config/*` symlinks to `$HOME/.config/*`
2. `home/.*` files symlink to `$HOME/.*`
3. Package installs are OS-specific:
   - macOS: `bootstrap.macos.sh` + `brew bundle` via `Brewfile`
   - Ubuntu: `bootstrap.linux.sh` + `brew bundle` via `Brewfile.linux`

Nothing more. Keep it simple. Fork away!

## Ubuntu Notes

`bootstrap.sh` dispatches by OS to `bootstrap.linux.sh` or `bootstrap.macos.sh`.

Linux installs Homebrew (if missing) and then installs packages from `Brewfile.linux` using:

```sh
brew bundle --file=./Brewfile.linux
```

## License

See [LICENSE](https://github.com/ostera/zazen/blob/main/LICENSE).
