# Python Agents

This directory contains specialized Claude Code agents for Python development.

## Available Agents

### Development
- **backend-py.md**: Backend Python Development Agent specializing in Clean Architecture and Hexagonal Architecture for scalable and maintainable backend systems.
- **qa-backend-py.md**: Quality Assurance agent for Python backend applications with comprehensive testing strategies.

### Code Review
- **reviewer-backend-py.md**: Comprehensive code reviewer for Python backend PRs, combining architecture analysis, code quality validation, and testing coverage assessment.
- **reviewer-library-py.md**: Specialized code reviewer for Python library development with focus on API design, documentation, and package distribution.

## Usage

These agents are automatically discovered by the sync scripts. When using `scripts/sync-agents.sh`, agents from this directory will be available for installation.

## Organization

Python-specific agents are organized here to:
- Keep the agents directory clean and organized by language/technology
- Make it easier to maintain language-specific agents
- Allow for better scalability as more agents are added