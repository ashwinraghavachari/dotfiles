---
description: Review uncommitted or unpushed changes for correctness, style, and potential issues. Use before committing or opening a PR.
allowed-tools: Bash, Read, Grep
---

Review the current changes in this repo.

1. Run `git diff HEAD` (or `git diff origin/$(git branch --show-current)...HEAD` if changes are committed but unpushed) to get the full diff
2. For each changed file, read the surrounding context to understand intent
3. Check for:
   - Logic errors or off-by-one issues
   - Unhandled error cases
   - Debug code, print statements, or TODOs left in
   - Inconsistencies with the surrounding code style
   - Security issues (hardcoded secrets, SQL injection, unvalidated input)

Give feedback as a bulleted list grouped by file. Flag blockers (must fix) separately from suggestions (nice to have). If the changes look clean, say so.
