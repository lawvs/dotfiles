# Agent skills

`skills.json` mirrors the `skills` array in [antfu's package.json](https://github.com/antfu/skills-pack/blob/main/package.json):
source strings select all skills; objects use `source` and optional `skills`.
Omitted or empty `skills` means all. No `category` metadata is needed.
Sources use `owner/repo[/subpath]`; map each repo to a non-flake input in `default.nix`.
Add repository skills as `skills/<name>/SKILL.md`, with no registration.

Home Manager links skills into `~/.agents/skills` and `~/.claude/skills`.
Remote versions are pinned in `flake.lock`; invocation policies are preserved.
Plugin hooks and output styles are not installed.

Edit sources here, then [apply the configuration](../../README.md#update).
For Git-backed flakes, stage new files with `git add` before rebuilding.
