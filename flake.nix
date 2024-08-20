{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }: {
    darwinConfigurations."starbase1" = nix-darwin.lib.darwinSystem {
      modules = [
        ./home/.config/nixpkgs/home.nix
        ./home/.config/nixpkgs/darwin/configuration.nix
      ];
    };
    darwinConfigurations."cerritosh" = nix-darwin.lib.darwinSystem {
      modules = [
        ./home/.config/nixpkgs/home.nix
        ./home/.config/nixpkgs/darwin/configuration.nix
      ];
    };
  };
}
