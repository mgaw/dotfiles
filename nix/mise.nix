{
  config,
  lib,
  pkgs,
  ...
}:

let
  miseBinPath = "${config.home.homeDirectory}/.local/bin";
  miseBin = "${miseBinPath}/mise";
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

  config.xdg.configFile = {
    "mise/config.toml".source = config.utils.toml.generate "mise-config" {
      tools = config.mise.tools;
      # https://mise.jdx.dev/configuration/settings.html
      settings = {
        idiomatic_version_file_enable_tools = [ ];
        experimental = true;
        lockfile_platforms = [ "macos-arm64" ];
        minimum_release_age = "3d";
        python.compile = false;
      };
    };
    "mise/config.local.toml".source = config.utils.toml.generate "mise-config-local" {
      tools = config.mise.localTools;
    };
    "mise/mise.lock".source = config.utils.mkDotfilesSymlink "mise/mise.lock";
  };

  config.programs.zsh.initContent = /* zsh */ ''
    eval "$(${miseBin} activate zsh)"
    eval "$(${miseBin} completions zsh)"
  '';

  config.programs.git.ignores = [
    "/mise.local.toml"
    "/mise.local.lock"
  ];
}
