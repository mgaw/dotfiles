{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--reverse"
    ];
    fileWidget.command = "${pkgs.fd}/bin/fd --hidden --exclude .git"; # apply .gitignore
  };
}
