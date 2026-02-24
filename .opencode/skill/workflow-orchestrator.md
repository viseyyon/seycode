---
name: workflow-orchestrator
description: Determine optimal workflow and skills to use for any development task
---

# Workflow Orchestrator

Analyze a task and recommend the optimal sequence of skills and agents to use.

## Task Analysis

Given a task, identify:
1. **Task type** - Feature, bug, refactor, documentation, etc.
2. **Areas affected** - Which parts of codebase
3. **Required skills** - Which skills are needed
4. **Agent requirements** - Which specialized agents
5. **Dependencies** - What needs to happen first

## Workflow Templates

### For New Features

```
@architecture-explorer → Understand where feature belongs
@agent-creator → Create feature-specific agent if needed
@tool-creator → Create supporting tools if needed
@api-designer → Design API routes if needed
@migration-helper → Handle database changes if needed
@sdk-regenerator → Update SDK after API changes
@test-generator → Generate comprehensive tests
@code-reviewer → Review implementation
@security-auditor → Security review
@perf-analyzer → Performance check
@doc-generator → Document feature
```

### For Bug Fixes

```
@architecture-explorer → Understand affected area
@debug-helper → Setup debugging
Fix the bug (manual or with agent)
@test-generator → Add regression tests
@test-runner → Verify fix
@code-reviewer → Review fix
@doc-writer → Update docs if needed
```

### For Refactoring

```
@architecture-explorer → Analyze current structure
@code-reviewer → Identify issues
@perf-analyzer → Find performance problems
@refactor-agent → Execute refactoring
@test-runner → Ensure tests pass
@code-reviewer → Final review
@doc-writer → Update documentation
```

### For Performance Optimization

```
@perf-analyzer → Identify bottlenecks
@architecture-explorer → Understand performance-critical paths
@debug-helper → Profile with debugger
@refactor-agent → Implement optimizations
@test-runner → Benchmark improvements
@doc-writer → Document optimizations
```

### For Security Issues

```
@security-auditor → Comprehensive security audit
@architecture-explorer → Understand security architecture
Fix vulnerabilities (manual or with agent)
@test-generator → Add security tests
@test-runner → Run security tests
@code-reviewer → Review security fixes
@doc-writer → Document security measures
```

### For API Changes

```
@architecture-explorer → Understand current API
@api-designer → Design new/modified endpoints
@sdk-regenerator → Update SDK
@test-generator → Generate API tests
@test-runner → Test API
@code-reviewer → Review implementation
@doc-generator → Generate API documentation
```

### For Database Changes

```
@architecture-explorer → Understand data model
@migration-helper → Create migrations
@sdk-regenerator → Update SDK
@test-generator → Generate data layer tests
@test-runner → Test migrations
@doc-writer → Document schema changes
```

### For Documentation

```
@architecture-explorer → Understand what to document
@doc-generator → Generate comprehensive docs
@code-reviewer → Review docs accuracy
@doc-writer → Polish and finalize
```

## Decision Tree

```
Task received
  ↓
Is it about existing code?
  ├─ Yes → @architecture-explorer first
  └─ No → Design phase
       ↓
Does it need new tools/agents?
  ├─ Yes → @tool-creator or @agent-creator
  └─ No → Continue
       ↓
Does it touch database?
  ├─ Yes → @migration-helper + @sdk-regenerator
  └─ No → Continue
       ↓
Does it change API?
  ├─ Yes → @api-designer + @sdk-regenerator
  └─ No → Continue
       ↓
Implementation phase
  ↓
Testing phase
  ├─ @test-generator → Generate tests
  ├─ @test-runner → Run tests
  └─ Fix issues and repeat
       ↓
Review phase (ALL of these)
  ├─ @code-reviewer → Quality review
  ├─ @security-auditor → Security review
  └─ @perf-analyzer → Performance review
       ↓
Documentation phase
  └─ @doc-generator or @doc-writer
       ↓
Done
```

## Usage

When given a task:

1. **Analyze the task** - What type is it?
2. **Check the decision tree** - Follow the appropriate path
3. **Identify required skills** - List all skills needed
4. **Determine sequence** - What order makes sense?
5. **Create workflow** - Write out the full skill chain
6. **Execute systematically** - Follow the workflow step by step

## Examples

### Task: "Add user authentication"

**Analysis**:
- Type: New feature
- Areas: Server routes, database, session management
- Complexity: High

**Workflow**:
```
1. @architecture-explorer "How is authentication currently handled?"
2. @security-auditor "Review current security measures"
3. @api-designer "Design authentication API endpoints"
4. @migration-helper "Create user and token tables"
5. @agent-creator "Create auth-agent with security permissions"
6. Implement using @auth-agent
7. @sdk-regenerator "Update SDK with auth endpoints"
8. @test-generator "Generate auth tests"
9. @test-runner "Run auth tests"
10. @security-auditor "Final security audit"
11. @doc-generator "Document authentication system"
```

### Task: "Fix session memory leak"

**Analysis**:
- Type: Bug fix (performance)
- Areas: Session management
- Complexity: Medium

**Workflow**:
```
1. @architecture-explorer "How does session lifecycle work?"
2. @perf-analyzer "Identify memory leak in sessions"
3. @debug-helper "Setup debugging for session cleanup"
4. Debug and fix
5. @test-generator "Add memory leak regression tests"
6. @test-runner "Verify fix"
7. @code-reviewer "Review fix"
```

### Task: "Improve tool execution performance"

**Analysis**:
- Type: Performance optimization
- Areas: Tool registry, execution pipeline
- Complexity: Medium

**Workflow**:
```
1. @architecture-explorer "How does tool execution work?"
2. @perf-analyzer "Profile tool execution pipeline"
3. @refactor-agent "Optimize tool registry and execution"
4. @test-runner "Benchmark performance improvements"
5. @code-reviewer "Review optimizations"
6. @doc-writer "Document performance improvements"
```

## Skill Priority Matrix

When multiple skills could apply, prioritize:

1. **Exploration** (architecture-explorer) - Always first
2. **Planning** (plan agent, workflow-orchestrator) - Before implementation
3. **Creation** (tool-creator, agent-creator) - Create infrastructure
4. **Implementation** (specialized agents) - Build the feature
5. **Testing** (test-generator, test-runner) - Verify functionality
6. **Review** (code-reviewer, security-auditor, perf-analyzer) - Quality gates
7. **Documentation** (doc-generator, doc-writer) - Always last

$ARGUMENTS
