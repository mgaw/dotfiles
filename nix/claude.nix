{ config, ... }:

{
  # Avoid "installMethod is native, but claude command not found at ~/.local/bin/claude"
  home.file.".local/bin/claude".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/mise/shims/claude";

  mise.tools = {
    claude = "latest";
  };

  programs.git.ignores = [
    "/.claude/settings.local.json"
    "/CLAUDE.local.md"
  ];
}
