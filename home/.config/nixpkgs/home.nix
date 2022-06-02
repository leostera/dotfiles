{ config, pkgs, ...}:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/19e187fbabcefa3f3e608b94ed809f91524501bb)
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
      # docker
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
      # unstable.ngrok
      vim
      wget
      zsh
    ];
}

