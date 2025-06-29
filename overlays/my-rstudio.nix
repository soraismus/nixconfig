# overlays/my-overlays.nix
self: super: {
  myRstudio = super.rstudioWrapper.override {
    packages = with super.rPackages; [
      data_table
      dplyr
      ggplot2
      ggraph
      languageserver
      patchwork
      shiny
      tidyr
      tidyverse
    ];
  };
}
