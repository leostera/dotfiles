# 💾 `~/.*`
> dotfiles.

Install with:

```sh
; curl https://raw.githubusercontent.com/ostera/dotfiles/main/remote-install.sh | sh - 
```

Very no-nonsense stuff.

1. Config files follow XDG conventions: `home/.config/*` symlinks to `$HOME/.config/*`
2. `home/.*` files symlink to `$HOME/.*`
3. Other installs are handled with `nix`

Nothing more. Keep it simple. Fork away!

## License

See [LICENSE](https://github.com/ostera/zazen/blob/main/LICENSE).
