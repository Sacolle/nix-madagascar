{
    description = "A very basic flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    outputs = { self, nixpkgs }: 
    let 
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
        madagascar = pkgs.callPackage ./madagascar.nix {}; 
    in 
    {
        packages.${system}.default = madagascar;
        devShells.${system}.default = pkgs.mkShell {
            buildInputs = [
                pkgs.scons
                madagascar
                pkgs.libjpeg
            ];
        };
    };
}
