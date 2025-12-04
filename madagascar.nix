#

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
gcc13Stdenv.mkDerivation (finalAttrs: {
    pname = "madagascar";
    system = "x86_64-linux";
    version = "4.2";

    # TODO: validar que está certo
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
        echo $LIBS
  '';

    nativeBuildInputs = [
        scons

        libtiff.dev
        libtiff
    ];

    buildInputs = [
        # testing if they are recognized
        libx11 # add the .dev?
        libx11.dev

        libxaw
        libxaw.dev

        libgcc

        libtiff.dev
        libtiff

        python313
        python313Packages.pip
        scons
    ];

    configureFlags = [
        #"--prefix=$out"
    ];
    preBuild = ''
      echo "Using GCC version:"
      $CC --version
        echo cairo $CAIRO-PDF
    '';


      postConfigure = ''
        # Patch shebangs recursively because a lot of scripts are used
        shopt -s globstar
        patchShebangs --build **/*.sh
      '';

      enableParallelBuilding = true;
      doCheck = true;
})



