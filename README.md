# Dotfiles

A small macOS and Ubuntu/Debian developer setup built from shell scripts,
Homebrew Bundle files, and symlinks. The shared configuration is intended to be
portable; machine-specific values and credentials belong in ignored local
files.

## Install

Clone the repository and run the platform bootstrap:

```sh
git clone https://github.com/ostera/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
./bootstrap.sh
```

The bootstrap installs the shared packages, links configuration into `$HOME`,
configures the repository's pre-commit safety hook, and starts Zsh when it is
available. It does not configure personal credentials, Git identity, SSH keys,
password managers, or third-party accounts.

For a remote install, you can also run:

```sh
curl -fsSL https://raw.githubusercontent.com/ostera/dotfiles/main/remote-install.sh | sh
```

Set `DOTFILES_URL` to use a fork, or `DOTFILES_DIR` to choose another install
location.

## Platform support

- macOS: `bootstrap.macos.sh` and `Brewfile`
- Ubuntu/Debian Linux: `bootstrap.linux.sh` and `Brewfile.linux`

The package lists are a general development baseline. Add personal or
machine-specific packages locally instead of committing account-specific
configuration to the shared setup.

## Local configuration

Use ignored local overrides for identity and machine-specific values. Supported
locations include:

- `~/.env.local`
- `~/.config/zsh/env.local`
- `~/.config/git/config.local`
- `~/.config/direnv/*.local`

SSH configuration and keys are not managed by this repository. Keep them in
`~/.ssh` and never add private keys, known-hosts data, access tokens, or
credentials to the tracked tree.

## Public-safety checks

The pre-commit hook audits staged changes. Install it manually with:

```sh
./tools/install-hooks
```

To check the repository's reachable history for suspicious paths or
secret-shaped values, run:

```sh
./tools/audit-public.sh --history
```

The audit is defense in depth; review changes and history manually before
publishing.
