# User Preferences

## Git Branch Workflow

When creating git branches, always use the branch name specified by the Linear issue. If no Linear issue exists for the work, search Linear for an existing one first, then create a new issue if none is found. The Linear issue must exist before any branch is created.

## Commit Message Format

```
subsystem: Short summary line (50 chars or less)

More detailed explanatory text wrapped at 72 characters. Explain
what the change does and why, not how (the code shows how). Include
any relevant context that will help reviewers and future readers
understand the change.

For bug fixes, describe the problem being solved. For features,
describe the use case and design rationale.

Issue: DSW-123
```

- Do NOT include Co-Authored-By lines
- Title line: `subsystem: Summary` (50 chars max)
- Body wrapped at 72 chars
- Always end with `Issue: <LINEAR-ID>`

# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.
