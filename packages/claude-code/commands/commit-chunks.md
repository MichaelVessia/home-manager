---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*)
description: Group changed files into logical chunks and commit each separately
---

## Context

- Current git status: !`git status`
- Current git diff (unstaged changes): !`git diff`
- Current git diff (staged changes): !`git diff --cached`

## Your task

Analyze the changed files and group them into logical chunks, then create separate commits for each chunk:
1. Review all changed files and their modifications
2. Group files that belong together logically (e.g., related feature changes, bug fixes, refactoring, etc.)
3. For each logical chunk:
   - Stage only the files belonging to that chunk
   - Create a commit with a descriptive message specific to that chunk. DO NOT include any Claude attribution or "Generated with Claude Code" text in commit messages.
4. Continue until all changes are committed
5. You have the capability to call multiple tools in a single response. You MUST do all staging and committing in a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.