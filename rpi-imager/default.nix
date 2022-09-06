{ mkDerivation,
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  curl,
  libarchive,
  util-linux,
  qtbase,
  qtdeclarative,
  qtsvg,
  qttools,
  qtquickcontrols2,
  qtgraphicaleffects
}:

mkDerivation rec {
  pname = "rpi-imager";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = "v${version}";
    sha256 = "11bsdx5jmbqg2dykp8hyc8jy90k8fm6xr69wqx51fbazcps1kygp";
  };

  nativeBuildInputs = [ cmake util-linux ];

  buildInputs = [
    curl
    libarchive
    qtbase
    qtdeclarative
    qtsvg
    qttools
    qtquickcontrols2
    qtgraphicaleffects
  ];

  /* By default, the builder checks for JSON support in lsblk by running "lsblk --json",
    but that throws an error, as /sys/dev doesn't exist in the sandbox.
    This patch removes the check. */
  patches = [ ./lsblkCheckFix.patch ];

  meta = with lib; {
    description = "Raspberry Pi Imaging Utility";
    homepage = "https://www.raspberrypi.org/software/";
    downloadPage = "https://github.com/raspberrypi/rpi-imager/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ymarkus ];
    platforms = platforms.all;
    # does not build on darwin
    broken = stdenv.isDarwin;
  };
}

