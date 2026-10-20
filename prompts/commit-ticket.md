---
name: Commit message with ticket
interaction: chat
description: Generate a commit message and commit the staged changes
tools:
  - git_commit
opts:
  alias: commit-ticket
  auto_submit: false
  is_slash_cmd: true
  approval_mode: ask
---

## user

You are an expert at writing clear, concise commit messages. Given the git diff listed below, generate a commit message and commit it.

```diff
${commit.diff}
```

Ticket for the current branch: ${commit.ticket}

If a ticket is shown above, the commit subject must start with that ticket followed by a colon and a space, then the description. For example, `PLATFORM-1234: add login page`. Do not add a Conventional Commit type in this case.

If no ticket is shown, follow the Conventional Commit specification. For example, `feat: add login page`.

Call the `git_commit` tool with the full message. Do not ask for confirmation in the chat; the tool asks before it commits. If there are no staged changes, tell me there is nothing to commit instead of calling the tool.
