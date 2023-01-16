{ pkgs }:
let
  mhVimPlugins = {
    vim-crunch = pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "vim-crunch";
      version = "2021-09-07";
      src = pkgs.fetchFromGitHub {
        owner = "arecarn";
        repo = "vim-crunch";
        rev = "2c99271108e0d86341837f185a6102363ccee8a6";
        sha256 = "1qj5js3kpahslcj7vcwqmy19517hzqi4y8p710482w4k9w5ljrg6";
      };
      meta.homepage = "https://github.com/arecarn/vim-crunch/";
    };
  };
in
  pkgs.vim_configurable.customize {
    name = "vim";
    vimrcConfig.customRC = builtins.readFile ./vimrc;
    # vimrcConfig.vam.knownPlugins = pkgs.vimPlugins // mhVimPlugins;
    # vimrcConfig.vam.pluginDictionaries =
    vimrcConfig.packages.mhVimPackage = with pkgs.vimPlugins; {
      start =
        # [ "agda-vim"
        #   # "ale"
        [ awesome-vim-colorschemes
          fzf-vim
          fzfWrapper
          fugitive
          gundo
          # "neoterm" # temporarily comment b/c of build issue
          syntastic
          tabular
          tagbar
          ultisnips
          unicode-vim
          vim-capslock
          vim-commentary
          mhVimPlugins.vim-crunch
          vim-dadbod
          vim-easymotion
          vim-eunuch
          vim-gitgutter
          vim-unimpaired
          vim-signature
          vim-subversive
          vim-surround
          # !gh machakan/vim-swap
          vim-tbone
          vim-unicoder
          vim-vinegar
          vimtex
        ];
      };
  }
