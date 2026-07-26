#!/usr/bin/env bash

# Update first-level GitHub repos under a workspace.
#
# Usage:
#   scripts/update-github-repos.sh [directory]
#
# Defaults to scripts/../.., e.g. /Users/whitewater/workspaces.
# Conservative: only clean main/master repos with GitHub upstreams are updated.

set -euo pipefail

if (( $# > 1 )); then
  printf 'Usage: %s [directory]\n' "$0" >&2
  exit 2
fi

if ! command -v git >/dev/null 2>&1; then
  printf 'Error: git is required but was not found in PATH.\n' >&2
  exit 127
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
target_dir="${1:-"$script_dir/../.."}"

if [[ ! -d "$target_dir" ]]; then
  printf 'Error: target directory does not exist: %s\n' "$target_dir" >&2
  exit 2
fi

target_dir="$(cd -- "$target_dir" && pwd -P)"
github_remote_re='^(github\.com:|git@github\.com:|https://github\.com/)[^/[:space:]]+/[^/[:space:]]+(\.git)?$'

updated=0
skipped=0
failed=0
found=0

skip_repo() {
  printf 'skipped: %s (%s)\n' "$repo" "$1"
  skipped=$((skipped + 1))
}

fail_repo() {
  printf 'failed: %s (%s)\n' "$repo" "$1"
  failed=$((failed + 1))
}

printf 'Scanning first-level Git repositories in: %s\n' "$target_dir"

shopt -s nullglob dotglob

for repo_dir in "$target_dir"/*; do
  [[ -d "$repo_dir" ]] || continue

  top_level="$(git -C "$repo_dir" rev-parse --show-toplevel 2>/dev/null || true)"
  [[ -n "$top_level" ]] || continue

  repo_real="$(cd -- "$repo_dir" && pwd -P)"
  top_level_real="$(cd -- "$top_level" && pwd -P)"
  [[ "$repo_real" == "$top_level_real" ]] || continue

  found=$((found + 1))
  repo="$(basename -- "$repo_dir")"

  if ! status="$(git -C "$repo_dir" status --porcelain 2>/dev/null)"; then
    fail_repo "git status failed"
    continue
  fi

  if [[ -n "$status" ]]; then
    skip_repo "uncommitted changes"
    continue
  fi

  branch="$(git -C "$repo_dir" symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
  if [[ -z "$branch" ]]; then
    skip_repo "detached HEAD"
    continue
  fi

  if [[ "$branch" != "main" && "$branch" != "master" ]]; then
    skip_repo "current branch is $branch, only main/master are updated"
    continue
  fi

  if ! git -C "$repo_dir" rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
    skip_repo "no upstream"
    continue
  fi

  remote="$(git -C "$repo_dir" config --get "branch.${branch}.remote" || true)"
  if [[ -z "$remote" || "$remote" == "." ]]; then
    skip_repo "no remote upstream"
    continue
  fi

  remote_url="$(git -C "$repo_dir" config --get "remote.${remote}.url" || true)"
  if [[ -z "$remote_url" ]]; then
    skip_repo "missing upstream remote URL"
    continue
  fi

  if [[ ! "$remote_url" =~ $github_remote_re ]]; then
    skip_repo "upstream remote URL is not an accepted GitHub URL"
    continue
  fi

  if git -C "$repo_dir" fetch --prune && git -C "$repo_dir" pull --ff-only; then
    printf 'updated: %s\n' "$repo"
    updated=$((updated + 1))
  else
    fail_repo "fetch or fast-forward pull failed"
  fi
done

if (( found == 0 )); then
  printf 'No first-level Git repositories found.\n'
fi

printf 'Summary: updated=%d skipped=%d failed=%d\n' "$updated" "$skipped" "$failed"
exit "$((failed > 0))"
