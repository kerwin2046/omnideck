#!/usr/bin/env bash
# Omnideck health check. Verifies that core tooling is on PATH and that
# critical config files have been deployed.

set -uo pipefail

ok()   { printf '\033[1;32m✓\033[0m %s\n' "$*"; }
miss() { printf '\033[1;31m✗\033[0m %s\n' "$*"; FAIL=$((FAIL+1)); }
warn() { printf '\033[1;33m!\033[0m %s\n' "$*"; }
sect() { printf '\n\033[1;36m── %s ──\033[0m\n' "$*"; }

FAIL=0

sect "Core tooling"
for cmd in chezmoi git zsh nvim curl; do
  if command -v "$cmd" >/dev/null 2>&1; then
    ok  "$cmd → $(command -v "$cmd")"
  else
    miss "$cmd not on PATH"
  fi
done

sect "Modern CLI"
for cmd in rg fd fzf bat eza zoxide atuin delta jq starship lazygit gh mise; do
  if command -v "$cmd" >/dev/null 2>&1; then
    ok  "$cmd"
  else
    warn "$cmd missing"
  fi
done

sect "Config files"
for path in \
  "$HOME/.zshrc" \
  "$HOME/.zshenv" \
  "$HOME/.config/nvim/init.lua" \
  "$HOME/.config/starship.toml" \
  "$HOME/.config/kitty/kitty.conf" \
  "$HOME/.config/git/config" \
  "$HOME/.config/lazygit/config.yml" \
  "$HOME/.config/mise/config.toml" \
  "$HOME/.config/atuin/config.toml" \
; do
  if [ -e "$path" ]; then
    ok  "$path"
  else
    miss "$path missing"
  fi
done

sect "Default shell"
current_shell="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}' || echo "$SHELL")"
case "$current_shell" in
  */zsh) ok "default shell is zsh ($current_shell)" ;;
  *)     warn "default shell is $current_shell (expected zsh)" ;;
esac

sect "Font"
if command -v fc-list >/dev/null 2>&1; then
  if fc-list | grep -qi "JetBrainsMono"; then
    ok "JetBrainsMono Nerd Font installed"
  else
    miss "JetBrainsMono Nerd Font not detected"
  fi
elif [ -d "$HOME/Library/Fonts" ]; then
  if ls "$HOME/Library/Fonts" 2>/dev/null | grep -qi "JetBrainsMono"; then
    ok "JetBrainsMono Nerd Font installed"
  else
    warn "fc-list missing; cannot verify font on macOS"
  fi
fi

sect "Result"
if [ "$FAIL" -eq 0 ]; then
  printf '\033[1;32mAll critical checks passed.\033[0m\n'
  exit 0
else
  printf '\033[1;31m%d critical check(s) failed.\033[0m\n' "$FAIL"
  exit 1
fi
