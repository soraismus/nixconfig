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
            "fzf-vim"
            "fzfWrapper"
            "fugitive"
            "gundo"
            # "neoterm" # temporarily comment b/c of build issue
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
