{ pkgs }:
let
  mhVimPlugins = {
    vim-crunch = pkgs.vimUtils.buildVimPlugin {
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
    vimrcConfig.customRC = import ./vimrc { pkgs = pkgs; };
    vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
      opt = [];
      start =
        [
          # agda-vim
          # ale # Cf. coc.nvim. [Cf. https://www.vimfromscratch.com/articles/vim-and-language-server-protocol]

          awesome-vim-colorschemes

          # # COC (Conqueror of Code)
          # # ---
          # # ---
          # # !gh/neoclide/coc-denite: List filtering and sorting.
          # # !gh/Shougo/denite.nvim
          # # Note: Active development on denite.nvim has stopped. The only future changes will be bug fixes.
          # # Please see ddu.vim.
          # # Denite is a plugin for Neovim/Vim to unite all interfaces.
          # # It can replace many features or plugins with its interface.
          # # It is like a fuzzy finder, but is more generic.
          # # Features: opening files; switching buffers; inserting the value of a register; searching for a string
          # # cf. !gh/Shougo/unite.vim
          # # Note: Active development on denite.nvim has stopped. The only future changes will be bug fixes.
          # # Please see ddu.vim.
          # # The unite or unite.vim plug-in can search and display information from arbitrary sources
          # # like files, buffers, recently used files or registers.
          # # You can run several pre-defined actions on a target displayed in the unite window.
          # # The difference between unite and similar plug-ins like
          # # fuzzyfinder, ctrl-p or ku
          # # is that unite provides an integration interface for several sources and you can create new interfaces using unite.
          # coc-denite
          # # --
          # # --
          # # Use FZF instead of coc.nvim built-in fuzzy finder.
          # # It was inspired by Robert Buhren's functions and coc-denite.
          # # Make sure to have the following plugins in your **vimrc**:
          # #   junegunn/fzf
          # #   junegunn/fzf.vim # Needed for previews.
          # #   neoclide/coc.nvim
          # #   antoinemadec/coc-fzf
          coc-fzf
          # # --
          # # --
          # # !gh/neoclide/coc-nvim
          # # Coc.nvim enhances your (Neo)Vim to match the user experience provided by VSCode
          # # through a rich extension ecosystem and implemented the client features
          # # specified by Language Server Protocol (3.17 for now), see |coc-lsp|.
          # # Some key features:~
          # #  • Typescript APIs compatible with both Vim8 and Neovim.
          # #  • Loading VSCode-like extensions |coc-api-extension|.
          # #  • Configuring coc.nvim and its extensions with JSON configuration |coc-configuration|.
          # #  • Configuring Language Servers that using Language Server Protocol (LSP) |coc-config-languageserver|.
          coc-nvim # Cf. ale.
          coc-pyright # pyright extension for coc.nvim.

          # comfortable-motion-vim
          command-t
          fzf-vim
          fzfWrapper
          fugitive
          gundo
          indentLine
          latex-live-preview
          markdown-preview-nvim
          # neoterm # Temporarily comment b/c of build issue.
          neuron-vim # [cf. obsidian-nvim; vim-wiki; zk-vim]
          obsidian-nvim # knowledge base # [cf. neuron-vim; vim-wiki; zk-vim]
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
          vim-repeat
          vim-signature
          vim-snippets # Complement to ultisnips.
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
          vimwiki
          YouCompleteMe
          # zk-vim # Zettelkasten note-taking [cf. neuron-vim; obsidian-nvim; vim-wiki]
        ];
  };
}
