{ config, pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  news.display = "show";

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      # https://github.com/nix-community/home-manager/issues/5805
      # use-xdg-base-directories = true;
    };
  };

  home.stateVersion = "24.05";

  home.sessionPath = [
    # I currently don't source nix-daemon.sh in /etc/zshrc, I'm not sure why things don't break.
    # https://github.com/NixOS/nix/issues/3616
    "${config.home.homeDirectory}/.nix-profile/bin"
    "/nix/var/nix/profiles/default/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ];

  programs.home-manager = {
    enable = true;
  };
}
