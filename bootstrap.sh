#!/usr/bin/env sh
# Omnideck bootstrap. Pipe-into-sh entrypoint.
#
#   curl -fsSL https://raw.githubusercontent.com/kerwin2046/omnideck/main/bootstrap.sh | sh
#
# Detects the OS, installs a package manager + chezmoi, then hands off to
# `chezmoi init --apply` which executes the lifecycle scripts under
# home/.chezmoiscripts/ to install everything else.

set -eu

OMNIDECK_REPO="${OMNIDECK_REPO:-kerwin2046/omnideck}"
OMNIDECK_BRANCH="${OMNIDECK_BRANCH:-main}"

log()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx\033[0m  %s\n' "$*" >&2; exit 1; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

detect_os() {
  case "$(uname -s)" in
    Darwin) echo darwin ;;
    Linux)
      if [ -r /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        case "${ID_LIKE:-$ID}" in
          *debian*|*ubuntu*) echo debian ;;
          *) die "unsupported Linux distro: ID=${ID:-?} ID_LIKE=${ID_LIKE:-?} (Omnideck supports Debian-family only)" ;;
        esac
      else
        die "/etc/os-release missing; cannot detect Linux distro"
      fi
      ;;
    *) die "unsupported OS: $(uname -s)" ;;
  esac
}

ensure_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    return 0
  fi
  log "Installing Xcode Command Line Tools (a GUI prompt may appear)..."
  xcode-select --install || true
  until xcode-select -p >/dev/null 2>&1; do
    sleep 5
  done
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

ensure_apt_basics() {
  log "Refreshing apt and installing base build tools..."
  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential ca-certificates curl file git gnupg pkg-config procps unzip
}

ensure_chezmoi() {
  if command -v chezmoi >/dev/null 2>&1; then
    return 0
  fi
  log "Installing chezmoi..."
  case "$1" in
    darwin)
      brew install chezmoi
      ;;
    debian)
      sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
      export PATH="$HOME/.local/bin:$PATH"
      ;;
  esac
}

main() {
  require_cmd uname
  require_cmd curl

  os="$(detect_os)"
  log "Detected OS: $os"

  if [ "${OMNIDECK_DRY_RUN:-0}" = "1" ]; then
    log "OMNIDECK_DRY_RUN=1: would install package manager + chezmoi for $os"
    log "OMNIDECK_DRY_RUN=1: would run chezmoi init --apply $OMNIDECK_REPO"
    log "OMNIDECK_DRY_RUN=1: exiting without changes"
    return 0
  fi

  case "$os" in
    darwin)
      ensure_xcode_clt
      ensure_homebrew
      ;;
    debian)
      ensure_apt_basics
      ;;
  esac

  ensure_chezmoi "$os"

  log "Running chezmoi init --apply $OMNIDECK_REPO (branch: $OMNIDECK_BRANCH)"
  exec chezmoi init --apply --branch "$OMNIDECK_BRANCH" "$OMNIDECK_REPO"
}

main "$@"
