{ config, pkgs, ... }:

let
  inherit (import ../nix/utils.nix config) dotfiles;
in

{
  home.packages = [
    pkgs.zsh-completions
  ];

  programs.zsh = {
    enable = true;
    autocd = true;
    defaultKeymap = "emacs";
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      append = true;
      share = false;
      size = 999999999;
      save = 999999999;
    };
    autosuggestion.enable = true;
    enableCompletion = true;

    plugins = [
      {
        name = "zsh-autopair";
        src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair";
        file = "autopair.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting";
      }
    ];

    initContent = /* zsh */ ''
      # https://zsh.sourceforge.io/Doc/Release/Options.html
      setopt INC_APPEND_HISTORY
      setopt GLOBDOTS
      source ${dotfiles}/zsh/aliases.zsh
      source ${dotfiles}/zsh/git-aliases.zsh
      source ${dotfiles}/zsh/bindkey.zsh
      source ${dotfiles}/zsh/ps1.zsh
    '';
  };
}
