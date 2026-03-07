# Agent Parameters

## maxTokens

- **Purpose**: Maximum tokens in LLM **output** (response generation)
- **Default**: 8192 (`nanobot/config/schema.py:229`)
- **Input context**: Managed separately by `memoryWindow`
- **Too small**: Truncated responses, incomplete tasks, JSON/structured output errors, confusing AI behavior

## memoryWindow

- **Purpose**: Triggers memory consolidation when unconsolidated messages >= this threshold
- **Default**: 100 (`nanobot/config/schema.py:232`)
- **Behavior**: When triggered, keeps only `memoryWindow // 2` messages in active context; older messages are summarized via LLM and saved to MEMORY.md/HISTORY.md

## maxToolIterations

- **Purpose**: Maximum number of tool call iterations in agent loop
- **Default**: 40 (`nanobot/config/schema.py:231`)
- **Location**: `nanobot/agent/loop.py:191`

## Notes

- 200K context is for **input** (system prompt + memory + conversation history)
- `max_tokens` only limits output length, not input
- Ensure `input_tokens + max_tokens <= context_limit` (200K in your case)
- With default `memoryWindow=100`, input is ~100 messages
- Suggested `max_tokens` for 200K context: 4096-8192
- **Too large (e.g., 100K)**: Wastes context space, potential runaway output if something goes wrong

## Recommended for Complex Coding Tasks

| Parameter | Recommended | Reason |
|-----------|-------------|--------|
| `maxTokens` | 8192-16384 | Code can be long, need complete responses |
| `memoryWindow` | 150-200 | More context to understand codebase |
| `maxToolIterations` | 60-80 | Complex tasks need more tool calls |

Or keep defaults and just bump `maxTokens` to 16384.
