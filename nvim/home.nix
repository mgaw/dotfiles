{ config, pkgs, ... }:

let
  inherit (import ../nix/utils.nix config) mkDotfilesSymlink;
in

{
  programs.neovim = {
    enable = true;

    withPython3 = true; # remote plugins (e.g. molten-nvim)
    extraPython3Packages =
      ps: with ps; [
        jupyter-client # molten-nvim
      ];

    extraLuaPackages =
      ps: with ps; [
        magick # image.nvim
      ];
  };

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        indent_style = "space";
        indent_size = 4;
      };

      "*.{txt,md,nix,yml,yaml}".indent_size = 2;
    };
  };

  home = {
    file = {
      ".config/nvim".source = mkDotfilesSymlink "nvim";

      ".prettierrc.yaml".text = /* yaml */ ''
        tabWidth: 4
        singleQuote: true
        printWidth: 120
        overrides:
          - files:
              - '*.md'
              - '*.yml'
              - '*.yaml'
            options:
              tabWidth: 2
      '';

      ".ruff.toml".text = /* toml */ ''
        line-length = 120
      '';

      ".taplo.toml".text = /* toml */ ''
        [formatting]
        indent_string = "    " # match uv
        array_auto_collapse = false
      '';
    };

    packages = with pkgs; [
      ## conform.lua
      prettier
      shfmt
      stylua
      libxml2 # xmllint

      ## lspconfig.lua
      ast-grep
      biome
      lua-language-server
      nil
      nodePackages.bash-language-server
      pyright
      ruff
      taplo
      shellcheck
      vscode-langservers-extracted

      ## treesitter.lua
      tree-sitter

      ## typescript-tools.lua
      typescript

      ## vim-test
      pkgs.luajit.pkgs.busted
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  mise.tools = {
    ## lspconfig.lua
    "pipx:ty" = "latest";
  };
}
