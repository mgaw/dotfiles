# https://nix-community.github.io/home-manager/
# https://nix-community.github.io/home-manager/options.xhtml
# https://search.nixos.org/packages
# https://github.com/NixOS/nixpkgs
# https://nix.dev/manual/nix/latest/
# nix hash convert --to nix32 sha256-...

{ config, pkgs, ... }:

{
  imports = [
    ../cmux/home.nix
    ../ghostty/home.nix
    ../karabiner/home.nix
    ../nvim/home.nix
    ../zsh/home.nix
    ./claude.nix
    ./codex.nix
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
    ./usage.nix
    ./utils.nix
    ~/src/dotfiles/nix/home.local.nix
  ];

  home.packages = with pkgs; [
    bash-language-server
    chafa # cat images
    coreutils
    curl
    ffmpeg # convert video and audio
    gnupg
    imagemagick # convert images
    libxml2 # xmllint
    lua
    luajit.pkgs.busted
    moreutils # vidir
    nerd-fonts.ubuntu-mono
    nil
    nixfmt
    openssh
    pandoc
    perlPackages.AppSt # quick stats
    prettier
    qrencode
    sqlite
    tree
    vscode-langservers-extracted
    yubikey-manager
  ];

  homebrew.casks = [
    "alfred"
    "firefox"
    "netnewswire"
    "rectangle"
    "spotify"
    "tableplus"
  ];

  mise.tools = {
    ast-grep = "latest";
    biome = "latest";
    fd = "latest";
    hyperfine = "latest";
    jq = "latest";
    lua-language-server = "latest";
    miller = "latest";
    node = "latest";
    prek = "latest";
    python = "latest";
    ripgrep = "latest";
    ruff = "latest";
    shellcheck = "latest";
    shfmt = "latest";
    stylua = "latest";
    taplo = "latest";
    "aqua:numtide/treefmt" = "latest";
    ty = "latest";
    uv = "latest";
  };

  programs = {
    bash.enable = true;
  };

  home.sessionPath = [
    "${config.utils.dotfiles}/bin"
  ];

  xdg.configFile."uv/uv.toml".source = config.utils.toml.generate "uv.toml" {
    # https://docs.astral.sh/uv/reference/settings/#exclude-newer
    exclude-newer = "3 days";
  };

  home.file.".npmrc".source = config.utils.keyValue.generate "npmrc" {
    # https://docs.npmjs.com/cli/v11/commands/npm-install#min-release-age
    min-release-age = 3;
  };

  home.file.".yarnrc.yml".source = config.utils.yaml.generate "yarnrc.yml" {
    # https://yarnpkg.com/configuration/yarnrc#npmMinimalAgeGate
    npmMinimalAgeGate = "3d";
    enableTelemetry = 0;
  };

  home.file.".prettierrc.yaml".source = config.utils.yaml.generate "prettierrc.yaml" {
    tabWidth = 4;
    singleQuote = true;
    printWidth = 120;
    overrides = [
      {
        files = [
          "*.md"
          "*.yml"
          "*.yaml"
        ];
        options.tabWidth = 2;
      }
    ];
  };

  xdg.configFile."ruff/ruff.toml".source = config.utils.toml.generate "ruff.toml" {
    line-length = 120;
  };

  home.file.".taplo.toml".source = config.utils.toml.generate "taplo.toml" {
    formatting = {
      indent_string = "    "; # match uv
      array_auto_collapse = false;
    };
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
}
