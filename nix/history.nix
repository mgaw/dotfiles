{ config, lib, ... }:

let
  historyPath = "${config.xdg.dataHome}/history";
in

{
  home = {
    activation = {
      # Some tools refuse to write their history file if the directory does not exist (e.g. node)
      makeHistoryPath = lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
        run mkdir -p ${historyPath}
      '';
    };

    sessionVariables = {
      # https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_HISTORY
      PYTHON_HISTORY = "${historyPath}/python_history";

      # https://nodejs.org/api/repl.html#environment-variable-options
      NODE_REPL_HISTORY = "${historyPath}/node_history";

      # https://man7.org/linux/man-pages/man1/less.1.html#ENVIRONMENT_VARIABLES
      LESSHISTFILE = "${historyPath}/less_history";
    };
  };

  programs = {
    bash.historyFile = "${historyPath}/bash_history";
    zsh.history.path = "${historyPath}/zsh_history";
  };
}
