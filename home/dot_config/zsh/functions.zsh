# ~/.config/zsh/functions.zsh — managed by chezmoi.

# mkdir + cd.
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# Universal extractor.
extract() {
  local f="$1"
  [[ -z "$f" || ! -f "$f" ]] && { echo "extract: file not found: $f" >&2; return 1; }
  case "$f" in
    *.tar.bz2|*.tbz2) tar xjf  "$f" ;;
    *.tar.gz|*.tgz)   tar xzf  "$f" ;;
    *.tar.xz|*.txz)   tar xJf  "$f" ;;
    *.tar.zst)        tar --zstd -xf "$f" ;;
    *.tar)            tar xf   "$f" ;;
    *.bz2)            bunzip2  "$f" ;;
    *.gz)             gunzip   "$f" ;;
    *.zip)            unzip    "$f" ;;
    *.7z)             7z x     "$f" ;;
    *.rar)            unrar x  "$f" ;;
    *)                echo "extract: unknown extension: $f" >&2; return 1 ;;
  esac
}

# Quick HTTP server in current dir.
serve() {
  local port="${1:-8000}"
  command -v python3 >/dev/null 2>&1 \
    && python3 -m http.server "$port" \
    || python -m SimpleHTTPServer "$port"
}

# Git: fzf-driven branch switch.
gcb() {
  local branch
  branch=$(git for-each-ref --format='%(refname:short)' refs/heads | fzf --height=40% --reverse) || return
  git checkout "$branch"
}

# Project root teleport (best-effort: git root, falls back to cwd).
proot() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || root="$PWD"
  cd "$root"
}

# Show 256 colour palette in the current terminal.
colors() {
  for c in {0..255}; do
    printf '\033[48;5;%sm %3s ' "$c" "$c"
    (( (c+1) % 16 == 0 )) && printf '\033[0m\n'
  done
  printf '\033[0m\n'
}
