---
description: Find bugs in the current branch compared to main
---

## Context

- Current branch: !`git branch --show-current`
- Branch diff vs main: !`git diff main...HEAD`
- Recent commits on branch: !`git log --oneline main..HEAD`

## Your task

Analyze all changes in the current branch compared to main and identify any potential bugs, issues, or code quality problems. Look for:
1. Logic errors or incorrect implementations
2. Potential runtime errors or exceptions
3. Type mismatches or incorrect API usage
4. Missing error handling
5. Code that doesn't follow best practices
6. Security vulnerabilities
7. Breaking changes that might affect existing functionality

Provide specific feedback with file and line references where applicable.