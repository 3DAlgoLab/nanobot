# Agent LLM Interaction

How the nanobot agent interacts with LLMs.

## Call Chain

```
Entry Point                        File:Line
────────────────────────────────────────────────────────────────────
User message (CLI/Channel)
        │
        ▼
agent/loop.py:194         ──►  await self.provider.chat(...)
        │
        ▼
providers/litellm_provider.py:246  ──►  await acompletion(**kwargs)
        │
        ▼
litellm (external library)  ──►  calls actual LLM API (OpenAI, Anthropic, etc.)
        │
        ▼
Response parsed back through:
providers/litellm_provider.py:255  ──►  _parse_response()
        │
        ▼
providers/base.py:17  ──►  LLMResponse (content, tool_calls, etc.)
        │
        ▼
agent/loop.py:203-256  ──►  Handle tool calls or return content
```

## Key Modules

| Module | Role |
|--------|------|
| `agent/loop.py` | Main agent loop - sends messages, handles tool calls |
| `providers/litellm_provider.py` | Wraps `litellm.acompletion()` for multi-provider support |
| `providers/base.py` | Abstract `LLMProvider` class + `LLMResponse` dataclass |
| `providers/registry.py` | Provider metadata (supported models, prefixes, etc.) |

## How It Works

1. Messages (with history/context) sent to provider
2. LiteLLM handles the actual API call to the configured provider
3. Response parsed into `LLMResponse` (content + tool_calls)
4. If tool_calls → execute tools → append results → loop
5. If no tool_calls → return content
