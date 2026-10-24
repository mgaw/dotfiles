{ config, lib, ... }:

let
  removeExtension = name: lib.head (lib.splitString "." name);
  scripts = lib.filterAttrs (_: type: type == "regular") (builtins.readDir ../bin);
in
{
  home.file = lib.mapAttrs (name: _: {
    target = ".local/bin/${removeExtension name}";
    source = config.utils.mkDotfilesSymlink "bin/${name}";
  }) scripts;

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];
}
