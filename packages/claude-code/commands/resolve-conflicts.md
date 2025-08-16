---
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git merge:*), Bash(git rebase:*), Bash(git add:*), Bash(git commit:*), Bash(git checkout:*), Bash(git reset:*), Read, Edit, Grep
description: Help resolve merge conflicts step by step
---

## Context

- Current git status: !`git status`
- Merge/rebase status: !`git status --porcelain | grep "^UU\|^AA\|^DD\|^AU\|^UA\|^DU\|^UD"`
- Conflicted files: !`git diff --name-only --diff-filter=U`

## Your task

Help resolve merge conflicts by:

1. **Analyze the conflicts**: 
   - List all files with conflicts
   - For each conflicted file, show the conflict markers and surrounding context
   - Identify the nature of each conflict (code changes, imports, etc.)

2. **Provide resolution strategy**:
   - Explain what each side of the conflict represents (HEAD vs incoming branch)
   - Suggest which changes to keep, merge, or modify
   - Highlight any potential issues with the proposed resolution

3. **Resolve conflicts**:
   - Edit each conflicted file to remove conflict markers
   - Ensure the resolved code is syntactically correct and logically sound
   - Preserve the intent of both conflicting changes when possible

4. **Verify resolution**:
   - Check that no conflict markers remain in any files
   - Stage the resolved files
   - Provide a summary of what was resolved

5. **Complete the merge/rebase**:
   - Create an appropriate commit message for the merge resolution
   - Continue the merge/rebase process

## Guidelines

- Always read the full conflicted files to understand context
- Look for related changes that might need coordination
- Test that imports and dependencies are still correct after resolution
- Maintain code style and formatting consistency
- When in doubt, ask for clarification rather than making assumptions