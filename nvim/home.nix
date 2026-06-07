{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    withPython3 = true; # remote plugins (e.g. molten-nvim)
    extraPython3Packages =
      ps: with ps; [
        jupyter-client # molten-nvim
      ];

    extraPackages = [
      pkgs.tree-sitter # treesitter.lua
    ];
  };

  xdg.configFile.nvim.source = config.utils.mkDotfilesSymlink "nvim";

  home.sessionVariables.EDITOR = "nvim";

  programs.git.ignores = [
    "/.nvim.lua"
  ];
}
