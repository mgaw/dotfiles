alias gn='git number'
alias gs='gn -s'

alias rn='gn -c rm'
vin() { gn -c nvim "$@"; }

# show
alias gw='git show'
alias gwu='gw @{upstream}'
alias gws='gw --stat'
gwc() { echo -n "$(git rev-parse HEAD)" | pbcopy; }
gwf() { # git show files
    git diff-tree --no-commit-id --name-only -r "${1:-HEAD}"
}

# branch
alias gb='git branch'

# reset
alias gr='gn reset'
alias grhu='gr --hard @{upstream}'

gco() {
    if [[ "$1" =~ '^(https?|git)://' || "$1" =~ '^git@' ]]; then
        gcopr "$@"
    elif [[ "$@" == *"-b"* && "$@" != *"--help"* ]]; then
        local base=$(git rev-parse --abbrev-ref HEAD)
        git checkout "$@"
        if [[ "$base" != "HEAD" ]]; then
            git set-base "$base"
        fi
    elif [[ -n "$*" ]]; then
        gn checkout "$@"
    else
        git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads | fzf | xargs git checkout
    fi
}

# git checkout remote
gcor() {
    git for-each-ref --format='%(refname:short)' refs/remotes/origin | sed s:origin/:: | fzf | xargs git checkout
}

# Git CheckOut Pull Request
gcopr() {
    # The PR URL, e.g., https://github.com/owner/repo/pull/33
    pr_url="$1"

    repo=$(echo "$pr_url" | awk -F'/' '{ print $5 }')
    pr_number=$(echo "$pr_url" | awk -F'/' '{ print $7 }')

    repo_path="$HOME/src/$repo"
    if [ ! -d "$repo_path" ]; then
        echo "Repository directory not found: $repo_path"
        return 1
    fi

    echo "Changing directory to: $repo_path"
    cd "$repo_path" || {
        echo "Error: Cannot change directory to $repo_path"
        return 1
    }

    echo "Checking out pull request #$pr_number..."
    gh pr checkout "$pr_number"
}

# diff
alias gd='gn diff'
alias gdc='gd --cached'
alias gds='gd --stat'
alias gdcs='gdc --stat'
alias gdu='gd @{upstream}'
alias gduh='gd @{upstream} HEAD'
alias gdsu='gds @{upstream}'
alias gdmb='gd --merge-base'
gdf() {
    local branch=$(git rev-parse --abbrev-ref HEAD)
    gd origin/"$branch"'@{1}' origin/"$branch"
}

# To use while resolving merge conflicts
gd-us() { gd "$(git merge-base MERGE_HEAD HEAD)"..HEAD -- "$@"; }
gd-them() { gd "$(git merge-base MERGE_HEAD HEAD)"..MERGE_HEAD -- "$@"; }

# stash
alias gst='gn stash'
alias gsta='gst apply'

# add
alias ga='gn add'
alias gap='ga -p'
alias gaa='git add --all'

# commit
gc() { git commit --verbose --allow-empty "$@"; }
gca() { gc --amend "$@"; }

# push, fetch, pull
gp() { git push "$@"; }
gf() { git fetch "$@"; }
gpl() {
    git fetch
    git diff "$(git merge-base HEAD '@{upstream}')" '@{upstream}'
    git rebase '@{upstream}'
}
gpp() { gpl && gp; }
gpsu() { gp --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)"; }

# add and commit
gac() { ga "$@" && gc; }
gaca() { ga "$@" && gca; }
gaac() { gaa && gc "$@"; }
gaaca() { gaa && gca "$@"; }
c() { gaac; }
a() { gaaca --no-edit; }
get_commit() {
    gl | fzf --ansi | sed 's/\x1b\[[0-9;]*m//g' | grep -oE '\b[0-9a-f]{7,}\b' | head -1
}
gcf() {
    git commit --fixup "$(get_commit)" && git rebase --interactive --autosquash
}
cf() {
    git add --all && gcf
}
gacf() {
    ga "$@" && gcf
}

# merge
alias gm='git merge'
alias gmom='git merge origin/master'
alias gmu='git merge @{upstream}'

# rebase
alias grb='git rebase'
alias grbi='git rebase --interactive'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'

# cherry-pick
alias gcp='git cherry-pick'
alias gcpnc='git cherry-pick --no-commit'
alias gcpc='git cherry-pick --continue'
alias gcpa='git cherry-pick --abort'

# log
gl() {
    local commit_hash='%C(yellow)%h'
    local date='%C(green)%cr'
    local ref='%C(auto)%d'
    local author='%C(white)%<(18,trunc)%an%Creset' # reset bold
    local message='%Creset%s'
    git log --color --pretty="$author $commit_hash$ref $message" --abbrev-commit --first-parent "$@"
}
glg() { gl --graph "$@"; }
alias gla='gl --all'
alias glga='glg --all'

# base
gdmbob() {
    git diff --merge-base origin/"$(git get-base)"
}
grbb() {
    git rebase "$(git get-base)"
}
grbob() {
    git rebase origin/"$(git get-base)"
}
grbib() {
    git rebase --interactive "$(git get-base)"
}
grbiob() {
    git rebase --interactive origin/"$(git get-base)"
}
gmb() {
    git merge "$(git get-base)"
}
gmob() {
    git merge origin/"$(git get-base)"
}
ghpr() {
    gh pr create -B "$(git get-base)" -fw "$@"
}
