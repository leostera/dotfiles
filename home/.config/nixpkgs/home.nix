{ config, pkgs, ...}:

{
  nixpkgs.config.allowUnfree = true;

  services.nix-daemon.enable = true;

  environment.systemPackages =
    with pkgs; [
      cloc
      coreutils
      ctags
      fnm
      fzf
      docker
      gifsicle
      mkcert
      gettext
      gist
      git
      git-extras
      gnupg
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
    ];
}

