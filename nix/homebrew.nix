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

  config.home.sessionVariables = {
    HOMEBREW_NO_INSTALL_CLEANUP = "yes";
    HOMEBREW_NO_ANALYTICS = 1;
    HOMEBREW_NO_AUTO_UPDATE = 1;
  };

  config.home.activation.homebrew = lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
    if ! /usr/bin/xcode-select --version >/dev/null 2>&1; then
      echo "Will install command line tools..."
      run /usr/bin/xcode-select --install
    fi

    if ! /opt/homebrew/bin/brew --version >/dev/null 2>&1; then
      echo "Will install brew..."
      # https://brew.sh/
      run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    run /opt/homebrew/bin/brew bundle --file ${brewfileFile} --cleanup --force-cleanup --verbose
  '';
}
