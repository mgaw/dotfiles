{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.mise = {
    tools = lib.mkOption {
      default = { };
    };
  };

  config.home.activation = {
    miseInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
      PATH="${pkgs.nodejs}/bin:${pkgs.mise}/bin:$PATH" run mise install
    '';
  };

  config.programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = config.mise.tools;
      settings = {
        idiomatic_version_file_enable_tools = [ ];
      };
    };
  };
}
