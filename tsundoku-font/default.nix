{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tsundoku-font";
  version = "2.008";

  src = fetchFromGitHub {
    owner = "soraismus";
    repo = "tsundoku-font";
    rev = "551f7bba5b758ef77495298990accee9c5dae4c4";
    sha256 = "1zkqv9z30f4b4533wqds4hyqa0byiy8ph7cz4ilmv5qd0k88irnx";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/
    cp TsundokuMono-Regular.ttf $out/share/fonts/
  '';

  meta = with lib; {
    description = "Tsundoku Font";
    longDescription = "Glyphs for Tsundoku Logography";
    license = licenses.ofl;
    platforms = [ builtins.currentSystem ];
    maintainers = [ "Matthew-Hilty" ];
  };
}
