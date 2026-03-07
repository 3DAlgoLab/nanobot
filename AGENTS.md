# AGENTS.md - Developer Guidelines for nanobot

nanobot is an ultra-lightweight personal AI assistant (~4,000 lines of core code). It connects to chat platforms (Telegram, Discord, Feishu, Slack, etc.) and uses LLM providers via LiteLLM.

## Build, Lint, and Test Commands

### Installation (Development)

```bash
# Using uv (recommended)
uv add --dev -e .

# Using pip
pip install -e ".[dev]"
```

### Running Tests

```bash
pytest                          # Run all tests
pytest tests/test_commands.py   # Run single test file
pytest -v                       # Verbose output
pytest -k "test_name"           # Run tests matching pattern
```

### Linting

```bash
ruff check .           # Run linter
ruff check --fix .     # Auto-fix issues
```

### Building

```bash
hatch build    # Build package
pip install -e .  # Install locally
```

## Code Style

### Python Version & Features

- **Minimum**: Python 3.11
- Use modern features: `match/case`, walrus operator, `|` union types

### Imports

Order: 1) Standard library, 2) Third-party, 3) Local modules. Use `TYPE_CHECKING` for type-only imports:

```python
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from nanobot.config.schema import Config
```

### Type Hints

- Use Python 3.11+ syntax: `str | None` (not `Optional[str]`)
- Use `list[str]`, `dict[str, int]` (not `List`, `Dict`)
- Add hints to all function signatures

### Naming Conventions

- **Variables/functions**: `snake_case` (`agent_loop`)
- **Classes**: `PascalCase` (`AgentLoop`)
- **Constants**: `UPPER_SNAKE_CASE` (`MAX_RETRIES`)
- **Private methods**: prefix underscore (`_internal_method`)

### Pydantic Models

Use Pydantic v2 with camelCase alias:

```python
from pydantic import BaseModel, ConfigDict, Field
from pydantic.alias_generators import to_camel

class Base(BaseModel):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

class TelegramConfig(Base):
    enabled: bool = False
    token: str = ""
```

Use `Field(default_factory=list)` for mutable defaults.

### Logging

Use `loguru`:

```python
from loguru import logger
logger.info("Processing message")
logger.error(f"Failed: {error}")
```

### Error Handling

- Use exceptions for flow control
- Log errors before re-raising
- Include context in error messages

### Async Code

- Use `asyncio` for async operations
- Use `async with` for context managers
- Handle exceptions properly in async functions

## File Organization

```
nanobot/
├── agent/          # Core agent logic (loop, context, memory, skills, tools)
├── channels/       # Chat platform integrations
├── bus/            # Message routing
├── cron/           # Scheduled tasks
├── heartbeat/      # Periodic wake-up tasks
├── providers/      # LLM providers
├── session/        # Conversation sessions
├── config/         # Configuration schema
├── cli/            # CLI commands
├── utils/          # Utility functions
├── skills/         # Bundled skills (.md)
└── templates/      # Agent templates (.md)
```

## Configuration

- **Build backend**: hatchling
- **Line length**: 100 characters
- **Target Python**: py311
- **Ruff rules**: E, F, I, N, W (except E501)

## Test Guidelines

- Use `pytest` with `pytest-asyncio` (asyncio_mode = "auto")
- Use `unittest.mock.patch` for mocking
- Use `typer.testing.CliRunner` for CLI testing
- Create fixtures for test isolation with `yield` for cleanup

## Adding New Providers

1. Add `ProviderSpec` to `PROVIDERS` in `nanobot/providers/registry.py`
2. Add field to `ProvidersConfig` in `nanobot/config/schema.py`

## Adding New Channels

1. Create module in `nanobot/channels/`
2. Inherit from `BaseChannel`
3. Implement: `connect()`, `disconnect()`, `send()`, `get_id()`
4. Register in `nanobot/channels/__init__.py`

## Key Dependencies

- **typer**: CLI framework
- **pydantic**: Configuration
- **litellm**: Unified LLM interface
- **loguru**: Logging
- **pytest**: Testing
- **ruff**: Linting
