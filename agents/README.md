# Claude Code Agents

This directory contains specialized agents for Claude Code that help with various development tasks.

## Directory Structure

```
agents/
├── README.md              # This file
├── architect.md           # Software architecture agent
└── python/               # Python-specific agents
    ├── backend-py.md
    ├── qa-backend-py.md
    ├── reviewer-backend-py.md
    └── reviewer-library-py.md
```

## Organization

Agents are organized by language or technology to maintain a clean and scalable structure:

- **Root level**: Language-agnostic agents (architecture, general purpose)
- **python/**: Python-specific agents for development, QA, and code review
- **[future]**: Other language directories (e.g., `javascript/`, `go/`, etc.)

## Available Agents

### General
- **architect**: Software architecture and system design agent

### Python (see `python/README.md` for details)
- **backend-py**: Backend development with Clean Architecture
- **qa-backend-py**: Quality assurance and testing
- **reviewer-backend-py**: Code review for backend applications
- **reviewer-library-py**: Code review for library development

## Using Agents

All agents in this directory (including subdirectories) are automatically discovered by the synchronization scripts:

```bash
# Sync agents to your project
../scripts/sync-agents.sh

# Validate agent structure
../scripts/validate-agents.sh
```

The sync script will present all available agents regardless of their directory location, maintaining a flat structure in your project's `.claude/agents` directory.

## Adding New Agents

When adding new agents:
1. Place language-specific agents in the appropriate subdirectory
2. Place language-agnostic agents in the root `agents/` directory
3. Follow the agent file format (YAML frontmatter + Markdown content)
4. Run `validate-agents.sh` to ensure compliance
