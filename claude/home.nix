{ config, ... }:

{
  home.file = {
    ".claude/settings.json".source = config.utils.mkDotfilesSymlink "claude/settings.json";
    # Avoid "installMethod is native, but claude command not found at ~/.local/bin/claude"
    ".local/bin/claude".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/mise/shims/claude";
  };

  mise.tools = {
    claude = "latest";
  };
}
