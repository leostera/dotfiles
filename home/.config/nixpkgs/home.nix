{ config, pkgs, ...}:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  services.nix-daemon.enable = true;

  environment.systemPackages =
    with pkgs; [
      # bazel
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      cloc
      colordiff
      coreutils
      ctags
      direnv
      docker
      fnm
      fzf
      gettext
      gifsicle
      gist
      git
      git-extras
      gnupg
      htop
      jq
      mkcert
      neovim
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

