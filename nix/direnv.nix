{ ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    silent = true;
    config = {
      warn_timeout = "0s";
      hide_env_diff = true;
    };
    nix-direnv.enable = true;
    stdlib = builtins.readFile ./run_if_changed.sh;
  };

  programs.git.ignores = [
    "/.direnv"
  ];
}
