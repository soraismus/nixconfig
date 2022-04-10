# Easy PureScript Nix

A project for using PureScript and related tooling easily with Nix. Note that the `purescript` derivation used in nixpkgs is a derivative of the derivation from this project. See `default.nix` for more information on available versions.

## Example usage

See [ci.nix](./ci.nix) in this repo for a Nix expression example to be used with `nix-shell`.

```console
$ nix-shell ./ci.nix
```

Or simply clone this repo, `cd` into it, and type `nix-shell` (which implicitly calls [`shell.nix`](./shell.nix)).

## Potential questions

### How do I use this? (How do I use derivations in Nix?)

I have written about how to use parts of Nix here: <https://github.com/justinwoo/nix-shorts>

### How do I install to my system from here?

Behold:

```console
$ nix-env -f default.nix -iA purs
  # or nix-env -if purs.nix

$ which purs
/home/justin/.nix-profile/bin/purs
$ purs --version
0.14.4
```

Or by `shell.nix`:

```nix
{ pkgs ? import <nixpkgs> { } }:
let
  easy-ps = import
    (pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      rev = "5716cd791c999b3246b4fe173276b42c50afdd8d";
      sha256 = "1r9lx4xhr42znmwb2x2pzah920klbjbjcivp2f0pnka7djvd2adq";
    }) {
    inherit pkgs;
  };
in
pkgs.mkShell {
  buildInputs = [
    easy-ps.purs-0_14_4
    easy-ps.psc-package
  ];
}
```

## Why was this made?

See the blog post about this here: <https://github.com/justinwoo/my-blog-posts/blob/master/posts/2018-10-24-using-purescript-easily-with-nix.md>

Raison d'etre: <https://github.com/justinwoo/my-blog-posts/blob/master/posts/2019-04-29-why-easy-purescript-nix.md>

## Credits

Thanks to Pekka (@kaitanie) for making this work on NixOS.
