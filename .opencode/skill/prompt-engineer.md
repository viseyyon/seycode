---
name: prompt-engineer
description: Automatically enhance and optimize prompts using advanced prompt engineering techniques
priority: -1000
auto: true
---

# Prompt Engineer

**AUTOMATICALLY INVOKED** - This skill enhances every user prompt before execution using advanced prompt engineering.

## Purpose

SeyCode's unique advantage: Every prompt is automatically optimized for:
- **Clarity** - Remove ambiguity
- **Specificity** - Add concrete details
- **Context** - Include relevant information
- **Structure** - Organize logically
- **Intent** - Make goals explicit
- **Constraints** - Define boundaries

## Prompt Engineering Principles

### 1. **Intent Classification**

First, identify the intent:
- Information seeking → Optimize for comprehensive answers
- Code generation → Optimize for correctness and style
- Debugging → Optimize for root cause analysis
- Refactoring → Optimize for maintainability
- Documentation → Optimize for clarity
- Testing → Optimize for coverage
- Review → Optimize for thoroughness

### 2. **Context Enhancement**

Add missing context:
- Current working directory
- Recent file changes
- Related code patterns
- Project conventions
- Style guide rules
- Available skills and agents

### 3. **Structure Optimization**

Reorganize for clarity:

**Before**: "make this faster"
**After**: "Analyze the performance of [specific code/component], identify bottlenecks using @perf-analyzer, and suggest optimizations following AGENTS.md style guide. Benchmark improvements."

**Before**: "add tests"
**After**: "Generate comprehensive tests for [specific functionality] using @test-generator. Follow AGENTS.md testing principles (avoid mocks, test actual implementation). Run tests with @test-runner to verify coverage."

**Before**: "fix this bug"
**After**: "Investigate [specific bug/error] in [component/file]. Use @architecture-explorer to understand the area, @debug-helper to setup debugging if needed. Identify root cause, implement fix, add regression tests with @test-generator, and verify with @test-runner."

### 4. **Skill Chain Injection**

Automatically suggest appropriate skill chains:

```
User: "I want to add user authentication"

Enhanced:
"Design and implement user authentication system:
1. @architecture-explorer - Understand current auth architecture
2. @security-auditor - Review current security measures
3. @api-designer - Design auth API endpoints
4. @migration-helper - Create user and token tables
5. @agent-creator - Create auth-agent with security permissions
6. Implement authentication logic
7. @sdk-regenerator - Update SDK with auth endpoints
8. @test-generator - Generate auth tests including security tests
9. @test-runner - Run auth tests
10. @security-auditor - Final security audit
11. @doc-generator - Document authentication system"
```

### 5. **Constraint Addition**

Add relevant constraints:

**Before**: "refactor this code"
**After**: "Refactor [specific code] following AGENTS.md style guide (single-word variables, avoid else statements, prefer const, use Bun APIs). Use @refactor-agent. Ensure @test-runner passes all tests. Review with @code-reviewer."

### 6. **Specificity Enhancement**

Make vague prompts specific:

**Before**: "improve performance"
**After**: "Use @perf-analyzer to identify performance bottlenecks in [specific component]. Profile with @debug-helper. Implement optimizations focusing on [database queries | loops | memory | async operations]. Benchmark with @test-runner. Document optimizations with @doc-writer."

### 7. **Quality Gate Injection**

Add quality checkpoints:

Every code change should include:
- `@code-reviewer` - Quality review
- `@security-auditor` - Security review
- `@perf-analyzer` - Performance review
- `@test-runner` - Verification

### 8. **Context Awareness**

Use codebase context:

```
If user mentions "session" → Reference packages/opencode/src/session/
If user mentions "tools" → Reference packages/opencode/src/tool/
If user mentions "agents" → Reference packages/opencode/src/agent/
If user mentions "API" → Reference packages/opencode/src/server/routes/
```

## Prompt Enhancement Template

```
ORIGINAL PROMPT: [user input]

INTENT: [what user wants to achieve]

CONTEXT: [relevant codebase context]

ENHANCED PROMPT:
[Optimized, specific, actionable prompt with:
- Clear goal
- Appropriate skill chain
- Quality gates
- Constraints
- Expected outcome
]

SKILL CHAIN:
1. [skill 1] - [purpose]
2. [skill 2] - [purpose]
...

QUALITY GATES:
- [review/audit/test requirements]

EXPECTED OUTCOME:
[What success looks like]
```

## Examples

### Example 1: Vague Request

**Original**: "make it better"

**Enhanced**:
```
Improve [specific code/feature] by:

1. @architecture-explorer - Understand current implementation
2. @code-reviewer - Identify issues and improvement areas
3. @perf-analyzer - Find performance bottlenecks
4. Implement improvements following AGENTS.md style guide
5. @refactor-agent - Refactor if needed
6. @test-runner - Ensure all tests pass
7. @code-reviewer - Final review
8. @doc-writer - Update documentation

Focus on:
- Code quality (readability, maintainability)
- Performance (speed, memory)
- Style compliance (AGENTS.md)
- Test coverage
```

### Example 2: Incomplete Request

**Original**: "add API endpoint"

**Enhanced**:
```
Design and implement API endpoint for [specific functionality]:

1. @architecture-explorer "How are API routes structured?"
2. @api-designer "Create [METHOD] /api/[path] endpoint:
   - Parameters: [list]
   - Response: [structure]
   - Validation: Zod schema
   - Error handling
   - Following REST conventions"
3. @sdk-regenerator "Update SDK with new endpoint"
4. @test-generator "Generate API tests:
   - Success cases
   - Error cases
   - Edge cases
   - Input validation"
5. @test-runner "Run API tests"
6. @code-reviewer "Review endpoint implementation"
7. @doc-generator "Document API endpoint with examples"

Expected outcome: Production-ready API endpoint with tests and documentation.
```

### Example 3: Security-Critical Request

**Original**: "add login"

**Enhanced**:
```
Implement secure authentication system:

SECURITY REQUIREMENTS:
- Password hashing (bcrypt/argon2)
- JWT tokens with expiration
- Rate limiting
- CSRF protection
- Input validation
- SQL injection prevention

WORKFLOW:
1. @security-auditor "Review current security measures"
2. @architecture-explorer "Understand authentication architecture"
3. @api-designer "Design auth endpoints:
   - POST /api/auth/login
   - POST /api/auth/logout
   - POST /api/auth/refresh
   - GET /api/auth/me"
4. @migration-helper "Create users and sessions tables with proper indexes"
5. Implement authentication with security best practices
6. @sdk-regenerator "Update SDK"
7. @test-generator "Generate tests including security tests:
   - Password validation
   - Token expiration
   - Rate limiting
   - CSRF protection"
8. @test-runner "Run all tests including security tests"
9. @security-auditor "Comprehensive security audit"
10. @perf-analyzer "Check auth performance"
11. @doc-generator "Document authentication with security considerations"

QUALITY GATES:
- Must pass @security-auditor review
- Must have 100% test coverage
- Must handle all error cases
- Must follow OWASP guidelines
```

## Automatic Enhancement Rules

### Rule 1: Always Add Skill Chain
Every prompt should have appropriate skills identified

### Rule 2: Always Add Quality Gates
Every code change needs review, audit, and test

### Rule 3: Always Add Context
Reference relevant files, patterns, and conventions

### Rule 4: Always Add Constraints
Follow AGENTS.md, project conventions, best practices

### Rule 5: Always Add Expected Outcome
Make success criteria explicit

### Rule 6: Always Add Error Handling
What to do if things go wrong

### Rule 7: Always Add Documentation
Update docs when changing code

## Integration with SeyCode

This skill is automatically invoked BEFORE any other skill execution:

```
User Input
    ↓
@prompt-engineer (automatic)
    ↓
Enhanced Prompt
    ↓
@workflow-orchestrator (if needed)
    ↓
Skill Chain Execution
    ↓
Result
```

## Benefits of Automatic Prompt Engineering

1. **Better Results** - Optimized prompts → better outputs
2. **Time Saving** - No need to craft perfect prompts
3. **Consistency** - Every prompt follows best practices
4. **Learning** - Users learn prompt engineering by example
5. **Quality** - Built-in quality gates
6. **Completeness** - Nothing forgotten
7. **Context-Aware** - Uses codebase knowledge

## Prompt Engineering Checklist

For every prompt, ensure:

- [ ] Intent is clear
- [ ] Context is provided
- [ ] Skills are identified
- [ ] Quality gates are present
- [ ] Constraints are specified
- [ ] Expected outcome is defined
- [ ] Error handling is considered
- [ ] Documentation is included
- [ ] Style guide is referenced
- [ ] Tests are required

$ARGUMENTS
