# Heartbeat Notification Filtering

## Problem

The heartbeat service was sending notifications even when there were no meaningful changes. The LLM was returning messages like:

```
✅ Obsidian Vault Sync Complete (2026-03-08 01:08 KST)
Vault synced - no new changes since last check.
```

This defeated the purpose of conditional notifications.

## Root Cause

The heartbeat service (`nanobot/heartbeat/service.py`) only checked if `response` was truthy before notifying. It had no mechanism to filter out "no changes" type responses.

## Solution

Implemented a marker-based filtering system:

1. **Marker**: `<NO NOTIFICATION>`
2. **Detection**: Service checks if response contains this exact string
3. **Behavior**: If marker present, skip notification silently

### Code Change

`nanobot/heartbeat/service.py:159-165`:

```python
if response and self.on_notify:
    if "<NO NOTIFICATION>" in response:
        logger.info("Heartbeat: no notification needed")
        return
    logger.info("Heartbeat: completed, delivering response")
    await self.on_notify(response)
```

### HEARTBEAT.md Update

Task instructions updated to tell LLM to use the marker:

```markdown
- **Obsidian Vault Sync**: Check ~/Documents/obs_vault via git pull every 1 hour. 
  If there are new commits/changes pulled, notify the user with details. 
  If "Already up to date" or no meaningful changes, respond ONLY with `<NO NOTIFICATION>` - 
  do not send any message.
```

## Why Marker-Based Approach

- **Explicit**: LLM knows exactly what to do
- **Self-documenting**: Marker is visible in agent responses
- **Flexible**: Can be used in any task instruction
- **Safe**: No guesswork about phrasing variations

## Alternative Approaches Considered

1. **Phrase matching**: Check for "no new", "nothing new", etc.
   - Risky: May miss variations
   - Brittle: Language-dependent
   
2. **Empty response**: Return empty string to skip notification
   - Confusing: Hard to distinguish "no response" from "no notification"
   - Breaking: Existing code may expect non-empty response

## Files Modified

| File | Change |
|------|--------|
| `nanobot/heartbeat/service.py` | Added marker detection before notify |
| `~/.nanobot/workspace/HEARTBEAT.md` | Updated task instruction with marker |
