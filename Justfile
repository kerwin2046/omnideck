# Omnideck — local commands. Run `just` (or `just --list`) for the menu.

set shell := ["bash", "-cu"]

# Default target: show health.
default: doctor

# Diagnose: verify the workstation is healthy.
doctor:
    @./scripts/doctor.sh

# Pull the latest dotfiles from origin and apply locally.
sync:
    chezmoi update -v

# Apply pending changes from the local source state to ~.
apply:
    chezmoi apply -v

# Preview changes without applying.
diff:
    chezmoi diff

# Open chezmoi source in $EDITOR.
edit *args:
    chezmoi edit {{args}}

# Reinstall packages (re-run the install script regardless of hash).
reinstall-packages:
    chezmoi state delete-bucket --bucket=scriptState || true
    chezmoi apply -v

# Update Neovim plugins headlessly.
nvim-update:
    nvim --headless "+Lazy! sync" +qa

# Lint shell scripts and templates (requires shellcheck).
lint:
    shellcheck bootstrap.sh scripts/*.sh
    @echo "(template syntax is checked by 'just smoke')"

# Render every chezmoi template against synthetic linux + darwin data
# and bash/zsh-syntax-check the rendered output.
smoke:
    @./scripts/smoke.sh

# Convenience: re-deploy everything from a clean state on this machine.
re-init:
    chezmoi init --apply --source ~/.local/share/chezmoi
