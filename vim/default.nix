{ pkgs }:
pkgs.vim_configurable.customize {
  name = "vim";
  vimrcConfig.customRC = builtins.readFile ./vimrc;
  vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
  vimrcConfig.vam.pluginDictionaries =
    [ {
        names =
          [ "agda-vim"
            "ale"
            "awesome-vim-colorschemes"
            "elm-vim"
            "fzf-vim"
            "fzfWrapper"
            "fugitive"
            "haskell-vim"
            "idris-vim"
            # "psc-ide-vim"
            "purescript-vim"
            "syntastic"
            "tabular"
            "tagbar"
            "vim-commentary"
            "vim-easymotion"
            "vim-eunuch"
            "vim-gitgutter"
            "vim-signature"
            "vim-surround"
            "vim-vinegar"
          ];
      }
    ];
}
