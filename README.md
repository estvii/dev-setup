# dev-setup

Personal macOS setup automation for getting a new laptop ready quickly.

## First time setup

On a brand new machine, run the bootstrap script first. This installs Xcode CLI tools, Homebrew, Git, and Ansible:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/estvii/dev-setup/main/setup.sh)
```

Or if you've already cloned the repo:

```bash
bash setup.sh
```

## Install everything

Once the bootstrap is done, run the main Ansible playbook:

```bash
ansible-playbook ansible/playbook.yaml
```

You'll be prompted for your sudo password. The playbook is idempotent — safe to re-run.

After it completes, follow any prompts in the output (e.g. adding your auth token to `~/.claude/settings.json`).

## Adding a Git account

To configure an additional GitHub or enterprise Git account with its own SSH key and gitconfig:

```bash
ansible-playbook ansible/setupGitWork.yaml
```

You'll be prompted for:
- Account name and email
- Hostname (e.g. `github.com` or `adc.github.trendmicro.com`)
- The local directory where that account's repos will live
- A unique identifier (e.g. `personal`, `work`)

The playbook will print the public SSH key at the end — add it to the relevant GitHub account before cloning repos.
