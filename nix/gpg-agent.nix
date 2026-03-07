{ pkgs, ... }:

{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry_mac;
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = ""; # allow services.gpg-agent to set it
  };
}
