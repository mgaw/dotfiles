# ctrl-x ctrl-e opens current line in vim
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Ideally, ghostty config would map alt-f/b to alt-right/left.
# alt-f
bindkey "ƒ" forward-word
# alt-b
bindkey "∫" backward-word
