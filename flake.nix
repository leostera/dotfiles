{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/5ec4f676b47936aa3ccf7122ead2002ab67a5008";
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
