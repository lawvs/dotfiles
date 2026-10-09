# Agent skills

`skills.json` follows [antfu's source format](https://github.com/antfu/skills-pack/blob/main/meta.ts):
an array of `source`, `category`, and optional `skills` (omitted means all).
Sources use `owner/repo[/subpath]`; map each repo to a non-flake input in `default.nix`.
Add repository skills as `skills/<name>/SKILL.md`, with no registration.

Home Manager links skills into `~/.agents/skills` and `~/.claude/skills`.
Remote versions are pinned in `flake.lock`; invocation policies are preserved.
Plugin hooks and output styles are not installed.

Edit sources here, then [apply the configuration](../../README.md#update).
For Git-backed flakes, stage new files with `git add` before rebuilding.
