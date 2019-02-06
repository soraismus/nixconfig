{ stdenv, lib, fetchurl }:
let
  version = "0.6.pre13";
in
stdenv.mkDerivation {
  name = "oil-${version}";

  src = fetchurl {
    url = "https://www.oilshell.org/download/oil-${version}.tar.xz";
    sha256 = "3af4ca367dda26d2e67211db95a22d91e9840a3b18ad466c56458fa3b15af6a1";
  };

  postPatch = ''
    patchShebangs build
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  # Stripping breaks the bundles by removing the zip file from the end.
  dontStrip = true;

  meta = {
    homepage = https://www.oilshell.org/;

    description = "A new unix shell, still in its early stages";

    license = with lib.licenses; [
      psfl # Includes a portion of the python interpreter and standard library
      asl20 # Licence for Oil itself
    ];

    maintainers = with lib.maintainers; [ lheckemann ];
  };
}
