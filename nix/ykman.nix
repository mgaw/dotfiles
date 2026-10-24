{ pkgs, ... }:

{
  home.packages = [
    pkgs.yubikey-manager
  ];

  programs.zsh.shellAliases.yoa = /* zsh */ "ykman oath accounts add --touch";

  programs.zsh.siteFunctions.yoc = /* zsh */ ''
    local entry=$(ykman oath accounts list | fzf --query="$1" --select-1)
    echo "Using entry $entry"
    local code=$(ykman oath accounts code --single "$entry")
    if test -n "$code"; then
      pbcopy <<<"$code"
      echo "Copied code $code to clipboard."
    fi
  '';
}
