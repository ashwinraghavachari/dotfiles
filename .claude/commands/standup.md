---
description: Generate a standup update from recent git commits and in-progress work. Use when preparing for a daily standup meeting.
allowed-tools: Bash
---

Generate a standup update based on recent git activity in this repo.

1. Run `git log --since="2 days ago" --oneline --author="$(git config user.name)"` to find recent commits
2. Run `git status` and `git diff --stat HEAD` to find in-progress work
3. Scan recently changed files for TODO/FIXME comments

Format the output as:
- **Yesterday**: what was completed (based on commits — plain English, no hashes)
- **Today**: logical next steps based on in-progress or staged work
- **Blockers**: any TODO/FIXME in recently touched files, or "None"

Keep it brief — one line per item. Write it ready to paste into Slack.
