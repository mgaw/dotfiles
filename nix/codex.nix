{ ... }:

{
  mise.tools.codex = "latest";

  programs.zsh.shellAliases.cx = "codex";

  programs.git.ignores = [
    "/AGENTS.override.md"
  ];
}
