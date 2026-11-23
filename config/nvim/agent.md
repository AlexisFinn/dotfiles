# Agent Configuration

This document describes the AI coding agent setup for this Neovim configuration, powered by CodeCompanion and MCPHub.

## Overview

This Neovim configuration features a sophisticated AI coding assistant that integrates seamlessly with your development workflow. The agent is built on top of two main components:

- **CodeCompanion**: The primary AI coding assistant plugin
- **MCPHub**: Model Context Protocol integration for extended capabilities

## Core Components

### CodeCompanion

The main AI coding assistant that provides:
- Interactive chat interface for code discussions
- Inline code suggestions and completions
- Code analysis and refactoring assistance
- Integration with multiple AI models

**Configuration Location**: `lua/plugins/codecompanion.lua`

**Key Features**:
- **Model**: Claude Sonnet 4 (primary model)
- **Interface**: Vertical chat window on the right side with rounded borders
- **Tools**: Custom tool groups including file operations, search, and editing
- **Adapter**: GitHub Copilot integration

**Keybindings**:
- `<leader>a` - Open CodeCompanion Actions (Normal/Visual mode)
- `<leader>aa` - Toggle CodeCompanion Chat

### MCPHub

Extends the agent's capabilities through the Model Context Protocol:
- Database queries (PostgreSQL integration)
- Neovim editor integration
- Server management capabilities

**Configuration Location**: `lua/plugins/mcphub.lua`

**Connected Servers**:
- **postgres**: Database schema access and querying
- **neovim**: Direct Neovim integration (buffer/workspace operations)
- **mcphub**: Server management and documentation

## Agent Capabilities

### Code Operations
- Read, write, and edit files
- Search across the workspace
- Execute shell commands
- Analyze code structure and dependencies

### Database Integration
- Query PostgreSQL databases
- Access schema information
- Analyze database structure

### Neovim Integration
- Buffer manipulation
- Workspace navigation
- Diagnostic information
- LSP integration

### Development Workflow
- Git operations support
- Build tool integration (Yarn, npm)
- Formatting and linting
- Code generation and refactoring

## LSP Integration

The agent works alongside multiple Language Server Protocol configurations:

**Supported Languages**:
- TypeScript/JavaScript (ts_ls)
- Lua (lua-language-server)
- Biome (formatting/linting)
- AWK scripting
- SonarLint (code quality)

**LSP Features**:
- Auto-completion with fuzzy matching
- Inlay hints
- Real-time diagnostics
- Go-to definition/declaration

## Tool Configuration

### Custom Tool Groups

The agent has access to a curated set of tools organized into the "my_tools" group:

- `cmd_runner`: Execute shell commands
- `create_file`: Create new files
- `file_search`: Find files by pattern
- `grep_search`: Search file contents
- `insert_edit_into_file`: Edit existing files
- `read_file`: Read file contents

### MCP Tools

Extended capabilities through Model Context Protocol:
- Database operations
- Neovim editor control
- Server management
- Resource access

## Usage Patterns

### Interactive Development
1. Use `<leader>aa` to open the chat interface
2. Discuss code changes and get suggestions
3. Agent can directly edit files and execute commands
4. Real-time feedback through LSP integration

### Code Analysis
- Agent can read entire workspace structure
- Analyze dependencies and relationships
- Provide architectural insights
- Suggest improvements and refactoring

### Database Operations
- Query database schemas
- Analyze data structures
- Generate database-related code
- Optimize queries

## Best Practices

### Agent Interaction
- Be specific about the files and directories you want to work with
- Use the chat interface for complex multi-step operations
- Leverage the agent's ability to read multiple files simultaneously

### Code Quality
- Agent respects existing code style and formatting
- Integrates with configured linters and formatters
- Maintains consistency with project patterns

### Workflow Integration
- Agent understands Git workflows
- Respects project structure and conventions
- Works with existing build and development tools

## Configuration Files

The agent configuration is spread across several files:

```
lua/
├── config/
│   ├── lsp.lua              # LSP configuration
│   ├── base.lua             # Lazy.nvim bootstrap
│   └── settings.lua         # General Neovim settings
└── plugins/
    ├── codecompanion.lua    # AI agent configuration
    └── mcphub.lua           # MCP integration
```

## Troubleshooting

### Common Issues
1. **Model not responding**: Check GitHub Copilot authentication
2. **MCP servers disconnected**: Use `mcphub` tools to restart servers
3. **LSP not working**: Verify language servers are installed via Mason

### Debug Information
- Check `:CodeCompanion` status for agent health
- Use `:LspInfo` for language server diagnostics
- Monitor `log.log` for detailed error information

## Extending the Agent

### Adding New Tools
1. Create tool configurations in `codecompanion.lua`
2. Add to appropriate tool groups
3. Configure permissions and capabilities

### Adding MCP Servers
1. Install the MCP server
2. Configure in MCPHub
3. Enable through the management interface

### Custom Commands
Add custom Neovim commands in `config/cmds/` directory for specialized workflows.

## Security Considerations

- **Auto-approve**: Currently enabled for MCP requests
- **File access**: Agent has read/write access to workspace
- **Command execution**: Can execute shell commands
- **Database access**: Read-only access to configured databases

Ensure sensitive data is properly protected and review agent suggestions before applying significant changes.