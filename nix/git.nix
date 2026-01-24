{ pkgs, ... }:

{
  home.packages = [
    (pkgs.callPackage ./git-number.nix { })
  ];

  programs.git = {
    enable = true;
    settings = {
      advice.detachedHead = false;
      advice.skippedCherryPicks = false;
      branch.sort = "-committerdate";
      color.ui = true;
      column.ui = "auto";
      commit.verbose = true;
      core.commentChar = ";";
      core.pager = "${pkgs.less}/bin/less -+S --LONG-PROMPT";
      core.quotepath = false;
      diff.algorithm = "patience";
      diff.colorMoved = "default";
      diff.colorMovedWS = "allow-indentation-change";
      diff.gpg.binary = true;
      diff.gpg.textconv = "${pkgs.gnupg}/bin/gpg --no-tty --decrypt";
      diff.renameLimit = 1500;
      fetch.prune = true;
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3";
      pull.rebase = true;
      rebase.autoStash = true;

      alias.get-base = ''!git config get branch."$(git rev-parse --abbrev-ref HEAD)".base'';
      alias.set-base = ''!f() { git config set branch."$(git rev-parse --abbrev-ref HEAD)".base "$1"; }; f'';
    };
    ignores = [
      ".DS_STORE"
      "/.direnv"
      "/.nvim.lua"
    ];
  };

  programs.gh = {
    enable = true;
    settings = {
      pager = "${pkgs.less}/bin/less -R";
    };
  };

  programs.delta = {
    enable = true;
    options = {
      color-only = true;
    };
  };
}
