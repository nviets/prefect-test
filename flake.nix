{
  # this is a riff on the standard flake template for a python project
  # https://github.com/NixOS/templates/blob/master/python/flake.nix

  # Prefect is on a branch of my fork of nixpkgs
  inputs.nixpkgs.url = "github:nviets/nixpkgs/0c7e26ee5b80aa99c3aaff5aa98a491b2e93c570";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (system: {
        default = pkgs.${system}.python3Packages.prefect;
      });

      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShellNoCC {
          packages = with pkgs.${system}; [
            # add your packages here, then run "nix develop"
            python3Packages.prefect
            python3Packages.dask
            python3Packages.dask-jobqueue
            python3Packages.distributed
            python3Packages.pandas
          ];
        };
      });
    };
}
