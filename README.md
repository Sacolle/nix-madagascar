# Compilation of the Madgascar Package for x86\_64 Linux

This project attemps to compile the current version of the [Madagascar package](https://github.com/ahay/src) for NixOS.

Currently the build works, compiling the x11 and openGL pens, which enable visualization of the libraries outputs.

This is a fully funcioting flake, so adding it to your flake's inputs and passing it to a dev shell is enought to make it work.

```nix
{
    description = "An example flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        madagascar.url = "github:Sacolle/nix-madagascar";
    };

    outputs = { self, nixpkgs, madagascar }: 
    let 
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
        };
    in
    {
        devShells.${system} = {
            default = pkgs.mkShell { buildInputs = [ madagascar.packages.${system}.default ];};
        };
    };
}

```


## Stopping the user programs

This package includes some user programs. They're are of use for me at the moment, so i'm not building them.

I've stopped building the user programs, with the snippet:
```nix
postUnpack = ''
    echo "removing unwanted directory" $sourceRoot 
    rm -rf $sourceRoot/user
'';
```
Which, after unpacking, but before configuring, deletes the user folder. Therefore `SCons` doesn't see it and doesn't build it.

## Roadmap

This is not the complete compilation of the Madagascar package for NixOS. Here follows the next steps before possibly adding it to nixpkgs 

- [ ] Compile the RPC part of the code.
    - It seems to detect the RPC library, but it does not pass the -ltirpc to the binaries that need it
- [ ] Compile the accelerators
    - TODO:
- [ ] Compile the user programs
