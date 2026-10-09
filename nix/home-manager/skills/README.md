# Agent skills

Select upstream skills in `../skills.json`, grouped by flake `input` and
`category`. Only names listed in `skills` are installed. Paths come from the
upstream `.claude-plugin/plugin.json`, or default to `skills/<name>`.

Add names to a source's optional `manualOnly` list to disable implicit Codex
invocation while preserving its other metadata. Other skills keep the upstream
policy. Versions are pinned in `flake.lock`; new sources need a flake input
with `flake = false`.

## Personal skills

Add each skill as `<name>/SKILL.md`. No registration is needed. Commit new files
before rebuilding: Git-backed flakes ignore untracked files.

Edit skills here rather than changing the generated links or running
`npx skills update`.
