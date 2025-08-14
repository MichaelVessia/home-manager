{ config, lib, pkgs, ... }:

{
  # Dependencies needed for Claude CLI installation
  home.packages = with pkgs; [
    curl
    gnutar
    gzip
  ];

  # Install Claude Code CLI using official installer and configure settings
  home.activation.installClaudeCLI = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Check if Claude CLI needs installation
    CLAUDE_PATH="$HOME/.local/bin/claude"
    
    if [[ -x "$CLAUDE_PATH" ]]; then
      # Claude CLI is already installed, check if it's working
      if $CLAUDE_PATH --version &>/dev/null; then
        CURRENT_VERSION=$($CLAUDE_PATH --version 2>/dev/null)
        echo "Claude CLI is already installed: $CURRENT_VERSION"
      else
        # Install if not working
        export PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:/usr/bin:''${PATH}"
        $DRY_RUN_CMD ${pkgs.curl}/bin/curl -fsSL claude.ai/install.sh | ${pkgs.bash}/bin/bash
      fi
    else
      # Install Claude Code CLI using official installer
      export PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:/usr/bin:''${PATH}"
      $DRY_RUN_CMD ${pkgs.curl}/bin/curl -fsSL claude.ai/install.sh | ${pkgs.bash}/bin/bash
    fi
    
    # Create/update Claude settings with statusline configuration
    # This runs after the installer to override any default settings
    echo "Configuring Claude statusline..."
    $DRY_RUN_CMD mkdir -p $HOME/.claude
    $DRY_RUN_CMD mkdir -p $HOME/.claude/commands
    # Create command files
    echo "Creating Claude command files..."
    $DRY_RUN_CMD cat > $HOME/.claude/commands/diff-bugs.md << 'EOF'
---
description: Find bugs in the current diff
---

## Context

- Current git status: !`git status`
- Current git diff: !`git diff`

## Your task

Analyze the current diff and identify any potential bugs, issues, or code quality problems. Look for:
1. Logic errors or incorrect implementations
2. Potential runtime errors or exceptions
3. Type mismatches or incorrect API usage
4. Missing error handling
5. Code that doesn't follow best practices
6. Security vulnerabilities

Provide specific feedback with line references where applicable.
EOF
    
    $DRY_RUN_CMD cat > $HOME/.claude/commands/branch-bugs.md << 'EOF'
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
EOF
    
    $DRY_RUN_CMD cat > $HOME/.claude/commands/commit-push-pr.md << 'EOF'
---
allowed-tools: Bash(git checkout --branch:*), Bash(git add:*), Bash(git status:*), Bash(git push:*), Bash(git commit:*), Bash(gh pr create:*)
description: Commit, push, and open a draft PR
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`

## Your task

Based on the above changes:
1. Create a new branch if on main. If provided as an argument, include the JIRA ticket in the branch name
2. Create a single commit with an appropriate message. DO NOT include any Claude attribution or "Generated with Claude Code" text in the commit message.
3. Push the branch to origin
4. Create a pull request using `gh pr create --draft`. Ensure the PR title adheres to conventional commits format
5. Update the PR description to adhere to the template in .github folder. If you don't know how to fill out a section, just leave it. If no template exists, include at minimum a description of the changes and steps to test the PR.
6. You have the capability to call multiple tools in a single response. You MUST do all of the above steps in a single message using multiple tool calls. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.
EOF
    
    $DRY_RUN_CMD cat > $HOME/.claude/commands/commit-all.md << 'EOF'
---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Stage all changed files and create a commit
---

## Context

- Current git status: !`git status`
- Current git diff (unstaged changes): !`git diff`
- Current git diff (staged changes): !`git diff --cached`

## Your task

Stage all changed files and create a single commit:
1. Stage all modified, added, and deleted files using appropriate git add commands
2. Create a commit with a descriptive message that summarizes all the changes. DO NOT include any Claude attribution or "Generated with Claude Code" text in the commit message.
3. You have the capability to call multiple tools in a single response. You MUST do all of the above in a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.
EOF
    
    $DRY_RUN_CMD cat > $HOME/.claude/commands/commit-chunks.md << 'EOF'
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
EOF
    
    $DRY_RUN_CMD cat > $HOME/.claude/commands/commit-and-push.md << 'EOF'
---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git push:*), Bash(git commit:*)
description: Commit changes and push to remote
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`

## Your task

Based on the above changes:
1. Stage any changed files with appropriate commit message
2. Create a single commit with a descriptive message. DO NOT include any Claude attribution or "Generated with Claude Code" text in the commit message.
3. Push the changes to the remote branch
4. You have the capability to call multiple tools in a single response. You MUST do all of the above in a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.
EOF
    
    # Install the statusline script with proper permissions
    $DRY_RUN_CMD install -m 755 ${toString ../../scripts/claude-statusline.sh} $HOME/.claude/claude-statusline
    
    # Create settings.json
    $DRY_RUN_CMD cat > $HOME/.claude/settings.json << 'EOF'
${builtins.toJSON {
      "$schema" = "https://json.schemastore.org/claude-code-settings.json";
      model = "opusplan";
      statusLine = {
        type = "command";
        command = "$HOME/.claude/claude-statusline";
      };
    }}
EOF
  '';
  # Note: Both the statusline script and settings.json are created in the
  # activation script above to ensure they run AFTER the Claude CLI installer

  # Create ~/.claude/CLAUDE.md with development guidelines
  home.file.".claude/CLAUDE.md".text = ''
    # Development Guidelines

    ## Philosophy

    ### Core Beliefs

    - **Incremental progress over big bangs** - Small changes that compile and pass tests
    - **Learning from existing code** - Study and plan before implementing
    - **Pragmatic over dogmatic** - Adapt to project reality
    - **Clear intent over clever code** - Be boring and obvious

    ### Simplicity Means

    - Single responsibility per function/class
    - Avoid premature abstractions
    - No clever tricks - choose the boring solution
    - If you need to explain it, it's too complex

    ## Process

    ### 1. Planning & Staging

    Break complex work into 3-5 stages. Document in `IMPLEMENTATION_PLAN.md`:

    ```markdown
    ## Stage N: [Name]
    **Goal**: [Specific deliverable]
    **Success Criteria**: [Testable outcomes]
    **Tests**: [Specific test cases]
    **Status**: [Not Started|In Progress|Complete]
    ```
    - Update status as you progress
    - Remove file when all stages are done

    ### 2. Implementation Flow

    1. **Understand** - Study existing patterns in codebase
    2. **Test** - Write test first (red)
    3. **Implement** - Minimal code to pass (green)
    4. **Refactor** - Clean up with tests passing
    5. **Commit** - With clear message linking to plan

    ### 3. When Stuck (After 3 Attempts)

    **CRITICAL**: Maximum 3 attempts per issue, then STOP.

    1. **Document what failed**:
       - What you tried
       - Specific error messages
       - Why you think it failed

    2. **Research alternatives**:
       - Find 2-3 similar implementations
       - Note different approaches used

    3. **Question fundamentals**:
       - Is this the right abstraction level?
       - Can this be split into smaller problems?
       - Is there a simpler approach entirely?

    4. **Try different angle**:
       - Different library/framework feature?
       - Different architectural pattern?
       - Remove abstraction instead of adding?

    ## Technical Standards

    ### Architecture Principles

    - **Composition over inheritance** - Use dependency injection
    - **Interfaces over singletons** - Enable testing and flexibility
    - **Explicit over implicit** - Clear data flow and dependencies
    - **Test-driven when possible** - Never disable tests, fix them

    ### Code Quality

    - **Every commit must**:
      - Compile successfully
      - Pass all existing tests
      - Include tests for new functionality
      - Follow project formatting/linting

    - **Before committing**:
      - Run formatters/linters
      - Self-review changes
      - Ensure commit message explains "why"

    ### Error Handling

    - Fail fast with descriptive messages
    - Include context for debugging
    - Handle errors at appropriate level
    - Never silently swallow exceptions

    ## Decision Framework

    When multiple valid approaches exist, choose based on:

    1. **Testability** - Can I easily test this?
    2. **Readability** - Will someone understand this in 6 months?
    3. **Consistency** - Does this match project patterns?
    4. **Simplicity** - Is this the simplest solution that works?
    5. **Reversibility** - How hard to change later?

    ## Project Integration

    ### Learning the Codebase

    - Find 3 similar features/components
    - Identify common patterns and conventions
    - Use same libraries/utilities when possible
    - Follow existing test patterns

    ### Tooling

    - Use project's existing build system
    - Use project's test framework
    - Use project's formatter/linter settings
    - Don't introduce new tools without strong justification

    ## Quality Gates

    ### Definition of Done

    - [ ] Tests written and passing
    - [ ] Code follows project conventions
    - [ ] No linter/formatter warnings
    - [ ] Commit messages are clear
    - [ ] Implementation matches plan
    - [ ] No TODOs without issue numbers

    ### Test Guidelines

    - Test behavior, not implementation
    - One assertion per test when possible
    - Clear test names describing scenario
    - Use existing test utilities/helpers
    - Tests should be deterministic

    ## Important Reminders

    **NEVER**:
    - Use `--no-verify` to bypass commit hooks
    - Disable tests instead of fixing them
    - Commit code that doesn't compile
    - Make assumptions - verify with existing code

    **ALWAYS**:
    - Commit working code incrementally
    - Update plan documentation as you go
    - Learn from existing implementations
    - Stop after 3 failed attempts and reassess
  '';

}
