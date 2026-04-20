---
name: confirm-before-external-write
description: Before writing to any shared external system (Slack, Jira, Google Calendar, GitHub comments/PRs, Confluence pages), always show the user what you plan to send and ask for explicit confirmation. Never post, create, edit, transition, or delete in these systems without approval.
---

# Confirm Before External Write

Before taking any action that writes to a shared external system, stop and show the user exactly what you plan to do. Wait for explicit confirmation before proceeding.

## Systems that require confirmation

| System | Requires confirmation | Safe without confirmation |
|--------|----------------------|--------------------------|
| Slack | Sending or scheduling any message | Reading channels/threads |
| Jira | Creating, editing, or transitioning tickets | Reading issues, searching |
| Google Calendar | Creating, updating, or deleting events | Reading events, finding free time |
| GitHub | Posting comments, opening/closing PRs, creating issues | All git commands, reading PRs/issues |
| Gmail | Sending emails | Creating drafts |
| Confluence | Creating or editing pages | Reading pages |

## What confirmation looks like

Before acting, show:
1. **What system** you're writing to
2. **What action** you're taking (create / edit / send / delete)
3. **The exact content or change** — full message text, ticket fields, event details, etc.

Then ask: _"Should I go ahead?"_ — do not proceed until the user says yes.

## Example (Slack)

> I'm going to send the following message to #eng-general:
>
> > "Deploy to prod is complete. All checks passing."
>
> Should I go ahead?

## Example (Jira)

> I'm going to create a Jira ticket:
> - **Project**: ENG | **Summary**: Fix null pointer in auth middleware
> - **Priority**: Medium | **Assignee**: me
>
> Should I go ahead?

## Never

- Post a Slack message without showing the text first
- Create or edit a Jira ticket without showing all fields first
- Modify or delete a calendar event without confirming
- Post a GitHub comment or open a PR without showing the content first
- Send an email (drafts are fine)
- Create or edit a Confluence page without showing the full content first
