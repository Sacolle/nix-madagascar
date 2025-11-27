# Compilation of the Madgascar Package for x86\_64 Linux

This project attemps to compile the current version of the [Madagascar package](https://github.com/ahay/src) for NixOS.

Currently the build is failing due to the file build/user/chenyk/Maps3d.c implicit declaration of a function.

To build this package run:
```
nix build
```

