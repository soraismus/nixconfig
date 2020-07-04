{ pkgs ? import <nixpkgs> {} }:

let
  default = import ./default.nix {};

  buildInputs = builtins.attrValues {
    inherit (pkgs) gnumake which;

    inherit (default) purs purp psc-package dhall-simple spago pscid spago2nix purty zephyr;
  };

in
pkgs.mkShell {
  buildInputs = buildInputs;
}
