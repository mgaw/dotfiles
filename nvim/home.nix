{ config, pkgs, ... }:

let
  python = pkgs.python3.withPackages (ps: [
    ps.pynvim
    ps.jupyter-client # molten-nvim
  ]);
in
{
  mise.tools.neovim = "latest";
  mise.tools.tree-sitter = "latest";

  xdg.configFile.nvim.source = config.utils.mkDotfilesSymlink "nvim";

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.NVIM_PYTHON3_HOST_PROG = "${python}/bin/python3";

  programs.git.ignores = [
    "/.nvim.lua"
  ];
}
