{ 
  # derivation dependencies
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  #writableTmpDirAsHomeHook,

  python313,
  python313Packages,
  scons,
  gcc13Stdenv,
  # Packages for the pens
  #rpc package
  libtirpc,

  #ppm
  netpbm,

  libx11, # add the .dev
  libxaw,
  libxt,
  libxmu,
  libsm,
  libice,
  xorg, # for xorg proto

  libtiff,
  gd,
  plplot,
  libtool,
  ffmpeg,
  cairo,
  libjpeg,

  #opengl
  freeglut,
  libGLU,
  libGL
  # glui

  # autoreconfHook,
  # starpu dependencies
}:
gcc13Stdenv.mkDerivation (finalAttrs: 
let 
    mkLibPaths = libs: builtins.concatStringsSep "," (map (p: "${p}/lib") libs);
    mkIncludePaths = inc: builtins.concatStringsSep " " (map (p: "-isystem ${p}/include") inc);
    includePkgs = [
        # rpc
	# the config does something weird and adds the rpc name based on the OS,
	# given the OS is not on the list, it seems that it never appends -ltirpc on the linker
        # libtirpc.dev
        # ppm
        netpbm.dev
        #X11 headers ( )
        libx11.dev
        libxaw.dev
	libxt.dev
	libxmu.dev
	libsm.dev
	libice.dev
	xorg.xorgproto
        # OpenGL (X)
        freeglut.dev
        libGLU.dev
        libGL.dev
        # tiff (X)
        libtiff.dev
        # png (X)
        gd.dev
        #  ( )
        plplot
        libtool
        #  ( )
        ffmpeg.dev
        # png ( )
        cairo.dev
        # libjpeg ( )
        libjpeg.dev
    ];
    #subdirectories in the includes that it does not find
    extraIncludeFlags = builtins.concatStringsSep " " [
        " -isystem ${plplot.out}/include/plplot"
        " -isystem ${cairo.dev}/include/cairo"
        " -isystem ${ffmpeg.dev}/include/libavcodec"
        " -isystem ${netpbm.dev}/include/netpbm"
        # " -isystem ${libtirpc.dev}/include/tirpc"
    ];

    libPkgs = [
        # libtirpc.out
        netpbm.out
        libx11.out
        libxaw.out
	libxt.out
	libxmu.out
	libsm.out
	libice.out
	xorg.xorgproto
        freeglut.out
        libGLU.out
        libGL.out
        libtiff.out
        gd.out
        plplot.out
        libtool.lib
        ffmpeg.lib
        cairo.out
        libjpeg.out
    ];
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
     	echo ${mkIncludePaths includePkgs}
        echo "removing unwanted directory" $sourceRoot 
        rm -rf $sourceRoot/user
    '';


    preConfigure = ''
        configureFlagsArray+=(
	  "CFLAGS=${ (mkIncludePaths includePkgs) + extraIncludeFlags }"
          "LIBPATH=${ mkLibPaths libPkgs }"
	  "XINC=${libxaw.dev}/include"
	  "XLIBPATH=${libx11.out}/lib"
        )
      '';

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
        python313
        python313Packages.pip
        scons
    ] ++ libPkgs ++ includePkgs;

      postConfigure = ''
        cat config.log
        # Patch shebangs recursively because a lot of scripts are used
        shopt -s globstar
        patchShebangs --build **/*.sh
      '';

      enableParallelBuilding = true;
      doCheck = true;
})



