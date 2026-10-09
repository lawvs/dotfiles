# Agent skills

Select remote skills in `skills.json`; each source uses a `flake = false` input
from `flake.nix`. Add repository skills as `skills/<name>/SKILL.md`, with no registration.

Home Manager links skills into `~/.agents/skills` and `~/.claude/skills`.
Remote versions are pinned in `flake.lock`; invocation policies are preserved.
Plugin hooks and output styles are not installed.

Edit sources here, then [apply the configuration](../../README.md#update).
For Git-backed flakes, stage new files with `git add` before rebuilding.
