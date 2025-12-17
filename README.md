# Compilation of the Madgascar Package for x86\_64 Linux

This project attemps to compile the current version of the [Madagascar package](https://github.com/ahay/src) for NixOS.

Currently the build is failing due to the file build/user/chenyk/Maps3d.c implicit declaration of a function.

To build this package run:
```
nix build
```

## Stopping the user programs

I've stopped building the user programs, with the snippet:
```nix
postUnpack = ''
    echo "removing unwanted directory" $sourceRoot 
    rm -rf $sourceRoot/user
'';
```
Which, after unpacking, but before configuring, deletes the user folder. Therefore `SCons` doesn't see it and doesn't build it.

## Building the Pens

I'm trying to build the pens and failing, and i think i know why:

To observe teh compilation step, run:
```
nix build --verbose
```
This will build the package and output the path of the derivation that it constructed to do so, a `.drv` file.

With the path, run:
```
nix log $path
```
That will show what happened during the compilation. The problem right now is that if **Madagascar** does not find the packages to build a pen, it simply does not build it, now throwing any error. Currenlty, no pen is being built. This is, in part, due to the `./configure` file not finding any associated library to do so. This is according to this log snippet:
```bash
checking platform ... (cached) posix [unknown]
checking for C compiler ... (cached) gcc
checking if gcc works ... yes
checking if gcc accepts '-x c -std=gnu17 -Wall -pedantic' ... yes
checking for ar ... (cached) ar
checking for rpc ... no
checking complex support ... yes
checking complex support ... yes
checking for X11 headers ... (cached) no
checking for OpenGL ... no
checking for sfpen ... (cached) no

  sfpen (for displaying .vpl images) will not be built.
checking for ppm ... no
checking for tiff ... no

  sfbyte2tif, sftif2byte, and tiffpen will not be built.
checking for GD (PNG) ... no

  gdpen will not be built.
checking for plplot ... no
checking for ffmpeg ... no
checking for cairo (PNG) ... no
checking for jpeg ... no

  sfbyte2jpg, sfjpg2byte, and jpegpen will not be built.
checking for BLAS ... no
checking for X11 headers ... (cached) no
checking for OpenGL ... no
checking for sfpen ... (cached) no

  sfpen (for displaying .vpl images) will not be built.
checking for ppm ... no
checking for tiff ... no
```

Therefore, i need to go one by one and find which packages are needed to build each pen, and make a cool interface for that. But it is important that the headers are found in the configuration step, because even if the packages are available in the build step, `SCons` will not attemp to build them if it does not detect in the configuration step.
The file in the repo that defines that step is this one:

https://github.com/ahay/src/blob/3cd212fda36aeba82a598e93d162818c49adb385/framework/configure.py#L594

## Configuring

So, in the [setenv.py](https://github.com/ahay/src/blob/3cd212fda36aeba82a598e93d162818c49adb385/framework/setenv.py#L82), it initalized a config.py that holds infor path and stuff. I believe that this is where the acessed context is defined, so by doing a step by step derivation, i could see the default config.py generated. With that file, it would be simple to write some injection or write one with the configs passed to the derivation.


## Coisas

```
nix-shell -p python313 python313Packages.pip scons pkg-config libtiff

./configure CFLAGS="$NIX_CFLAGS_COMPILE" LIBPATH='/nix/store/9mzjwp20ds2p4ylzhs6q1qgr921asizm-libtiff-4.7.0/lib,/nix/store/9mzjwp20ds2p4ylzhs6q1qgr921asizm-libtiff-4.7.0/lib' --prefix=.
```

out of $NIX\_CFLAGS\_COMPILE
```
-frandom-seed=kyc7aa8m13 -isystem /nix/store/iyff8129iampdw13nlfqalzhxy8y1hi9-python3-3.13.6/include -isystem /nix/store/wnlv4y888lggq0haibpwfzsl2vhlkciv-libtiff-4.7.0-dev/include -isystem /nix/store/iyff8129iampdw13nlfqalzhxy8y1hi9-python3-3.13.6/include -isystem /nix/store/wnlv4y888lggq0haibpwfzsl2vhlkciv-libtiff-4.7.0-dev/include
```


- Ver como fazer o log ser mais verboso, para mostrar os args passados ao config
