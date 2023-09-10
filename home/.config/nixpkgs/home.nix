{ config, pkgs, ...}:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/5b0ed68c106c1cbe3b573f3d1ca8c73eb203e346)
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
      unstable.nodejs
      opam
      python38
      ripgrep
      rustup
      tldr
      tmux
      tree
      # unstable.elixir
      # unstable.erlang
      unstable.libsodium
      unstable.neovim
      unstable.rebar3
      unstable.vhs
      vim
      wget
      zsh
    ];
}

