{ config, pkgs, ...}:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  services.nix-daemon.enable = true;

  networking.hostName = "cerritosh";

  environment.systemPackages =
    with pkgs; [
      # bazel
      # docker
      # openssl
      # ngrok
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      autoconf
      automake
      # awscli
      bat
      cloc
      clojure
      cmake
      go
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
      elixir_1_15
      erlangR26
      libsodium
      neovim
      rebar3
      vhs
      vim
      wget
      zsh
    ];
}

