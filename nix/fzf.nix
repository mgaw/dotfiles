{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--reverse"
    ];
    fileWidgetCommand = "${pkgs.fd}/bin/fd --hidden --exclude .git"; # apply .gitignore
  };
}
