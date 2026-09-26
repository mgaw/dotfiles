# Simplified version of https://github.com/nix-darwin/nix-darwin/blob/master/modules/homebrew.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  brewfile = lib.concatMapStringsSep "\n" (cask: ''cask "${cask}"'') config.homebrew.casks;
  brewfileFile = pkgs.writeText "Brewfile" brewfile;

  homebrewEnvVars = [
    "HOMEBREW_NO_ANALYTICS"
    "HOMEBREW_NO_AUTO_UPDATE"
    "HOMEBREW_NO_INSTALL_CLEANUP"
    "HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS"
  ];
in

{
  options.homebrew = {
    casks = lib.mkOption {
      default = [ ];
    };
  };

  config.home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  config.home.sessionVariables = lib.genAttrs homebrewEnvVars (_: 1);

  config.home.activation.homebrew = lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
    ${lib.concatMapStringsSep "\n" (name: "export ${name}=1") homebrewEnvVars}

    if ! /opt/homebrew/bin/brew --version >/dev/null 2>&1; then
      echo "Will install brew..."
      # https://brew.sh/
      run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    run /opt/homebrew/bin/brew bundle cleanup --file ${brewfileFile} --install --force --verbose
  '';
}
