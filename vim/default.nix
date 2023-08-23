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
  (pkgs.vim_configurable.override {}).customize {
    name = "vim";
    vimrcConfig.customRC = builtins.readFile ./vimrc;
    vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
      opt = [];
      start =
        [ # agda-vim
          # ale # Cf. coc.nvim. [Cf. https://www.vimfromscratch.com/articles/vim-and-language-server-protocol]
          awesome-vim-colorschemes
          coc-denite
          coc-fzf
          coc-nvim # Cf. ale.
          # comfortable-motion-vim
          command-t
          fzf-vim
          fzfWrapper
          fugitive
          gundo
          indentLine
          # neoterm # temporarily comment b/c of build issue
          latex-live-preview
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
          vim-javascript
          vim-signature
          vim-subversive
          vim-surround
          # !gh machakan/vim-swap
          vim-tbone
          vim-test
          vimtex
          vim-unicoder
          vim-unimpaired
          vimux
          vim-vinegar
          vim-visual-multi
        ];
  };
}
