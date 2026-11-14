# VictoriaMetrics internal skills

Claude Code skills used internally by the VictoriaMetrics team. Each top-level directory with a `SKILL.md` is one skill:

- [`vm-changelog-review`](vm-changelog-review/SKILL.md): review changelog entries or write a new one (`docs/**/CHANGELOG*.md`).

## Installation

Clone the repo and symlink the skills, so `git pull` keeps them up to date.

### Using the script

```sh
# All projects (user-level): ~/.claude/skills
./symlink.sh

# A single repository: <repo>/.claude/skills
./symlink.sh ~/path/to/VictoriaMetrics/.claude/skills
```

The script links every skill directory into the target dir (creating it if needed), updates existing symlinks, and skips anything that already exists and isn't a symlink.

### Manually

```sh
# User-level
mkdir -p ~/.claude/skills
ln -s "$(pwd)/vm-changelog-review" ~/.claude/skills/vm-changelog-review

# Repository-level
mkdir -p ~/path/to/VictoriaMetrics/.claude/skills
ln -s "$(pwd)/vm-changelog-review" ~/path/to/VictoriaMetrics/.claude/skills/vm-changelog-review
```

Restart Claude Code (or start a new session) to pick up new skills.
