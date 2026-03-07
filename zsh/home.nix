{ config, pkgs, ... }:

{
  home.file.".hushlogin".text = ""; # suppress "Last login" message in new terminal tabs

  home.packages = [
    pkgs.zsh-completions
  ];

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
  };

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
      source ${config.utils.dotfiles}/zsh/aliases.zsh
      source ${config.utils.dotfiles}/zsh/git-aliases.zsh
      source ${config.utils.dotfiles}/zsh/bindkey.zsh
      source ${config.utils.dotfiles}/zsh/ps1.zsh
    '';
  };
}
