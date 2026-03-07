{ config, ... }:

{
  home.file = {
    ".config/ghostty/config".source = config.utils.mkDotfilesSymlink "ghostty/config";
  };

  homebrew.casks = [
    "ghostty"
  ];
}
