# Agent skills

Select upstream skills in `skills.json`, grouped by flake `input` and
`category`. Only names listed in `skills` are installed. Paths come from the
upstream `.claude-plugin/plugin.json`, or default to `skills/<name>`.
Only skill directories are installed, not plugin hooks or output styles.

Invocation policies come from upstream skills. Versions are pinned in
`flake.lock`; new sources need a flake input with `flake = false`.

## Local skills

Add each skill as `local/<name>/SKILL.md`. No registration is needed. Git-backed
flakes require new files to be staged with `git add`, not necessarily committed.

Edit skills here rather than changing the generated links or running
`npx skills update`.
