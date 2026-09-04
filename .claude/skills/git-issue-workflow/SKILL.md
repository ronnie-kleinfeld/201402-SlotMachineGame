---
name: git-issue-workflow
description: Governs how code changes land in this repo. Default is to leave changes uncommitted in the working tree for manual review, unless the user's request explicitly says "PR" - then run the full issue -> branch -> commit -> push -> PR pipeline. Use whenever about to touch git (commit/push) for a trackable code change.
---

Standing convention for git work in this repo (`https://github.com/ronnie-kleinfeld/201402-SlotMachineGame`).

## Default: never commit - leave it in the working tree

Unless the user's request explicitly writes "PR" (or otherwise unambiguously asks for an issue/branch/PR), make the code change and stop there - **no `git add`, no `git commit`, no `git push`**, not even directly to the default branch. Assume the user reviews and commits changes themselves in their own git client. It's fine (and helpful) to suggest a commit message/description in the response for them to use. The two exceptions below still apply in this default path.

**Always flag it when changes are left this way.** End the response with a short line like `Uncommitted - review before committing.` so it's obvious the change is sitting in the working tree rather than already landed.

## Only when the user explicitly writes "PR"

1. Create an issue with a real, descriptive body (not just a title): `gh issue create --title "..." --body "..."`.
2. Branch off it: `git checkout -b issue-<issue-number>-<short-slug>` (the number is the issue number itself, e.g. `issue-146-add-retry-logic`).
3. Do the work, commit, push.
4. Open the PR - body includes `Closes #<n>`: `gh pr create --title "..." --body "..."`.
5. Do all of this proactively, without pausing to ask permission at each step.
6. End the response with a short line like `Changes in PR..` (mirrors the uncommitted-flag line above) so it's obvious the change went through the PR pipeline.

### One issue = one PR

Never bundle multiple concerns into one branch/PR. A follow-up request that changes the *kind* of work is a new, separate context - give it its own issue, branch, and PR, even if related to work just finished.

If the new work depends on files only present in a still-unmerged prior PR, branch off that PR's branch and open the new PR with `--base <prior-branch>` (a stacked PR), noting in the body that it should be retargeted once the prior PR merges.

If a commit already landed on the wrong branch/PR (bundling mistake caught after the fact): `git branch <new-branch> <sha>` to preserve it, `git reset --hard <sha-that-belongs>` on the original branch, `push --force-with-lease` to fix the original PR, then push the new branch and open its PR.

### After merge

Merging is the user's call, never the agent's - open the PR with `Closes #N` and stop; don't close/delete the PR yourself. Once merged (`gh pr view <n> --json state,mergedAt`), proactively switch to the default branch, pull `--ff-only`, and delete the local branch. If the repo has "automatically delete head branches" enabled, a `git push origin --delete` attempt failing with "remote ref does not exist" is expected, not an error.

"Revert PR #N" when that PR is still unmerged means there's nothing on the default branch to revert - check merge state first. If truly unmerged and revert is wanted, ask whether that means: close the PR only, close it and delete the branch, or close the PR + delete the branch + close the issue as not-planned.

Use [[cleanup-merged-branches]] to sweep up stale local/remote `issue-` branches.

## Exceptions (apply regardless of default vs. explicit-PR path)

- **Repo-specific ignored/generated paths** - if part of the repo is gitignored on purpose (e.g. per-environment assets living in a separate repo), don't commit/push those paths or propose un-ignoring them. List them here once known.
- **Dependency upgrades** (NuGet/npm/pip/etc.) - edit directly in whatever branch is already checked out (never create a new branch for a routine bump), verify with a build/test if easy, and leave the change uncommitted for review - unless the team prefers otherwise.
