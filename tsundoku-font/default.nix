{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tsundoku-font";
  version = "2.008";

  src = fetchFromGitHub {
    owner = "soraismus";
    repo = "tsundoku-font";
    rev = "464fe9b153cc78276fada8e00683b8c9f8d45545";
    sha256 = "0lnnyz0rc158hnw2mxr718r3kwf9am974nqaqpig2485spxpxf7c";
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
