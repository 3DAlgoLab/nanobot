# Experiments TODO

## Sync with Upstream Updates
To keep the experiments branch up to date with upstream changes:
1. Fetch latest upstream: `git fetch upstream`
2. Merge upstream into main: `git checkout main && git merge upstream/main`
3. Rebase experiments onto updated main: `git checkout experiments && git rebase main`
   - Resolve any conflicts if they arise.
   - This keeps experiments current while maintaining a clean history.