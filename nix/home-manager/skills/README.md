# Personal agent skills

Put each personal skill in its own directory here, with a `SKILL.md` file. Home
Manager links each skill directory into both `~/.agents/skills` (Codex) and
`~/.claude/skills` (Claude Code). Commit new skills before building this flake.

Matt Pocock's selected upstream skill names are listed in `../agent-skills.nix`
and versioned by the `matt-skills` entry in `flake.lock`. The module searches
the pinned repository recursively for each selected `SKILL.md`, so upstream
directory moves do not require path edits. Missing or duplicate names stop
evaluation. Update only that source with `nix flake update matt-skills`, review
the lock-file diff, then rebuild. Nix owns these skill links; do not update them
with `npx skills update`.
