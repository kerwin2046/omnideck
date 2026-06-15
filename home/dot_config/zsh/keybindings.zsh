# ~/.config/zsh/keybindings.zsh — managed by chezmoi.

# Use emacs-style line editing (default), but enable a few power features.
bindkey -e

# History incremental search bound to ctrl-r is provided by atuin; if atuin is
# not installed, fall back to the built-in widget.
if ! command -v atuin >/dev/null 2>&1; then
  bindkey '^R' history-incremental-search-backward
fi

# Word-wise navigation by alt-arrows on terminals that send escape sequences.
bindkey '\e[1;3D' backward-word    # alt-left
bindkey '\e[1;3C' forward-word     # alt-right

# Edit current command line in $EDITOR with ctrl-x ctrl-e.
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
