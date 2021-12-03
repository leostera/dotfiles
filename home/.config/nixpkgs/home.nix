{ config, pkgs, ...}:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  services.nix-daemon.enable = true;

  environment.systemPackages =
    with pkgs; [
      # bazel
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      autoconf
      bat
      cloc
      cmake
      colordiff
      coreutils
      ctags
      direnv
      docker
      elixir
      erlang
      exa
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
      llvm
      mkcert
      neovim
      ngrok
      opam
      python38
      rebar3
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

