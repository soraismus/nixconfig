{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tsundoku-font";
  version = "2.008";

  src = fetchFromGitHub {
    owner = "soraismus";
    repo = "tsundoku-font";
    rev = "8a8c5d241faa406535a2f6fcfb708695ae636e70";
    sha256 = "18azrzbicxjhd8445h32diwrsg859kmm5hjwmi242g10d1r50wrp";
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
