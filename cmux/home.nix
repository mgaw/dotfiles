{ config, ... }:

{
  home.sessionVariables.CMUX_COMPUTER_USE_MCP_DISABLED = "1";

  home.file = {
    ".config/cmux/cmux.json".source = config.utils.mkDotfilesSymlink "cmux/cmux.json";
  };

  homebrew.casks = [
    "cmux"
  ];
}
