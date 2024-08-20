{ config, pkgs, ...}:

{
  imports = [
    ../home.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages =
    with pkgs; [
    ];

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      minimize-to-application = true;
      mru-spaces = false;
      orientation = "bottom";
      show-recents = false;
      tilesize = 64;
    };

    screencapture.location = "${builtins.getEnv ("HOME")}/Desktop/Screenshots";

    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };

    trackpad = {
      Clicking = true;
    };

    NSGlobalDomain._HIHideMenuBar = false;
  };

  # fonts = {
  #   fontDir.enable = true;
  #   fonts = with pkgs; [
  #     (nerdfonts.override { fonts = [
  #       "FiraCode"
  #       "SourceCodePro"
  #     ]; })
  #   ];
  # };

  homebrew = {
    brewPrefix = "/opt/homebrew/bin";
    enable = true;
    onActivation.autoUpdate = false;
    global = {
      brewfile = true;
      lockfiles = false;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
      "ubuntu/microk8s"
    ];

    brews = [
      "cloudflared"
      "coreutils"
      "direnv"
      "deno"
      "valgrind"
      "freetds"
      "golang"
      "hevea"
      "hyperfine"
      "libsodium"
      "make"
      "mmv"
      "openjdk"
      "protobuf"
      "tidy-html5"
      "watchexec"
      "zellij"
      "rbenv"
      "swift"
      # "Cmake"
      # "llvm"
      # "pulumi"
    ];

    casks = [
      "1password"
      "1password-cli"
      "alacritty"
      "basictex"
      "brave-browser"
      # "db-browser-for-sqlite"
      "discord"
      "docker"
      "kitty"
      "linear-linear"
      "miro"
      "ngrok"
      "notion"
      "obs"
      "pgadmin4"
      "postman"
      "steam"
      "telegram"
      "visual-studio-code"
      "vlc"
      "wezterm"
      # "racket"
    ];
  };

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  system.stateVersion = 4;
}
