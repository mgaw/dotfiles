{ pkgs, ... }:

let
  kube-ps1 = pkgs.fetchFromGitHub {
    owner = "jonmosco";
    repo = "kube-ps1";
    rev = "v0.9.0";
    sha256 = "0vxfdcg3wqy2hdchywzlpfh8y6ghn9d4vmcbw3q975p4y48ypjmg";
  };

in
{
  home.sessionVariables = {
    # https://github.com/jonmosco/kube-ps1#customization
    KUBE_PS1_ENABLED = "off";
    KUBE_PS1_PREFIX = " (";
    KUBE_PS1_SYMBOL_ENABLE = "false";
  };

  programs.zsh.initContent = ''
    source ${kube-ps1}/kube-ps1.sh
  '';
}
