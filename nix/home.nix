# https://nix-community.github.io/home-manager/
# https://nix-community.github.io/home-manager/options.xhtml
# https://search.nixos.org/packages
# https://github.com/NixOS/nixpkgs
# https://nix.dev/manual/nix/latest/
# nix hash convert --to nix32 sha256-...

{ pkgs, ... }:

{
  imports = [
    ../claude/home.nix
    ../ghostty/home.nix
    ../karabiner/home.nix
    ../nvim/home.nix
    ../zsh/home.nix
    ./darwin.nix
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./gopass.nix
    ./gpg-agent.nix
    ./history.nix
    ./hm.nix
    ./homebrew.nix
    ./kube-ps1.nix
    ./mise.nix
    ./utils.nix
    ~/src/dotfiles/nix/home.local.nix
  ];

  home = {
    packages = with pkgs; [
      chafa # cat images
      coreutils
      curl
      fd
      gnupg
      hyperfine
      moreutils # vidir
      openssh
      ripgrep
      tree
      yubikey-manager

      # font
      nerd-fonts.ubuntu-mono

      # development
      ast-grep
      libxml2 # xmllint
      taplo

      ## js
      biome
      nodejs
      prettier
      vscode-langservers-extracted

      ## lua
      lua
      lua-language-server
      luajit.pkgs.busted
      stylua

      ## python
      python3
      ruff

      ## nix
      nil
      nixfmt-tree

      ## sh
      nodePackages.bash-language-server
      shellcheck
      shfmt

      # av
      ffmpeg # convert video and audio
      imagemagick # convert images
      qrencode

      # data
      jq # json
      miller # csv, tsv, jsonl
      perlPackages.AppSt # quick stats
      sqlite

      # docs
      pandoc
      quarto
    ];
  };

  homebrew = {
    casks = [
      "alfred"
      "firefox"
      "istat-menus"
      "logi-options+"
      "netnewswire"
      "rectangle"
      "spotify"
      "tableplus"
      "yubico-authenticator"
    ];
  };

  mise.tools = {
    "npm:@vtsls/language-server" = "latest";
    "pipx:llm" = {
      version = "latest";
      uvx_args = "--with llm-mlx";
    };
    "pipx:ty" = "latest";
    uv = "latest";
  };

  programs = {
    bash = {
      enable = true;
    };
  };
}
