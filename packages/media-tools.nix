{ pkgs }:

with pkgs; [
  feh           # light-weight image viewer and screenshot manager
  ffmpeg        # manager and converter of audio/video files
  pandoc        # utility that translates between markup formats
  pavucontrol   # pulseaudio volume control
  poppler_utils # pdf rendering library
  vlc           # cross-platform media player and streaming server
  xournalpp     # math-adjacent pdf annotator
  zathura       # pdf reader with vim bindings; plugin-based document viewer;
                # can use mupdf as plugin

  # Consider
  # --------
  # calibre                      # e-book software (calibredb, ebook-convert, ebook-viewer, etc.)

  # graphviz                     # graph visualization tool
  # hieroglyphic                 # tex-match; detexify; search by sketching
  # koreader                     # ebook-reader application
  # libreoffice                  # open-source office suite
  # manim                        # animation engine for explanatory mathematics videos
  # manim-slides                 # tool for live presentations using manim
  # newsboat                     # terminal rss/atom-feed reader
  # nom                          # terminal rss-feed reader
  # qpdf                         # c++ programs that inspect/manipulate pdf files
  # presenterm                   # terminal-based slideshow tool
  # texlive.combined.scheme-full # pdflatex, xcolor.sty for pdf conversion
  # texstudio                    # tex and latex editor
  # typst                        # markup-based typesetting system
  # yt-dlp                       # command-line tool to download videos from video platforms
]
