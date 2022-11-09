{ config, pkgs, ...}:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/fd21e7cd7238f48b0d261798e30f186bcbd149e7)
    { config = config.nixpkgs.config; };
in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  services.nix-daemon.enable = true;

  networking.hostName = "titantosh";

  environment.systemPackages =
    with pkgs; [
      # bazel
      # docker
      # openssl
      # unstable.ngrok
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      autoconf
      automake
      awscli
      bat
      cloc
      clojure
      cmake
      unstable.go
      colordiff
      coreutils
      ctags
      direnv
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
      inetutils
      jq
      llvm
      minio
      mkcert
      nodejs
      opam
      python38
      ripgrep
      rustup
      tldr
      tmux
      tree
      unstable.elixir
      unstable.erlang
      unstable.libsodium
      unstable.neovim
      unstable.rebar3
      unstable.vhs
      vim
      wget
      zsh
    ];
}

