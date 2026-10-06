# Personal agent skills

Put each personal skill in its own directory here, with a `SKILL.md` file. Home
Manager links each skill directory into both `~/.agents/skills` (Codex) and
`~/.claude/skills` (Claude Code). Commit new skills before building this flake.

Matt Pocock's published skills come from the `skills` list in his pinned
`.claude-plugin/plugin.json`. When that list grows or its paths change, update
the `matt-skills` input with `nix flake update matt-skills`, review the lock-file
diff, then rebuild. Missing or duplicate skills stop evaluation. Nix owns these
skill links; do not update them with `npx skills update`.
