#

{ 
  # derivation dependencies
  lib,
  stdenv,
  fetchFromGitHub,
  #writableTmpDirAsHomeHook,

  python313,
  python313Packages,
  scons
  # autoreconfHook,
  # starpu dependencies
}:
stdenv.mkDerivation (finalAttrs: {
    pname = "madagascar";
    system = "x86_64-linux";
    version = "4.2";

    # TODO: validar que está certo
    src = fetchFromGitHub {
        owner = "ahay";
        repo = "src";
        # url = "https://github.com/ahay/src/tree/madagascar-core-${version}";
        rev = "23410e245404a67a8f252ba18f71d112b0348c4e";
        hash = "sha256-8XYlx+t0J0lmr1WqVxFj8kVsJYF3rtzc9GVzQvt+LCI=";
    };

    nativeBuildInputs = [
        # writableTmpDirAsHomeHook
        # autoreconfHook
    ];

    buildInputs = [
        python313
        python313Packages.pip
        scons
    ];

    configureFlags = [
        #"--prefix=$out"
    ];


      postConfigure = ''
        # Patch shebangs recursively because a lot of scripts are used
        shopt -s globstar
        patchShebangs --build **/*.sh
      '';

      enableParallelBuilding = true;
      doCheck = true;
})



