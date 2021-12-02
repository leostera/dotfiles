{ config, pkgs, ...}:

{
  environment.systemPackages =
    with pkgs; [
      chromiumWrapper
      cloc
      coreutils
      ctags
      firefoxWrapper
      fnm
      fzf
      docker
      gifsicle
      mkcert
      gettext
      gist
      git
      git-extras
      gnu-sed
      gnu-tar
      gnupg
      gpg
      htop
      jq
      ngrok
      opam
      ripgrep
      rustup
      tldr
      tmux
      tree
      vim
      wget
      zsh
    ]
}

