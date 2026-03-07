# System Prompt Analysis

## Overview

The system prompt is built dynamically from multiple sources in `nanobot/agent/context.py`.

## Prompt Construction Order

1. **Identity** (`context.py:56-82`) - Core agent identity
2. **Bootstrap Files** (AGENTS.md, SOUL.md, USER.md, TOOLS.md, IDENTITY.md)
3. **Memory** - Long-term memory from MEMORY.md
4. **Skills** - Always-active skills + skills summary

## Components

### 1. Identity (context.py)

```python
# nanobot 🐈

You are nanobot, a helpful AI assistant.

## Runtime
{macOS/Darwin} {machine}, Python {version}

## Workspace
Your workspace is at: {workspace_path}
- Long-term memory: {workspace}/memory/MEMORY.md
- History log: {workspace}/memory/HISTORY.md
- Custom skills: {workspace}/skills/{skill-name}/SKILL.md

## nanobot Guidelines
- State intent before tool calls, but NEVER predict results
- Read before modifying files
- Re-read after writing/editing if accuracy matters
- Analyze errors before retrying
- Ask for clarification when ambiguous
- Reply directly with text; only use 'message' tool for specific channels
```

### 2. Bootstrap Files

| File | Purpose |
|------|---------|
| AGENTS.md | Agent-specific instructions (scheduled reminders, heartbeat tasks) |
| SOUL.md | Personality: helpful, friendly, concise, accurate |
| USER.md | User profile (name: Jaeyoon, timezone: SEOUL UTC+9) |
| TOOLS.md | Tool constraints (exec safety, cron usage) |
| IDENTITY.md | (custom additional identity) |

### 3. Memory

- `MEMORY.md` - Long-term facts
- `HISTORY.md` - Searchable conversation log

### 4. Skills

- Always-active skills loaded by default
- Other skills available via read_file + SKILL.md

## Evaluation

### Strengths
- **Modular**: Separate identity, personality, user prefs, tools
- **Clear guidelines**: Safety rules for file operations
- **Persistence**: MEMORY.md + HISTORY.md for continuity
- **Periodic tasks**: HEARTBEAT.md integration built-in

### Gaps
- USER.md preferences are mostly unchecked - not fully customized
- No explicit instruction distinguishing cron vs heartbeat usage

## Files Reference

- Context builder: `nanobot/agent/context.py`
- Bootstrap files: `workspace/{AGENTS,SOUL,USER,TOOLS,IDENTITY}.md`
- Memory: `workspace/memory/{MEMORY,HISTORY}.md`
- Heartbeat: `workspace/HEARTBEAT.md`
