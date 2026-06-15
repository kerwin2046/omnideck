# ADR 0001 — Bootstrap Tooling

- **Status**: Accepted
- **Date**: 2026-06-15
- **Deciders**: Project owner (@kerwin2046)

## Context

Omnideck needs to take a brand-new machine to a fully-loaded developer
workstation in one command. The decision is: which technology owns the
"render configuration + drive installation" layer?

Candidates considered:

1. **Pure shell scripts** — zero dependencies, transparent, but state
   management, idempotency, and per-host templating quickly become a mess once
   the surface area exceeds ~10 components.
2. **Ansible** — declarative, battle-tested, idempotent. Requires Python at
   runtime; YAML is verbose; cross-platform handling (`brew` vs `apt`) ends up
   in `when:` clauses everywhere.
3. **chezmoi + a thin bootstrap shell** — a single static Go binary; first-class
   templating with Sprig functions; built-in lifecycle scripts
   (`run_once_*` / `run_onchange_*` / `run_*_before_*` / `run_*_after_*`);
   per-host data via prompts; popular in the modern dotfiles community.
4. **Nix + home-manager + nix-darwin** — most reproducible; flakes describe
   every machine declaratively. Steep learning curve, slow iteration, painful
   debugging, weak GUI app coverage on Linux.

## Decision

**Use chezmoi as the primary tool** plus a single `bootstrap.sh` to install
chezmoi itself.

- `bootstrap.sh` detects macOS / Debian, installs Homebrew or refreshes apt,
  installs chezmoi, then `exec`s `chezmoi init --apply kerwin2046/omnideck`.
- All package installation, dotfile templating, and platform tweaks live in
  `home/.chezmoiscripts/` and are driven by data in
  `home/.chezmoidata/packages.yaml`.
- Templates can branch on `.chezmoi.os`, prompt-derived booleans, and per-host
  identity data, eliminating the need for OS-specific subtrees.

## Consequences

Positive

- One self-contained binary in the loop, no Python or Ruby dependency.
- Editing `home/.chezmoidata/packages.yaml` is the single edit needed to add a
  package across all hosts; the `run_onchange_*` hash mechanism re-installs
  automatically.
- Templates are diffable; `chezmoi diff` previews every change before apply.
- Fast iteration: `chezmoi apply` runs in seconds.

Negative

- Sprig template syntax + chezmoi-specific data structure has its own learning
  curve.
- Whitespace handling in Go templates (`{{- -}}`) is finicky and easy to get
  wrong; we mitigate by a CI smoke test that renders every template and runs
  `bash -n` / `zsh -n` on the output.
- chezmoi's "private" attribute solves the .ssh permission problem but secrets
  encryption (age, 1Password) is a follow-on, not in v1.

## Out of scope (deliberate)

- Windows / WSL — limits the supported branches, halves the test matrix.
- Arch / Fedora — apt is the only Linux package source until further notice.
- Multi-user shared dotfiles — single-owner repo for now.
