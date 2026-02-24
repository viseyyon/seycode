---
name: agent-router
description: Automatic agent and skill identification and initiation based on prompt analysis
priority: -998
auto: true
---

# Agent Router

**AUTOMATICALLY INVOKED** - Analyzes prompts and automatically selects and initiates the optimal agents and skills.

## Purpose

SeyCode's intelligent routing system that:
- **Analyzes Intent** - Understands what the prompt wants to achieve
- **Identifies Agents** - Selects the right specialized agents
- **Routes to Skills** - Automatically invokes appropriate skills
- **Chains Execution** - Orchestrates multi-skill workflows
- **Optimizes Path** - Finds the most efficient execution path

## How It Works

```
User Prompt
    ↓
@prompt-engineer (optimize)
    ↓
@agent-router (analyze & route)
    ↓
Intent Classification
    ↓
Agent Selection
    ↓
Skill Identification
    ↓
Auto-Initiation
    ↓
Execution
```

## Intent Classification

### Security-Related Intents

**Keywords**: security, vulnerability, audit, exploit, injection, XSS, CSRF, authentication, authorization

**Auto-Route**:
```
Primary Agent: @security-auditor
Skills: None (agent handles)
Quality Gates: Always enabled
```

**Example**:
```
Prompt: "check this code for security issues"
→ Routes to: @security-auditor
→ Auto-initiates: Security audit
```

### Performance-Related Intents

**Keywords**: performance, slow, optimize, faster, bottleneck, memory, CPU, latency, speed

**Auto-Route**:
```
Primary Agent: @perf-analyzer
Skills: @debug-helper (if profiling needed)
Quality Gates: Benchmark before/after
```

**Example**:
```
Prompt: "this is too slow, make it faster"
→ Routes to: @perf-analyzer
→ Auto-initiates: Performance analysis
→ Then: @debug-helper for profiling
→ Then: Optimization suggestions
```

### Testing-Related Intents

**Keywords**: test, testing, coverage, unit test, integration test, e2e, verify

**Auto-Route**:
```
Primary Agent: @test-generator
Skills: @test-runner
Quality Gates: Test coverage check
```

**Example**:
```
Prompt: "add tests for this function"
→ Routes to: @test-generator
→ Auto-initiates: Test generation
→ Then: @test-runner to verify
```

### Documentation-Related Intents

**Keywords**: document, documentation, docs, README, explain, comment

**Auto-Route**:
```
Primary Agent: @doc-writer
Skills: @doc-generator
Quality Gates: Documentation review
```

**Example**:
```
Prompt: "document this API"
→ Routes to: @doc-writer
→ Auto-initiates: @doc-generator
→ Quality gate: Documentation review
```

### Code Review Intents

**Keywords**: review, check, look at, examine, critique, feedback

**Auto-Route**:
```
Primary Agent: @code-reviewer
Skills: @security-auditor, @perf-analyzer (parallel)
Quality Gates: All reviews must pass
```

**Example**:
```
Prompt: "review this code"
→ Routes to: @code-reviewer (primary)
→ Auto-initiates: @security-auditor (parallel)
→ Auto-initiates: @perf-analyzer (parallel)
→ Combines all feedback
```

### Refactoring Intents

**Keywords**: refactor, clean up, improve, reorganize, restructure

**Auto-Route**:
```
Primary Agent: @refactor-agent
Skills: @architecture-explorer (understand first)
Quality Gates: @code-reviewer, @test-runner
```

**Example**:
```
Prompt: "refactor this mess"
→ Routes to: @architecture-explorer (understand structure)
→ Then: @refactor-agent (refactor)
→ Then: @test-runner (verify tests pass)
→ Then: @code-reviewer (review changes)
```

### Tool Creation Intents

**Keywords**: create tool, new tool, add tool, tool for

**Auto-Route**:
```
Primary Agent: build
Skills: @tool-creator → @sdk-regenerator → @test-generator → @test-runner
Quality Gates: Tests passing, SDK updated
```

**Example**:
```
Prompt: "create a tool that does X"
→ Routes to: @tool-creator
→ Auto-chain: @sdk-regenerator
→ Auto-chain: @test-generator
→ Auto-chain: @test-runner
→ Quality gate: All tests pass
```

### Agent Creation Intents

**Keywords**: create agent, new agent, add agent, agent for, configure agent

**Auto-Route**:
```
Primary Agent: build
Skills: @agent-creator
Quality Gates: Configuration valid
```

**Example**:
```
Prompt: "create an agent for X"
→ Routes to: @agent-creator
→ Auto-initiates: Agent configuration
→ Quality gate: Config validation
```

### Database/Migration Intents

**Keywords**: database, migration, schema, table, column, SQL

**Auto-Route**:
```
Primary Agent: @migration-helper
Skills: @migration-creator → @sdk-regenerator → @test-runner
Quality Gates: Migration successful
```

**Example**:
```
Prompt: "add a users table"
→ Routes to: @migration-creator
→ Auto-chain: @sdk-regenerator
→ Auto-chain: @test-runner (test migrations)
→ Quality gate: Migration applied successfully
```

### API Design Intents

**Keywords**: API, endpoint, route, REST, POST, GET, PUT, DELETE

**Auto-Route**:
```
Primary Agent: @api-designer
Skills: @sdk-regenerator → @test-generator → @test-runner
Quality Gates: API tests passing
```

**Example**:
```
Prompt: "add POST /api/users endpoint"
→ Routes to: @api-designer
→ Auto-chain: @sdk-regenerator
→ Auto-chain: @test-generator
→ Auto-chain: @test-runner
→ Quality gate: API tests pass
```

### Architecture/Exploration Intents

**Keywords**: how does, how is, understand, explain, architecture, structure, where is

**Auto-Route**:
```
Primary Agent: build
Skills: @architecture-explorer
Quality Gates: None (informational)
```

**Example**:
```
Prompt: "how does the session system work?"
→ Routes to: @architecture-explorer
→ Auto-initiates: Codebase exploration
→ Returns: Comprehensive explanation
```

### Debugging Intents

**Keywords**: debug, debugger, breakpoint, inspect, trace

**Auto-Route**:
```
Primary Agent: build
Skills: @debug-helper
Quality Gates: None (setup only)
```

**Example**:
```
Prompt: "help me debug this"
→ Routes to: @debug-helper
→ Auto-initiates: Debug setup
→ Returns: Debug instructions
```

### Provider-Related Intents

**Keywords**: provider, LLM, model, add provider, new provider

**Auto-Route**:
```
Primary Agent: build
Skills: @provider-adder
Quality Gates: Provider tested
```

**Example**:
```
Prompt: "add OpenAI provider"
→ Routes to: @provider-adder
→ Auto-initiates: Provider integration
→ Quality gate: Provider connection test
```

### LSP Configuration Intents

**Keywords**: LSP, language server, autocomplete, intellisense

**Auto-Route**:
```
Primary Agent: build
Skills: @lsp-configurator
Quality Gates: LSP running
```

**Example**:
```
Prompt: "setup TypeScript LSP"
→ Routes to: @lsp-configurator
→ Auto-initiates: LSP configuration
→ Quality gate: LSP server responds
```

## Multi-Intent Detection

### Complex Prompts

When multiple intents are detected:

```
Prompt: "add authentication with tests and documentation"

Detected Intents:
1. Feature addition (authentication)
2. Testing
3. Documentation

Auto-Route:
1. @workflow-orchestrator (plan workflow)
2. @architecture-explorer (understand auth)
3. @api-designer (design endpoints)
4. @migration-helper (database tables)
5. @sdk-regenerator (update SDK)
6. @test-generator (generate tests)
7. @test-runner (run tests)
8. @security-auditor (security review)
9. @doc-generator (documentation)

Quality Gates:
- All tests pass
- Security audit clear
- Documentation complete
```

## Agent Identification System

### Agent Capabilities Matrix

| Agent | Best For | Triggers |
|-------|----------|----------|
| **security-auditor** | Security reviews | security, vulnerability, audit |
| **test-generator** | Test creation | test, testing, coverage |
| **doc-writer** | Documentation | document, docs, README |
| **code-reviewer** | Code quality | review, check, examine |
| **perf-analyzer** | Performance | performance, slow, optimize |
| **migration-helper** | Database | database, migration, schema |
| **refactor-agent** | Code cleanup | refactor, clean, improve |
| **api-designer** | API development | API, endpoint, route |

### Agent Selection Logic

1. **Extract keywords** from prompt
2. **Match against triggers** for each agent
3. **Calculate confidence scores**
4. **Select primary agent** (highest score)
5. **Select supporting agents** (parallel or sequential)
6. **Auto-initiate** selected agents

### Confidence Scoring

```typescript
interface AgentMatch {
  agent: string
  confidence: number // 0.0 to 1.0
  triggers: string[] // matched keywords
  context: string[] // supporting evidence
}

// Example:
Prompt: "check this code for security and performance"

Matches:
- security-auditor: 0.95 (triggers: security, check)
- perf-analyzer: 0.90 (triggers: performance)
- code-reviewer: 0.70 (triggers: check)

Selected:
- Primary: security-auditor (0.95)
- Secondary: perf-analyzer (0.90)
- Tertiary: code-reviewer (0.70)
```

## Skill Identification System

### Skill Mapping

| Skill | When to Use | Auto-Chain |
|-------|-------------|------------|
| **tool-creator** | "create tool" | → sdk-regenerator → test-generator → test-runner |
| **agent-creator** | "create agent" | None |
| **provider-adder** | "add provider" | → sdk-regenerator |
| **test-runner** | After code changes | None |
| **debug-helper** | "debug", "breakpoint" | None |
| **sdk-regenerator** | After API changes | None |
| **architecture-explorer** | "how does", "explain" | None |
| **migration-creator** | "database", "table" | → sdk-regenerator → test-runner |
| **lsp-configurator** | "LSP", "autocomplete" | None |
| **doc-generator** | "document", "docs" | None |
| **workflow-orchestrator** | Complex multi-step | Multiple skills |

### Auto-Chaining Rules

**Rule 1: Tool Creation Chain**
```
@tool-creator → @sdk-regenerator → @test-generator → @test-runner
```

**Rule 2: API Change Chain**
```
@api-designer → @sdk-regenerator → @test-generator → @test-runner
```

**Rule 3: Database Change Chain**
```
@migration-creator → @sdk-regenerator → @test-runner
```

**Rule 4: Feature Addition Chain**
```
@architecture-explorer → implementation → @test-generator → @test-runner → @code-reviewer → @doc-generator
```

**Rule 5: Bug Fix Chain**
```
@architecture-explorer → @debug-helper → fix → @test-generator → @test-runner → @code-reviewer
```

## Execution Flow

### Sequential Execution

For dependent operations:

```
Step 1: @architecture-explorer
  ↓ (wait for completion)
Step 2: @tool-creator
  ↓ (wait for completion)
Step 3: @sdk-regenerator
  ↓ (wait for completion)
Step 4: @test-runner
```

### Parallel Execution

For independent operations:

```
Step 1: Implementation
  ↓
Step 2: ┌─ @security-auditor
        ├─ @perf-analyzer
        └─ @code-reviewer
  ↓ (wait for all)
Step 3: Combine feedback
```

### Conditional Execution

Based on results:

```
Step 1: @test-runner
  ↓
If tests fail:
  → @debug-helper
  → Fix issues
  → @test-runner (retry)
If tests pass:
  → Continue
```

## Auto-Initiation Protocol

### Safety Checks

Before auto-initiating:

1. **Permission Check** - Does agent have required permissions?
2. **Resource Check** - Are required resources available?
3. **Conflict Check** - Will this conflict with current operations?
4. **User Preference** - Has user disabled auto-initiation?

### Initiation Modes

**Mode 1: Silent Auto-Initiation**
- No user confirmation
- For safe, read-only operations
- Example: @architecture-explorer

**Mode 2: Notify-and-Execute**
- Show what's being initiated
- Execute immediately
- User can cancel
- Example: @test-runner

**Mode 3: Confirm-Before-Execute**
- Show proposed agents/skills
- Wait for confirmation
- Execute after approval
- Example: @refactor-agent

**Mode 4: Manual**
- Show recommendations
- User initiates manually
- Example: Complex workflows

### Configuration

```json
{
  "agentRouter": {
    "enabled": true,
    "autoInitiate": true,
    "mode": "notify-and-execute",
    "confidence": {
      "threshold": 0.7,
      "autoInitiateAbove": 0.9
    },
    "parallel": {
      "enabled": true,
      "maxConcurrent": 3
    },
    "safety": {
      "confirmDestructive": true,
      "confirmCostly": true,
      "maxAutoChainLength": 5
    }
  }
}
```

## Examples

### Example 1: Simple Security Check

```
User: "is this code secure?"

@agent-router analyzes:
- Intent: Security review
- Confidence: 0.95
- Selected: @security-auditor

Auto-initiates:
→ @security-auditor (silent auto-initiation)
→ Returns: Security audit report
```

### Example 2: Performance Optimization

```
User: "make this faster"

@agent-router analyzes:
- Intent: Performance optimization
- Confidence: 0.90
- Selected: @perf-analyzer, @debug-helper

Auto-initiates:
1. @perf-analyzer (identify bottlenecks)
2. @debug-helper (setup profiling)
3. Shows: Optimization suggestions

Notifies user:
"Auto-initiated: @perf-analyzer, @debug-helper
 Found: 3 bottlenecks
 Suggestions ready"
```

### Example 3: Complex Feature

```
User: "add user authentication"

@agent-router analyzes:
- Intent: Complex feature addition
- Confidence: 0.85
- Selected: @workflow-orchestrator

Auto-initiates:
→ @workflow-orchestrator

@workflow-orchestrator creates plan:
1. @architecture-explorer
2. @security-auditor (current state)
3. @api-designer
4. @migration-helper
5. @sdk-regenerator
6. @test-generator
7. @test-runner
8. @security-auditor (final)
9. @doc-generator

Shows plan to user:
"Complex feature detected. Proposed workflow:
 [shows 9-step plan]

 Proceed? (y/N):"
```

## Benefits

1. **Zero Configuration** - Works automatically
2. **Intelligent Routing** - Right agent for each task
3. **Optimal Path** - Most efficient execution
4. **Parallel Execution** - Independent tasks run concurrently
5. **Safety First** - Confirms destructive operations
6. **Learning System** - Improves with usage
7. **User Control** - Can be overridden or disabled

$ARGUMENTS
