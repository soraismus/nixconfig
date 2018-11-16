{ pkgs }:
pkgs.vim_configurable.customize {
  name = "vim";
  vimrcConfig.customRC = builtins.readFile ./vimrc;
  vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
  vimrcConfig.vam.pluginDictionaries =
    [ {
        names =
          [ "ale"
            "fzf-vim"
            "fzfWrapper"
            "fugitive"
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
