{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }: 
  flake-utils.lib.eachDefaultSystem (system: 
    let pkgs = nixpkgs.legacyPackages.${system};
    in {
      # packages.default = pkgs.callPackage ./default.nix { };
      devShells.default = pkgs.callPackage ./shell.nix { };
    });
}
