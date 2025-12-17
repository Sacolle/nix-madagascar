{ 
  # derivation dependencies
  lib,
  stdenv,
  fetchFromGitHub,
  #writableTmpDirAsHomeHook,

  python313,
  python313Packages,
  scons,
  gcc13Stdenv,


  # Packages for the pens

  libx11, # add the .dev
  libxaw,
  # dont think i need this, but
  libgcc,

  libtiff,
  gd,
  plplot,
  ffmpeg,
  cairo,
  libjpeg,

  #opengl
  freeglut,
  # glui

  # autoreconfHook,
  # starpu dependencies
}:
gcc13Stdenv.mkDerivation (finalAttrs: 
let 
    mkLibPaths = libs: builtins.concatStringsSep "," (map (p: "${p}/lib") libs);
    mkIncludePaths = inc: builtins.concatStringsSep " " (map (p: "-isystem ${p}/include") inc);
in
{
    pname = "madagascar";
    system = "x86_64-linux";
    version = "4.2";

    src = fetchFromGitHub {
        owner = "ahay";
        repo = "src";
        # url = "https://github.com/ahay/src/tree/madagascar-core-${version}";
        rev = "3cd212fda36aeba82a598e93d162818c49adb385";
        hash = "sha256-KvxbrUFfumR5X4CQFpDDXEnwKKuK9uV5MiouH5zPe1g=";
    };


    postUnpack = ''
        echo "removing unwanted directory" $sourceRoot 
        rm -rf $sourceRoot/user
    '';

    preConfigure = ''
        configureFlagsArray+=(
          "CFLAGS=${mkIncludePaths [ libtiff.dev libx11.dev python313 ] }"
          "LIBPATH=${mkLibPaths [ libtiff.out libx11.out ] }"
        )
      '';


    nativeBuildInputs = [
        scons

        libtiff.dev
        libtiff
    ];

    buildInputs = [
        libtiff.dev
        libtiff

        python313
        python313Packages.pip
        scons
    ];


    preBuild = ''
      echo "Using GCC version:"
      $CC --version
      echo cairo $CAIRO-PDF
    '';


      postConfigure = ''
        cat config.log
        # Patch shebangs recursively because a lot of scripts are used
        shopt -s globstar
        patchShebangs --build **/*.sh
      '';

      enableParallelBuilding = true;
      doCheck = true;
})



