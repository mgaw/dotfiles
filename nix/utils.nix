config:

rec {
  # `mkOutOfStoreSymlink ./path` does not work in flakes
  # https://github.com/nix-community/home-manager/issues/2085
  dotfiles = "${config.home.homeDirectory}/src/dotfiles";
  mkDotfilesSymlink = relativePath: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${relativePath}";
}
