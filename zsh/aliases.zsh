src() { cd ~/src; }
src2() { cd "$HOME"/nobackup/src; }
df() { cd ~/src/dotfiles; }
dff() { (df && nvim -c OpenFile); }
dfu() {
    mise self-update --yes
    brew update
    nix flake update --flake ~/src/dotfiles --commit-lock-file
    home-manager switch --flake ~/src/dotfiles --impure
    nvim -c "lua require('lazy').sync({ wait = true })"
    git -C ~/src/dotfiles commit -m 'nvim/lazy-lock.json: Update' -- nvim/lazy-lock.json
    mise up
    brew upgrade
    softwareupdate --install --list
}

dfa() {
    home-manager switch --flake ~/src/dotfiles --impure
    nvim --headless -c "lua require('lazy').restore({ wait = true })" -c quit >/dev/null
}

vim() {
    if [[ -z "$1" ]]; then
        nvim -c OpenFile
    else
        nvim "$@"
    fi
}

vis() { # VIm Status
    {
        # tracked files different from HEAD (staged + unstaged)
        git diff --name-only -z HEAD

        # untracked files (not ignored)
        git ls-files -o --exclude-standard -z
    } | sort -zu | xargs -0 nvim
}

vic() { # VIm Conflicts
    git diff --name-only -z --diff-filter=U | xargs -0 nvim
}

vir() { # VIm Review
    nvim -c Review
}

alias vi=nvim

alias l='ls --classify --color'
alias ll='ls -al --human-readable --classify --color'
mk() { mkdir -pv "$1" && cd "$1"; }

alias o='open .'

TODAY=$(date '+%Y-%m-%d')

days="$HOME/days"
today() {
    local suffix=$1
    if [[ -z "$suffix" ]]; then
        mk "$days/$TODAY"
    else
        mk "$days/$TODAY-$suffix"
    fi
}

mvt() {
    local dir=$days/$TODAY
    mkdir -p "$dir"
    git number -c mv "$@" "$dir"
}

v() { nvim ~/notes.txt; }

gdt() {
    local name=$1
    dir=$days/$TODAY
    mkdir -p "$dir"
    git diff >"$dir/$name.diff"
}

t() {
    local suffix=$1
    if [[ -z "$suffix" ]]; then
        vim "$days/$TODAY.md"
    else
        vim "$days/$TODAY-$suffix.md"
    fi
}

alias diff='git diff --no-index'

alias pw='gopass show --noparsing'
alias pc='gopass show -c'
alias pe='gopass edit --create'
alias pg='gopass generate --symbols'
alias pgns='gopass generate' # "no symbols"

alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpf='kubectl get pod --no-headers -o custom-columns=":metadata.name" | fzf'
alias kd='kubectl describe'
alias ke='kubectl exec -it'
alias kl='kubectl logs'
kns() {
    local namespace=$1
    if [ -z "$namespace" ]; then
        namespace=$(kubectl get namespace --no-headers -o custom-columns=":metadata.name" | fzf)
    fi
    kubectl config set-context --current --namespace="$namespace"
}

alias cc=claude

alias ag="rg --smart-case --sort-files --hidden --glob '!.git/*'"

# search and replace
sr() {
    local old="$1"
    local new="$2"
    local sep="${3:-#}"
    rg -0 --files-with-matches --hidden --glob '!.git/*' -- "$old" |
        xargs -0 perl -i -pe "s${sep}${old}${sep}${new}${sep}g"
}
