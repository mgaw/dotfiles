function git_ps1() {
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
        echo " [$branch]"
    fi
}

# Allow $() in PS1
setopt PROMPT_SUBST

# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
PS1='%n@%m:%~$(git_ps1)$(kube_ps1)%(?.. %?)%# '
