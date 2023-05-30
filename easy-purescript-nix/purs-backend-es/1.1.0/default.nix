# This file was not generated, it was actually copied from ../../pulp/16.0.2/default.nix
# This file has been generated by node2nix 1.9.0. Do not edit!

{ pkgs ? import <nixpkgs> {
    inherit system;
  }
, system ? builtins.currentSystem
, nodejs ? pkgs."nodejs-14_x"
}:

let
  nodeEnv = import ./node-env.nix {
    inherit (pkgs) stdenv lib python2 runCommand writeTextFile writeShellScript;
    inherit pkgs nodejs;
    libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
  };

  nodePackage = import ./node-packages.nix
    {
      inherit (pkgs) fetchurl nix-gitignore stdenv lib fetchgit;
      inherit nodeEnv;
    };

  source = nodePackage.sources."purs-backend-es-1.1.0".src;
in
nodeEnv.buildNodePackage (nodePackage.args // { src = source; })
