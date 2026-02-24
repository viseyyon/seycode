# SeyCode Architecture

> **SeyCode** - Next-generation AI coding agent with revolutionary architecture

## 🏗️ Architectural Philosophy

SeyCode is built on three core principles:

1. **Skill-First Development** - Every common task has a skill
2. **Agent Specialization** - Right agent, right permissions, right task
3. **Quality by Design** - Built-in review, audit, and validation

## 🎯 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         User Interface Layer                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │   TUI    │  │  Web UI  │  │ Desktop  │  │   API    │        │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘        │
└───────┼─────────────┼─────────────┼─────────────┼──────────────┘
        │             │             │             │
        └─────────────┴─────────────┴─────────────┘
                            │
┌───────────────────────────┼──────────────────────────────────────┐
│                           │         Server Layer                  │
│                    ┌──────▼──────┐                               │
│                    │  HTTP Server │ (Hono on Bun)                │
│                    │  Port 4096   │                               │
│                    └──────┬───────┘                               │
│                           │                                        │
│    ┌──────────────────────┼──────────────────────┐               │
│    │                      │                      │               │
│ ┌──▼───┐            ┌────▼────┐           ┌────▼────┐           │
│ │ ACP  │            │ Session │           │  REST   │           │
│ │Server│            │ Manager │           │  Routes │           │
│ └──────┘            └────┬────┘           └────┬────┘           │
└────────────────────────────┼──────────────────────┼──────────────┘
                             │                      │
┌────────────────────────────┼──────────────────────┼──────────────┐
│                            │   Core Engine Layer  │              │
│    ┌───────────────────────┼──────────────────────┼────┐         │
│    │                       │                      │    │         │
│ ┌──▼─────────┐      ┌─────▼──────┐        ┌─────▼────▼──┐      │
│ │   Agent    │      │  Workflow  │        │    Tool     │      │
│ │  Registry  │◄─────┤ Orchestr.  ├───────►│  Registry   │      │
│ └──┬─────────┘      └─────┬──────┘        └─────┬───────┘      │
│    │                      │                      │              │
│    │  ┌───────────────────┼──────────────────────┼────────┐     │
│    │  │                   │                      │        │     │
│    │  │  ┌────────────┐   │  ┌──────────────┐   │        │     │
│    └──┼─►│   Build    │   └─►│    Plan      │◄──┘        │     │
│       │  │   Agent    │      │    Agent     │             │     │
│       │  └────────────┘      └──────────────┘             │     │
│       │                                                    │     │
│       │  ┌────────────┐      ┌──────────────┐            │     │
│       │  │  Security  │      │  Test Gen.   │            │     │
│       │  │  Auditor   │      │    Agent     │            │     │
│       │  └────────────┘      └──────────────┘            │     │
│       │                                                    │     │
│       │  ┌────────────┐      ┌──────────────┐            │     │
│       │  │   Perf.    │      │    Doc       │            │     │
│       │  │  Analyzer  │      │   Writer     │            │     │
│       │  └────────────┘      └──────────────┘            │     │
│       └────────────────────────────────────────────────────┘     │
└──────────────────────────────────────────────────────────────────┘
                             │
┌────────────────────────────┼──────────────────────────────────────┐
│                    Integration Layer                              │
│    ┌───────────┐     ┌────▼────┐     ┌──────────┐     ┌───────┐ │
│    │    LSP    │     │   MCP   │     │ Plugins  │     │Skills │ │
│    │  Manager  │     │ Manager │     │  System  │     │System │ │
│    └─────┬─────┘     └────┬────┘     └────┬─────┘     └───┬───┘ │
└──────────┼────────────────┼───────────────┼─────────────────┼─────┘
           │                │               │                 │
┌──────────┼────────────────┼───────────────┼─────────────────┼─────┐
│          │        Data & State Layer      │                 │     │
│    ┌─────▼─────┐    ┌────▼────┐    ┌────▼─────┐    ┌──────▼───┐ │
│    │   SQLite  │    │  Event  │    │ Instance │    │   Skill  │ │
│    │    DB     │    │   Bus   │    │  State   │    │  Cache   │ │
│    │ (Drizzle) │    │ (Pub/Sub)    │ (Per-Dir)│    │          │ │
│    └───────────┘    └─────────┘    └──────────┘    └──────────┘ │
└──────────────────────────────────────────────────────────────────┘
           │                │               │                 │
┌──────────┼────────────────┼───────────────┼─────────────────┼─────┐
│          │        Provider Layer          │                 │     │
│    ┌─────▼──────────────────────────┐    │                 │     │
│    │      LLM Provider Manager      │    │                 │     │
│    ├────────────┬───────────────────┤    │                 │     │
│    │ Anthropic  │  OpenAI  │ Google│    │                 │     │
│    │   Azure    │ OpenRouter│ Local│    │                 │     │
│    └────────────┴───────────────────┘    │                 │     │
└──────────────────────────────────────────┼─────────────────┼─────┘
                                           │                 │
                                     ┌─────▼─────────────────▼──┐
                                     │   External Services      │
                                     │  (Git, Shell, FS, etc.)  │
                                     └──────────────────────────┘
```

## 🔑 Key Architectural Improvements in SeyCode

### 0. **Automatic Prompt Engineering** 🌟🌟

**Killer Feature #1 that makes SeyCode better than Claude Code:**

Every prompt is automatically optimized BEFORE execution:

```
User Input → @prompt-engineer (auto) → Enhanced Prompt → Execution
```

The prompt-engineer analyzes intent, adds context, suggests skill chains, injects quality gates, and makes every prompt optimal.

**Example**:
- Input: "fix this bug"
- Enhanced: "Investigate [bug] in [component]: 1) @architecture-explorer 2) @debug-helper 3) Fix 4) @test-generator 5) @test-runner 6) @code-reviewer"

**Benefits**:
- Every prompt is optimized automatically
- Consistent quality across all interactions
- Built-in best practices
- Nothing is forgotten
- Better outcomes every time

### 0.5. **Automatic Memory Management & Checkpoints** 🌟🌟

**Killer Feature #2 that makes SeyCode revolutionary:**

Every action automatically creates checkpoints enabling perfect resume and rollback:

```
Action Start → Pre-Checkpoint → Execute → Post-Checkpoint → Save
```

The memory-manager tracks all state changes and allows:
- Resume from any checkpoint
- Rollback any action or series of actions
- Branch for parallel exploration
- Smart recovery from failures

**Example**:
- Every file edit → checkpoint
- Every tool execution → checkpoint
- Every skill invocation → checkpoint
- All checkpoints stored in SQLite with file snapshots

**Benefits**:
- Never lose work
- Safe experimentation with rollback
- Perfect recovery from any failure
- Branch management for multiple approaches
- Complete audit trail
- Resume after interruption

**Architecture**:
```
┌─────────────────────────────────────────┐
│         Memory Manager Layer            │
├─────────────────────────────────────────┤
│  Pre-Checkpoint  │  Post-Checkpoint     │
│  State Snapshot  │  State Snapshot      │
├─────────────────────────────────────────┤
│          Storage Layer                   │
│  ┌──────────┐    ┌──────────┐          │
│  │ SQLite   │    │   Git    │          │
│  │ Metadata │    │ Snapshots│          │
│  └──────────┘    └──────────┘          │
├─────────────────────────────────────────┤
│       Recovery Operations               │
│  Resume │ Rollback │ Branch │ Compare  │
└─────────────────────────────────────────┘
```

### 1. **Workflow Orchestration System**

Unlike traditional agent systems, SeyCode has a meta-skill that analyzes tasks and recommends optimal skill chains:

```
User Task → @workflow-orchestrator → Skill Chain → Execution → Quality Gates → Done
```

**Benefits**:
- Eliminates uncertainty about which skills to use
- Ensures consistent quality through quality gates
- Reduces cognitive load on developers
- Self-documenting workflows

### 2. **Multi-Agent Collaboration Framework**

SeyCode uses specialized agents that collaborate:

```
Primary Task (build agent)
  ├─→ @architecture-explorer (understand codebase)
  ├─→ @tool-creator (create tools)
  ├─→ @test-generator (generate tests)
  ├─→ @code-reviewer (review code)
  ├─→ @security-auditor (security audit)
  └─→ @doc-writer (documentation)
```

**Benefits**:
- Each agent is expert in its domain
- Fine-grained permissions prevent mistakes
- Parallel execution when possible
- Built-in quality assurance

### 3. **Permission-Based Security**

Every agent has precisely defined permissions:

```json
{
  "security-auditor": {
    "read": { "*": "allow" },
    "write": { "*": "deny" },
    "bash": { "*": "deny" }
  }
}
```

**Benefits**:
- Prevents accidental modifications
- Security by design
- Audit trail of all actions
- Safe experimentation

### 4. **Skill System as Executable Documentation**

Skills are not just documentation - they're executable workflows:

```markdown
---
name: tool-creator
description: Create tools with proper structure
---

1. Understand requirement
2. Create tool file
3. Register in registry
4. Generate SDK
5. Test
```

**Benefits**:
- Self-documenting workflows
- Consistent execution
- Easy to extend
- Version controlled

### 5. **Event-Driven Architecture**

All components communicate via event bus:

```typescript
Bus.publish(Session.Event.Updated, data)
Bus.subscribe(Session.Event.Updated, handler)
```

**Benefits**:
- Loose coupling
- Easy to add new features
- Real-time updates
- Debugging support

### 6. **Instance-Based Isolation**

Each project directory gets isolated state:

```typescript
const state = Instance.state(
  () => initialize(),
  async (s) => cleanup(s)
)
```

**Benefits**:
- No state pollution between projects
- Lazy initialization
- Automatic cleanup
- Thread-safe

### 7. **Provider-Agnostic LLM Integration**

SeyCode works with any LLM provider:

```
LLM Request → Provider Manager → Provider-Specific Adapter → LLM API
```

**Benefits**:
- Not locked to one provider
- Easy to add new providers
- Cost optimization
- Fallback support

## 🚀 Architectural Patterns

### 1. **Tool Registry Pattern**

Dynamic tool discovery and registration:

```typescript
// Tools are discovered from:
- Builtin tools (src/tool/builtin/)
- Plugin tools (from plugins)
- MCP tools (from MCP servers)
- Config tools (from config directories)
```

### 2. **Agent Factory Pattern**

Agents are created with specific configurations:

```typescript
const agent = AgentFactory.create({
  name: "security-auditor",
  permissions: {
    read: { "*": "allow" },
    write: { "*": "deny" }
  }
})
```

### 3. **Session Processor Pattern**

LLM streaming with tool invocation loop:

```typescript
while (!done) {
  response = await streamLLM(messages, tools)
  if (response.toolCalls) {
    results = await executeTool(toolCalls)
    messages.push(results)
  } else {
    done = true
  }
}
```

### 4. **Plugin Hook Pattern**

Plugins extend functionality via hooks:

```typescript
export default {
  auth: () => ({ /* auth logic */ }),
  tool: () => ({ /* tool definition */ }),
  event: (event) => { /* handle event */ }
}
```

## 📊 Data Flow

### Request Flow

```
1. User Input → TUI/Web/Desktop
2. HTTP Request → Server (Hono)
3. Route Handler → Session Manager
4. Session Manager → Workflow Orchestrator
5. Orchestrator → Selects Agents & Skills
6. Agents → Execute Tools
7. Tools → Interact with System
8. Results → Back to LLM
9. LLM Response → Streamed to Client
```

### Session Lifecycle

```
1. Session.create(projectID, directory)
2. Load project context (git, config)
3. Initialize agents and tools
4. Process messages in loop:
   - User message → Session
   - Session → LLM with tools
   - LLM → Tool calls
   - Tools → Execute
   - Results → Back to LLM
   - Loop until done
5. Session compaction (if needed)
6. Store in SQLite
7. Emit events via bus
```

## 🔐 Security Architecture

### Multi-Layer Security

1. **Agent Permissions** - Fine-grained control
2. **Tool Validation** - Input validation with Zod
3. **Sandboxing** - Isolated execution environments
4. **Audit Logging** - All actions logged
5. **Security Auditor Agent** - Automatic security review

### Permission Evaluation

```typescript
Permission Check:
  1. Check agent permissions
  2. Match against path pattern
  3. Evaluate: allow | deny | ask
  4. If ask → Prompt user
  5. Log decision
  6. Execute or deny
```

## 📈 Scalability

### Horizontal Scaling

- **Stateless server** - Can run multiple instances
- **SQLite with WAL mode** - Concurrent reads
- **Event bus** - Distributed via Redis (future)
- **Session sharding** - By project ID

### Performance Optimizations

- **Lazy loading** - Load only what's needed
- **Caching** - Skill cache, LSP cache
- **Streaming** - Real-time responses
- **Parallel execution** - Independent tasks run concurrently

## 🔧 Extensibility Points

### 1. **Skills**
Add `.md` files to `.opencode/skill/`

### 2. **Agents**
Configure in `seycode.json`

### 3. **Tools**
- Builtin: Add to `src/tool/builtin/`
- Plugin: Export from plugin
- MCP: Connect MCP server

### 4. **Providers**
Add to `src/provider/provider.ts`

### 5. **Plugins**
Create npm package with hooks

## 🎯 Future Architectural Improvements

### 1. **Distributed Execution**
- Run agents on different machines
- Load balancing
- Resource pooling

### 2. **Agent Learning**
- Agent performance metrics
- Automatic skill improvement
- Pattern recognition

### 3. **Advanced Caching**
- Semantic cache for LLM responses
- Tool result caching
- Smart invalidation

### 4. **Multi-Project Sessions**
- Work across multiple projects
- Cross-project insights
- Dependency management

### 5. **Real-Time Collaboration**
- Multiple users in same session
- Conflict resolution
- Shared context

### 6. **Plugin Marketplace**
- Discover and install plugins
- Rating and reviews
- Automatic updates

### 7. **Advanced Security**
- Role-based access control
- OAuth integration
- Encrypted storage

## 📚 Architecture Principles

### 1. **Separation of Concerns**
Each layer has a specific responsibility

### 2. **Dependency Inversion**
Depend on abstractions, not implementations

### 3. **Open/Closed Principle**
Open for extension, closed for modification

### 4. **Single Responsibility**
Each component does one thing well

### 5. **Composition over Inheritance**
Build complex behavior from simple parts

### 6. **Explicit over Implicit**
Make intentions clear

### 7. **Fail Fast**
Detect errors early

### 8. **Convention over Configuration**
Sensible defaults, configure when needed

## 🎓 Learning Path

### For New Contributors

1. **Read CLAUDE.md** - Understand the system
2. **Explore with @architecture-explorer** - Navigate codebase
3. **Study a skill** - See how workflows work
4. **Modify a skill** - Make it your own
5. **Create a skill** - Add new workflows
6. **Contribute back** - Share with community

### For Users

1. **Try @workflow-orchestrator** - Let it guide you
2. **Use skills** - Don't reinvent the wheel
3. **Create custom agents** - Tailor to your needs
4. **Build custom skills** - Automate your patterns
5. **Share skills** - Help others

## 🏆 Why SeyCode Architecture is Revolutionary

1. **Skill-First Development** - First agent system with executable skill workflows
2. **Workflow Orchestration** - Meta-skill that recommends optimal paths
3. **Multi-Agent Collaboration** - Specialized agents working together
4. **Quality by Design** - Built-in review and audit agents
5. **Permission-Based Security** - Fine-grained, safe by default
6. **Event-Driven** - Loosely coupled, easily extensible
7. **Provider-Agnostic** - Works with any LLM
8. **Instance Isolation** - Clean state management
9. **Extensible** - Skills, agents, tools, plugins
10. **Production-Ready** - Not a toy, a real development tool

---

**SeyCode** - Where architecture meets productivity. 🚀
