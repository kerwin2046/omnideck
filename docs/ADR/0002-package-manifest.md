# ADR 0002 — Single-source-of-truth Package Manifest

- **Status**: Accepted
- **Date**: 2026-06-15

## Context

A workstation typically tracks 50+ packages across `brew`, `brew --cask`,
`apt`, third-party apt repos, GitHub releases, and `cargo install`. Without
discipline, install steps scatter across:

- ad-hoc Homebrew Brewfiles
- inline `apt-get install` commands in scripts
- README "remember to install X" notes
- per-machine drift after manual installs

The goal: a single declarative file that describes what a workstation should
have, with platform-appropriate channels per package, and an installer that
reads that file.

## Decision

`home/.chezmoidata/packages.yaml` is the only place packages get declared.
Categories (`core`, `cli_modern`, `shell`, `git`, `runtime`, `container`,
`fonts`, `gui_mac`, `gui_linux`) each list packages per channel:

```yaml
cli_modern:
  brew:           [ripgrep, fd, fzf, ...]
  apt:            [ripgrep, fd-find, fzf, ...]
  cargo_fallback: [eza, zoxide, ...]
  github_release: []
```

The lifecycle script
[`home/.chezmoiscripts/run_onchange_before_10-install-packages.sh.tmpl`](../../home/.chezmoiscripts/run_onchange_before_10-install-packages.sh.tmpl)
reads these arrays at template-render time, branches on `.chezmoi.os`, and
emits the platform-appropriate install commands. Because the rendered shell
embeds the package names, any edit to `packages.yaml` changes the rendered
hash and chezmoi re-runs the script on next `apply`.

## Consequences

Positive

- Adding a tool everywhere requires editing exactly one file.
- The current state of "what should be installed" is human-readable in a single
  YAML.
- Per-OS overrides (e.g. `cargo_fallback` for tools missing in Debian repos)
  are colocated with the package list, not buried in scripts.

Negative

- The install-script template is the most complex piece of templating in the
  repo; whitespace / variable computation has to be careful.
- We accept the tradeoff that some Debian packages have different names than
  their Homebrew counterparts (`fd` vs `fd-find`); a small post-install symlink
  step in the rendered script papers over this.
