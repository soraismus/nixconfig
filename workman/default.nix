{ fetchurl, stdenv }:

{
  workman = stdenv.mkDerivation rec {
    name = "workman-mh-nix-${version}";
    version = "1.0.0";

    src = fetchurl {
      url = "https://raw.githubusercontent.com/kdeloach/workman/debd4718fcf44a9a7931c3cf99c945473c0afd72/linux_console/workman-p.iso15.kmap";
      sha256 = "1913c0067f87df698ae23e86ad295863f491b7d2e82ac3c2e4a03f3404195f42";
    };

    buildCommand = ''
      install -D $src $out/share/keymaps/i386/workman/workman-p.map
    '';
  };
}

