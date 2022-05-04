{ config, pkgs, ...}:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/bb82344ca6925b1b4e4a7de9465016ba40904fc3)
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
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      autoconf
      awscli
      bat
      cloc
      clojure
      cmake
      colordiff
      coreutils
      ctags
      direnv
      docker
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
      minio
      mkcert
      neovim
      ngrok
      opam
      python38
      rebar3
      ripgrep
      rustup
      telnet
      tldr
      tmux
      tree
      unstable.elixir
      unstable.erlang
      vim
      wget
      zsh
    ];
}

