{ pkgs }:

with pkgs; [
  feh           # light-weight image viewer and screenshot manager
  ffmpeg        # manager and converter of audio/video files
  pandoc        # utility that translates between markup formats
  pavucontrol   # pulseaudio volume control
  poppler_utils # pdf rendering library

  qpdf          # c++ programs that inspect/manipulate pdf files;
                # swiss-army knife for PDF structure;
                # extracts, encrypts, linearizes, etc.

  vlc           # cross-platform media player and streaming server
  xournalpp     # math-adjacent pdf annotator

  zathura       # pdf reader with vim bindings; plugin-based document viewer;
                # can use mupdf as plugin

  zk            # zettelkasten note-taking [cf. obsidian]


  # Consider
  # --------
  # calibre      # e-book software (calibredb, ebook-convert, ebook-viewer, etc.)

  # graphviz     # graph visualization tool
  # koreader     # ebook-reader application
  # libreoffice  # open-source office suite
  # manim        # animation engine for explanatory mathematics videos

  # neuron       # functional Zettelkasten with a web ui;
                 # written in haskell;
                 # focuses on permanent note ids, backlinks, and a web-based browser

  # newsboat     # terminal rss/atom-feed reader
  # nom          # terminal rss-feed reader
  # presenterm   # terminal-based slideshow tool
  # texstudio    # tex and latex editor
  # typst        # markup-based typesetting system
]


#   let
#     neuronSrc = builtins.fetchTarball {
#       url = "https://github.com/srid/neuron/archive/master.tar.gz";
#       # Ideally, pin this to a specific commit for reproducibility
#     };
#     neuronPkg = import neuronSrc { };
#   in
#   environment.systemPackages = with pkgs; [
#     neuronPkg.default
#   ];
