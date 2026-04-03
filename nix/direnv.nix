{ lib, pkgs, ... }:

{
  mise.tools.direnv = "latest";

  xdg.configFile."direnv/direnv.toml".text = /* toml */ ''
    [global]
    warn_timeout = "0s"
    hide_env_diff = true
  '';

  xdg.configFile."direnv/direnvrc".text = /* sh */ ''
    source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
    ${builtins.readFile ./run_if_changed.sh}
  '';

  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };

  programs.zsh.initContent = lib.mkAfter /* zsh */ ''
    eval "$(direnv hook zsh)"
  '';

  programs.git.ignores = [
    "/.direnv"
  ];
}
