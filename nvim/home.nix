{ config, ... }:

{
  mise.tools = {
    "pipx:pynvim" = {
      version = "latest";
      uvx_args = "--with jupyter-client"; # molten-nvim
    };
    neovim = "latest";
    tree-sitter = "latest";
  };

  xdg.configFile.nvim.source = config.utils.mkDotfilesSymlink "nvim";

  home.sessionVariables.EDITOR = "nvim";

  programs.git.ignores = [
    "/.nvim.lua"
  ];
}
