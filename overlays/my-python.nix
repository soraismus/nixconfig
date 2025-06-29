self: super: {
  myPython = super.python312.withPackages (ps: with ps; [
    arxiv2bib
    beautifulsoup4
    pypdf3
    requests
    scrapy

    # Consider
    # ---------
    # bpython
  ]);
}
