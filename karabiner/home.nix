{ config, ... }:

{
  home.file = {
    ".config/karabiner".source = config.utils.mkDotfilesSymlink "karabiner";
  };

  homebrew.casks = [
    "karabiner-elements"
  ];
}
