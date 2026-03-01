# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Automated macOS developer environment setup using a two-phase approach:

1. **`setup.sh`** — Bootstrap script run on a fresh machine. Installs Xcode CLI tools, Homebrew, Git, and Ansible, then prompts the user to clone this repo and proceed to Ansible.
2. **`ansible/playbook.yaml`** — Main playbook that idempotently installs and configures the full dev environment via Homebrew.
3. **`ansible/setupGitWork.yaml`** — Separate playbook for configuring additional GitHub/Git accounts with isolated SSH keys and per-directory gitconfig includes.

## Running the playbooks

Bootstrap a new machine:
```bash
bash setup.sh
```

Run the main dev environment playbook:
```bash
ansible-playbook ansible/playbook.yaml
```

Add a new Git/GitHub account (multi-account SSH setup):
```bash
ansible-playbook ansible/setupGitWork.yaml
```

## Architecture notes

### `playbook.yaml` structure

Tasks are ordered by dependency (shell → tools → runtimes → work-specific):
- Shell setup: zsh, Oh My Zsh, autosuggestions, fzf, zoxide, yazi
- CLI tools: gh, act, cfn-lint, oci-cli, terraform, awscli, jq, freeze, ollama, ggshield
- Window management: yabai + skhd (via `koekeishiya/formulae` tap)
- Runtimes: Volta → Node.js, bun (via `oven-sh/bun` tap), uv (Python), Rust, Go
- Apps (homebrew casks): VSCode, Ghostty, Slack, Chrome, Firefox, Docker, Obsidian, etc.
- Work-specific: aws-azure-login (npm global), AWS credentials scaffolding
- Claude Code: installed via homebrew, configured with a custom API base URL and model

Config files are only created when they don't already exist (idempotent via `stat` + `when: not X.stat.exists`). Shell additions use `lineinfile` (for single lines) or `blockinfile` with named markers (for multi-line blocks) to remain idempotent.

### `setupGitWork.yaml` — multi-account Git

Prompts for: account name, email, hostname, work directory, and a unique identifier.

Key design: `ssh_host` is computed as:
- `github.com` → `github.com-<unique_identifier>` (alias, since public GitHub requires a host alias per account)
- Any other host → used as-is (enterprise GitHub hosts are unique per account)

This creates:
- `~/.ssh/id_<unique_identifier>` — dedicated SSH key
- `~/.ssh/config` entry pointing the `ssh_host` alias to the real hostname
- `~/.gitconfig-<unique_identifier>` — per-account git user config, with a `[url]` insteadOf rewrite for github.com accounts
- `~/.gitconfig` `[includeIf "gitdir:<work_directory>/"]` block to activate the config per directory

### Known quirks

- VSCode extension auto-install is commented out (manual install preferred; the commented list serves as a reference).
- `aws-azure-login` is work-specific and depends on both the AWS CLI and Volta/Node being set up first.
- After running the Claude Code setup task, you must manually add your auth token to `~/.claude/settings.json`.
