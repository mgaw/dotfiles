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

  home.packages = with pkgs; [
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
    nixfmt-tree
    openssh
    pandoc
    perlPackages.AppSt # quick stats
    python3
    qrencode
    quarto
    sqlite
    tree
    yubikey-manager
  ];

  homebrew.casks = [
    "alfred"
    "firefox"
    "logi-options+"
    "netnewswire"
    "rectangle"
    "spotify"
    "tableplus"
  ];

  mise.tools = {
    "npm:@vtsls/language-server" = "latest";
    "npm:bash-language-server" = "latest";
    "npm:prettier" = "latest";
    "npm:vscode-langservers-extracted" = "latest";
    "pipx:llm" = "latest";
    ast-grep = "latest";
    biome = "latest";
    fd = "latest";
    hyperfine = "latest";
    jq = "latest";
    lua-language-server = "latest";
    miller = "latest";
    node = "latest";
    ripgrep = "latest";
    ruff = "latest";
    shellcheck = "latest";
    shfmt = "latest";
    stylua = "latest";
    taplo = "latest";
    ty = "latest";
    uv = "latest";
  };

  programs = {
    bash.enable = true;
  };
}
