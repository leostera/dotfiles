{ config, pkgs, ...}:

{
  environment.systemPackages =
    with pkgs; [
      chromiumWrapper
      firefoxWrapper
    ];

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  system.stateVersion = 4;
}
