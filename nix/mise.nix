{
  config,
  lib,
  pkgs,
  ...
}:

# Using home manager to manage global mise config but otherwise use directly installed mise
# to have access to the latest version.
let
  miseBinPath = "${config.home.homeDirectory}/.local/bin";
  miseBin = "${miseBinPath}/mise";
in
{
  options.mise = {
    tools = lib.mkOption {
      default = { };
    };
  };

  config.home.activation.mise = lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
    if [ ! -f "${miseBin}" ]; then
      # https://mise.jdx.dev/getting-started.html#installing-mise-cli
      run ${pkgs.curl}/bin/curl -fsS https://mise.run |
        PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:$PATH" sh
    fi

    PATH="${pkgs.nodejs}/bin:${miseBinPath}:$PATH" run mise install
  '';

  config.mise.tools = {
    usage = "latest"; # required by mise completions
  };

  config.programs.mise = {
    enable = true;
    enableZshIntegration = false;
    package = pkgs.writeShellScriptBin "mise" ''exec ${miseBin} "$@"'';
    globalConfig = {
      tools = config.mise.tools;
      settings = {
        idiomatic_version_file_enable_tools = [ ];
        experimental = true;
        # https://mise.jdx.dev/configuration/settings.html#install_before
        install_before = "3d";
      };
    };
  };

  config.programs.zsh.initContent = /* zsh */ ''
    eval "$(${miseBin} activate zsh)"
    eval "$(${miseBin} completions zsh)"
  '';

  config.programs.git.ignores = [
    "/mise.local.toml"
  ];
}
