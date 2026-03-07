# https://nix-community.github.io/home-manager/
# https://nix-community.github.io/home-manager/options.xhtml
# https://search.nixos.org/packages
# https://github.com/NixOS/nixpkgs
# https://nix.dev/manual/nix/latest/
# nix hash convert --to nix32 sha256-...

{
  config,
  pkgs,
  username,
  ...
}:

let
  inherit (import ./utils.nix config) mkDotfilesSymlink;
in

{
  imports = [
    ../nvim/home.nix
    ../zsh/home.nix
    ./darwin.nix
    ./git.nix
    ./gopass.nix
    ./history.nix
    ./hm.nix
    ./homebrew.nix
    ./kube-ps1.nix
    ./mise.nix
    ~/src/dotfiles/nix/home.local.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";

    file = {
      ".claude/settings.json".source = mkDotfilesSymlink "claude/settings.json";
      ".config/ghostty/config".source = mkDotfilesSymlink "ghostty/config";
      ".config/karabiner".source = mkDotfilesSymlink "karabiner";
      ".hushlogin".text = ""; # suppress "Last login" message in new terminal tabs
      # Avoid "installMethod is native, but claude command not found at ~/.local/bin/claude"
      ".local/bin/claude".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/mise/shims/claude";
    };

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

    sessionVariables = {
      LC_ALL = "en_US.UTF-8";
      SSH_AUTH_SOCK = ""; # allow services.gpg-agent to set it
    };
  };

  homebrew = {
    casks = [
      "alfred"
      "firefox"
      "ghostty"
      "istat-menus"
      "karabiner-elements"
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
    claude = "latest";
    uv = "latest";
  };

  programs = {
    bash = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      silent = true;
      config = {
        warn_timeout = "0s";
        hide_env_diff = true;
      };
      nix-direnv.enable = true;
      stdlib = builtins.readFile ./run_if_changed.sh;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--reverse"
      ];
      fileWidgetCommand = "${pkgs.fd}/bin/fd --hidden --exclude .git"; # apply .gitignore
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry_mac;
    };
  };
}
