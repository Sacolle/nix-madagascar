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
  cairo
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
        hash = "sha256-NzzMAi5jxS3FYPN1mH44gKG3ZVlUwpbG4M69rR9GeRk=";
    };

    postUnpack = ''
        echo "removing unwanted directory" $sourceRoot 
        rm -rf $sourceRoot/user
    '';

    nativeBuildInputs = [
        # writableTmpDirAsHomeHook
        # autoreconfHook
        cairo
    ];

    buildInputs = [
        cairo

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



