# ~/.config/zsh/aliases.zsh — managed by chezmoi.

# Modern replacements with feature flags.
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first --icons=auto'
  alias l='eza -l --group-directories-first --icons=auto --git'
  alias ll='eza -la --group-directories-first --icons=auto --git'
  alias lt='eza -T --level=2 --icons=auto'
  alias tree='eza -T --icons=auto'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never --style=plain'
  alias bathelp='bat --plain --language=help'
  help() { "$@" --help 2>&1 | bathelp; }
fi

command -v rg   >/dev/null 2>&1 && alias grep='rg'
command -v fd   >/dev/null 2>&1 && alias find='fd'
command -v dust >/dev/null 2>&1 && alias du='dust'
command -v duf  >/dev/null 2>&1 && alias df='duf'
command -v procs >/dev/null 2>&1 && alias ps='procs'
command -v btop >/dev/null 2>&1 && alias top='btop'

# Git shortcuts.
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git pull --rebase --autostash'
alias gP='git push'
alias gco='git checkout'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'
alias lg='lazygit'

# Editor.
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# Common.
alias mkd='mkdir -p'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias path='echo -e ${PATH//:/\\n}'
alias reload='exec zsh -l'

# chezmoi quality of life.
alias cz='chezmoi'
alias czd='chezmoi diff'
alias cze='chezmoi edit'
alias cza='chezmoi apply -v'
alias czs='chezmoi update -v'
