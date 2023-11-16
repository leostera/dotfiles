{
  description = "cerritosh";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }: {
    darwinConfigurations."cerritosh" = nix-darwin.lib.darwinSystem {
      modules = [
        ./home/.config/nixpkgs/home.nix
        ./home/.config/nixpkgs/darwin/configuration.nix
      ];
    };
  };
}
