{ pkgs }:
pkgs.vim_configurable.customize {
  name = "vim";
  vimrcConfig.customRC = builtins.readFile ./vimrc;
  vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
  vimrcConfig.vam.pluginDictionaries =
    [ {
        names =
          [ "agda-vim"
            # "ale"
            "awesome-vim-colorschemes"
            "elm-vim"
            "fzf-vim"
            "fzfWrapper"
            "fugitive"
            "gundo"
            "idris-vim"
            # "neoterm" # temporarily comment b/c of build issue
            "purescript-vim"
            "syntastic"
            "tabular"
            "tagbar"
            "ultisnips"
            "vim-commentary"
            "vim-easymotion"
            "vim-eunuch"
            "vim-gitgutter"
            "vim-signature"
            "vim-surround"
            # !gh machakan/vim-swap
            "vim-vinegar"
            "vimtex"
          ];
      }
    ];
}
