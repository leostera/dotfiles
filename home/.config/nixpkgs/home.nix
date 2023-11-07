{ config, pkgs, ...}:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/ea9c1ad0e77c89cddbd65907e4286d7d633b32d8)
    { config = config.nixpkgs.config; };
in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  services.nix-daemon.enable = true;

  networking.hostName = "cerritosh";

  environment.systemPackages =
    with pkgs; [
      # bazel
      # docker
      # openssl
      # unstable.ngrok
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      autoconf
      automake
      # awscli
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
      unstable.nodejs
      opam
      python38
      ripgrep
      rustup
      tldr
      tmux
      tree
      unstable.elixir_1_15
      unstable.erlangR26
      unstable.libsodium
      unstable.neovim
      unstable.rebar3
      unstable.vhs
      vim
      wget
      zsh
    ];
}

