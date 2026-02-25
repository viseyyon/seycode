---
name: architecture-explorer
description: Explore and understand SeyCode's architecture and component relationships
---

# Architecture Explorer

Understand SeyCode's architecture by exploring key components and their relationships.

## Quick Architecture Map

```
packages/seycode/src/
├── server/          HTTP API (Hono on Bun)
│   └── routes/      Session, project, file, pty, MCP endpoints
├── session/         Session lifecycle, LLM streaming, message storage
│   └── processor.ts Tool invocation loop
├── agent/           Build, plan, general agents
├── tool/            Tool registry + builtins (bash, read, write, etc.)
├── lsp/             Language server management
├── mcp/             Model Context Protocol integration
├── plugin/          Plugin system + built-in plugins
├── skill/           Skill discovery (SKILL.md files)
├── provider/        LLM provider integrations (15+)
├── project/         Project detection, instance isolation
├── storage/         SQLite database (Drizzle ORM)
├── bus/             Pub/Sub event system
├── config/          Config loading with precedence
└── cli/             CLI commands + TUI
```

## Exploring a Component

### 1. Start with the main file
```bash
# Read component's main file
cat packages/seycode/src/{component}/index.ts
```

### 2. Check types and schemas
```bash
# Look for type definitions
rg "export.*type" packages/seycode/src/{component}/
rg "z\.object" packages/seycode/src/{component}/
```

### 3. Find usage examples
```bash
# See how it's used elsewhere
rg "import.*from.*{component}" packages/seycode/src/
```

### 4. Check tests
```bash
# Read tests to understand behavior
ls packages/seycode/test/{component}/
```

## Key Architectural Patterns

### Instance-Based Isolation
Each project directory gets isolated state via `Instance.provide()`:
```typescript
const state = Instance.state(
  () => initialize(),
  async (s) => cleanup(s)
)
```

### Event-Driven Updates
Components communicate via event bus:
```typescript
Bus.publish(Session.Event.Updated, data)
Bus.subscribe(Session.Event.Updated, handler)
```

### Tool Registry Pattern
Tools are dynamically discovered and registered:
```typescript
const tool = {
  id: "name",
  parameters: z.object({...}),
  execute: async (input, ctx) => {...}
}
```

### Config Precedence
Config loads from multiple sources with clear ordering (see CLAUDE.md)

## Understanding Data Flow

### LLM Request Flow
1. User sends message → TUI/Web
2. Message → Session processor
3. Processor streams to LLM
4. LLM calls tools → Tool registry
5. Tool executes → Returns result
6. Loop until complete
7. Response → Client

### Project Initialization Flow
1. User runs `sey dev <directory>`
2. Project detection (`.git/` lookup)
3. Generate/load project ID
4. Initialize instance state
5. Load config (precedence order)
6. Start server/TUI
7. Create/resume session

### Tool Discovery Flow
1. Scan builtin tools
2. Load config directories
3. Discover plugins
4. Register MCP tools
5. Build tool registry
6. Expose to LLM

## Exploring Specific Areas

### How sessions work
```bash
# Read session files
cat packages/seycode/src/session/index.ts
cat packages/seycode/src/session/message-v2.ts
cat packages/seycode/src/session/processor.ts

# Check database schema
cat packages/seycode/src/storage/db.ts | grep -A 20 "session"
```

### How agents work
```bash
# Read agent system
cat packages/seycode/src/agent/agent.ts

# Check built-in agents
rg "export const.*Agent" packages/seycode/src/agent/
```

### How tools work
```bash
# Read tool interface
cat packages/seycode/src/tool/tool.ts

# See builtin tools
ls packages/seycode/src/tool/builtin/

# Check tool registration
cat packages/seycode/src/tool/registry.ts
```

## Architecture Questions to Answer

Use these questions when exploring:

1. **Where is this state stored?** (Memory, SQLite, File)
2. **How is this state shared?** (Instance, Global, Per-session)
3. **What triggers this?** (Event, HTTP request, Tool call)
4. **What are the dependencies?** (Uses, Imports, Requires)
5. **How is this configured?** (Config file, Env var, CLI arg)
6. **Where are errors handled?** (Try/catch, .catch, Event)

## Deep Dive Commands

```bash
# Find all exports in a directory
rg "^export" packages/seycode/src/{component}/ --type ts

# Find all event publications
rg "Bus\.publish" packages/seycode/src/

# Find all database queries
rg "sql\`" packages/seycode/src/

# Find all tool registrations
rg "register.*tool" packages/seycode/src/ -i

# Find all config usages
rg "config\." packages/seycode/src/ --type ts -A 2
```

$ARGUMENTS
