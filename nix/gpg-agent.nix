{ pkgs, lib, ... }:

{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry_mac;
  };

  # Avoid errors during home manager switch
  launchd.agents.gpg-agent.enable = lib.mkForce false;
}
