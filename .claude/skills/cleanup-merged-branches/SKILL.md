---
name: cleanup-merged-branches
description: Deletes local and remote git branches whose PR has already merged, following this repo's issue-<n>-slug branch-per-issue convention. Use whenever the user asks to clean up, delete, or prune old/stale/merged branches (local, remote, or both), or mentions leftover issue- branches cluttering the repo.
---

Clean up branches that are safe to delete because their work already landed via a merged PR. If this repo names branches `issue-<n>-slug` (one branch per issue, one PR per branch - see [[git-issue-workflow]]), stale ones pile up over time both locally and on `origin`, especially before "Automatically delete head branches" is enabled on the repo.

Accept an optional prefix argument; default to `issue-`.

## Steps

1. List local branches matching the prefix: `git branch --list "<prefix>*"`.
2. List remote branches matching the prefix: `git ls-remote --heads origin | grep "refs/heads/<prefix>"`.
3. Note the currently checked-out branch (`git branch --show-current`) - never delete it even if it matches the prefix.
4. For every other matching branch (local ∪ remote, deduplicated by name), look up its PR: `gh pr list --head <branch> --state all --json number,state,title`.
5. A branch is safe to delete only if it has exactly one associated PR and that PR's state is `MERGED`. Anything else - no PR found, `OPEN`, `CLOSED` without merging, or multiple PRs - gets skipped and reported, not deleted. When in doubt, skip it; a leftover branch costs nothing, a wrongly deleted one can lose unmerged work.
6. Delete safe local branches with `git branch -d` (not `-D`) - this is a real safety net, since git itself refuses if the branch isn't fully merged into the current HEAD.
7. Delete safe remote branches with `git push origin --delete <branch>`.
8. Print a summary: branches deleted locally, deleted remotely, and skipped (each with its reason - no PR, PR open, PR closed-unmerged, or is the current branch).

Do the PR lookups before any deletion - batch-check everything first, then delete, so a single `gh` failure partway through doesn't leave you deleting branches based on stale/incomplete information.
