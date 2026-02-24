---
name: doc-generator
description: Generate comprehensive documentation for code, APIs, and system architecture
---

# Documentation Generator

Generate high-quality documentation for the SeyCode codebase.

## Documentation Types

### API Documentation
Generate OpenAPI/route documentation:
```bash
# API docs are auto-generated from server.ts
./script/generate.ts
# Output: OpenAPI specs in packages/sdk/
```

### Code Documentation
Document modules, functions, and classes:

**Module-level**:
```markdown
# Module: Session Management

## Purpose
Handles LLM conversation sessions with compaction, revert, and sharing.

## Key Files
- `index.ts` - Session CRUD operations
- `processor.ts` - LLM streaming and tool invocation
- `message-v2.ts` - Message storage format

## Usage
\```typescript
const session = await Session.create(projectID, directory)
await Session.message.add(sessionID, { role: "user", content: "..." })
\```
```

**Function-level**:
```typescript
/**
 * Processes a user message through the LLM with tool calling support.
 *
 * @param sessionID - Unique session identifier
 * @param message - User message content
 * @param stream - Whether to stream responses
 * @returns Async generator of response chunks
 *
 * @example
 * for await (const chunk of processMessage(id, "Hello", true)) {
 *   console.log(chunk)
 * }
 */
export async function* processMessage(
  sessionID: string,
  message: string,
  stream: boolean
) {
  // Implementation
}
```

### Architecture Documentation
Document system design and component relationships:

```markdown
# Architecture: Session Processing

## Flow
1. User sends message → TUI/Web client
2. Client → HTTP POST /api/sessions/{id}/messages
3. Server → Session.processor
4. Processor → Streams to LLM with tool definitions
5. LLM → Returns response with potential tool calls
6. Processor → Executes tools via Tool Registry
7. Tool results → Fed back to LLM
8. Loop until completion
9. Final response → Streamed back to client

## Key Components
- **SessionProcessor** (`src/session/processor.ts`) - Orchestrates LLM interaction
- **ToolRegistry** (`src/tool/registry.ts`) - Manages tool execution
- **EventBus** (`src/bus/`) - Publishes session updates

## State Management
- Session state → SQLite via Drizzle
- Message parts → Stored incrementally
- Streaming state → In-memory during processing

## Error Handling
- Tool failures → Returned to LLM as error messages
- LLM errors → Caught and logged, session continues
- Doom loop detection → Rejects after 3 consecutive tool failures
```

### User Documentation
Create end-user guides:

```markdown
# Using Custom Agents

## Overview
SeyCode allows you to create custom agents with specific behaviors and permissions.

## Creating an Agent

1. Create `seycode.json` in your project root
2. Add agent configuration:
   \```json
   {
     "agents": {
       "my-agent": {
         "description": "What this agent does",
         "permission": {
           "read": { "*": "allow" },
           "write": { "docs/**": "allow" }
         }
       }
     }
   }
   \```
3. Restart SeyCode or run `seycode attach`

## Using the Agent

Switch to your agent with Tab key or invoke with `@my-agent` in messages.

## Examples

See `.seycode/skill/agent-creator.md` for more examples.
```

## Documentation Locations

### Code Documentation
- **Inline comments** - Complex logic, non-obvious behavior
- **Function docstrings** - Public APIs, exported functions
- **README files** - Package-level overview

### System Documentation
- **CLAUDE.md** - Development guide for future Claude instances
- **CONTRIBUTING.md** - Contribution guidelines
- **AGENTS.md** - Style guide and learnings
- **Architecture docs** - `specs/` directory

### User Documentation
- **Website** - `packages/docs/`
- **README.md** - Quick start and installation
- **Skill files** - `.seycode/skill/*.md`

## Documentation Best Practices

### ✅ DO
- Explain WHY, not just WHAT
- Include code examples
- Keep examples up-to-date
- Document edge cases and gotchas
- Link to related documentation
- Use diagrams for complex flows

### ❌ DON'T
- Document obvious code
- Duplicate information
- Write essays - be concise
- Leave TODOs in production docs
- Use outdated examples

## Generating Docs

### For New Features
```bash
# 1. Write inline documentation
# Add docstrings to public APIs

# 2. Update CLAUDE.md if architecture changes
# Add to relevant section

# 3. Create or update skill files
# If adding common workflow, create skill

# 4. Update user docs if needed
# packages/docs/ for end-user features

# 5. Generate API docs
./script/generate.ts
```

### For Bug Fixes
```bash
# 1. Document the fix in commit message
# Explain root cause and solution

# 2. Add to AGENTS.md if non-obvious
# Help future developers avoid same issue

# 3. Update relevant documentation
# Fix outdated examples if needed
```

## Documentation Templates

### API Route Documentation
```typescript
/**
 * GET /api/sessions/:id
 *
 * Retrieves session information by ID.
 *
 * @param id - Session UUID
 * @returns Session object with metadata and message count
 * @throws 404 if session not found
 *
 * @example
 * GET /api/sessions/abc-123
 * Response: { id: "abc-123", title: "...", messageCount: 5 }
 */
```

### Component Documentation
```markdown
# Component: Tool Registry

## Responsibility
Discovers, registers, and executes tools that the LLM can call.

## Lifecycle
1. Initialize: Scan for builtin tools, plugins, MCP servers
2. Register: Build tool map with id → implementation
3. Execute: Called by session processor when LLM invokes tool
4. Cleanup: Dispose of resources on shutdown

## Key Methods
- `discover()` - Find all available tools
- `register(tool)` - Add tool to registry
- `execute(toolId, input)` - Run tool with input
- `list()` - Get all registered tools

## Extension Points
- Builtin tools: Add to `src/tool/builtin/`
- Plugin tools: Export from plugin
- MCP tools: Connect MCP server
```

## Keeping Docs Updated

### Regular Maintenance
- Review docs quarterly
- Update examples when APIs change
- Remove outdated information
- Add FAQs from common issues

### CI Integration
```bash
# Add to CI pipeline
npm run docs:build  # Verify docs build
npm run docs:lint   # Check broken links
npm run docs:test   # Test code examples
```

## Documentation Tools

- **TypeDoc** - Generate from TypeScript
- **Docusaurus** - User documentation site
- **Mermaid** - Diagrams in markdown
- **OpenAPI** - API specification

$ARGUMENTS
