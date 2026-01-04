{ lib, pkgs, ... }:

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

  programs.home-manager = {
    enable = true;
  };

  # Normally this is sourced in /etc/zshrc but it can be overwritten by macos updates
  # https://github.com/NixOS/nix/issues/3616
  programs.zsh.initContent = lib.mkBefore /* zsh */ ''
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  '';
}
