# 💾 `~/.*`
> dotfiles.

Install with one command:

```sh
curl -fsSL https://raw.githubusercontent.com/ostera/dotfiles/main/remote-install.sh | sh
```

Very no-nonsense stuff.

1. Config files follow XDG conventions: `home/.config/*` symlinks to `$HOME/.config/*`
2. `home/.*` files symlink to `$HOME/.*`
3. Package installs are OS-specific:
   - macOS: `bootstrap.macos.sh` + `brew bundle` via `Brewfile`
   - Ubuntu: `bootstrap.linux.sh` + `brew bundle` via `Brewfile.linux`

The shared package lists are a general development baseline. Keep personal
settings, credentials, SSH keys, and machine-specific packages local.

Nothing more. Keep it simple. Fork away!

## Ubuntu Notes

`bootstrap.sh` dispatches to `bootstrap.linux.sh` or `bootstrap.macos.sh`.

Linux installs Homebrew if needed, then installs packages from `Brewfile.linux`:

```sh
brew bundle --file=./Brewfile.linux
```

## Local Configuration

Keep identity and machine-specific settings in ignored local files like
`~/.env.local`, `~/.config/zsh/env.local`, and
`~/.config/git/config.local`. SSH config and keys stay in `~/.ssh`—not here.

The pre-commit hook checks staged changes. Install it with:

```sh
./tools/install-hooks
```

You can also check the repo's history for suspicious paths or secret-shaped
values:

```sh
./tools/audit-public.sh --history
```

The audit's a backstop, not magic. Give things a look before publishing.

## License

See [LICENSE](LICENSE).
