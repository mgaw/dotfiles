{ lib, ... }:

{
  mise.tools.usage = "latest";

  programs.zsh.initContent = lib.mkAfter /* zsh */ ''
    source <(usage generate completion-init zsh)
  '';
}
