{ pkgs }:

with pkgs; [
  delta        # syntax-highlighting pager for git (diff alternative)
  git          # vcs (version control system)
  gitui        # terminal ide for git
  lean4        # automatic and interactive theorem prover
  nodejs_20
  sqlite       # self-contained SQL database engine
  sqlite-utils # CLI utility and library for manipulating SQLite databases

  # Consider
  # --------
  # agda
  # cabal-install  # haskell packaging and build system
  # coq_8_9        # coq theorem assistant
  # sageWithDoc    # cas / maths
  # stack          # haskell tool stack

  # tig            # text-mode interface for git;
                   # pager-style Git history explorer;
                   # more conservative than GitUI, but effective
]
