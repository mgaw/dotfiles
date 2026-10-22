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
  tomlFormat = pkgs.formats.toml { };
in
{
  options.mise = {
    tools = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Global mise tools locked in dotfiles/mise/mise.lock.";
    };
    localTools = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Private global mise tools, written to config.local.toml and locked separately in mise.local.lock.";
    };
  };

  config.home.activation.mise = lib.hm.dag.entryAfter [ "linkGeneration" ] /* sh */ ''
    if [ ! -f "${miseBin}" ]; then
      # https://mise.jdx.dev/getting-started.html#installing-mise-cli
      run ${pkgs.curl}/bin/curl -fsS https://mise.run |
        PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:$PATH" sh
    fi

    PATH="${pkgs.nodejs}/bin:${miseBinPath}:$PATH" run mise install
  '';

  config.programs.mise = {
    enable = true;
    package = pkgs.writeShellScriptBin "mise" ''
      exec -a "$0" ${miseBin} "$@"
    '';
    enableBashIntegration = false;
    globalConfig = {
      tools = config.mise.tools;
      settings = {
        idiomatic_version_file_enable_tools = [ ];
        experimental = true;
        lockfile_platforms = [ "macos-arm64" ];
        # https://mise.jdx.dev/configuration/settings.html#minimum_release_age
        minimum_release_age = "3d";
        python.compile = false;
      };
    };
  };

  config.xdg.configFile = {
    "mise/config.local.toml".source = tomlFormat.generate "mise-config-local" {
      tools = config.mise.localTools;
    };
    "mise/mise.lock".source = config.utils.mkDotfilesSymlink "mise/mise.lock";
  };

  config.programs.zsh.initContent = /* zsh */ ''
    eval "$(${miseBin} completions zsh)"
  '';

  config.programs.git.ignores = [
    "/mise.local.toml"
    "/mise.local.lock"
  ];
}
