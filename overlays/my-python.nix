self: super: {
  myPython = super.python312.withPackages (ps: with ps; [
    arxiv2bib
    beautifulsoup4
    pypdf3
    requests
    scrapy

    playwright
    pytest
    pytest-playwright
    tenacity
    pydantic
    pandas

    # Consider
    # ---------
    # bpython
  ]);
}
