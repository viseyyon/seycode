---
name: test-runner
description: Run tests intelligently based on changes and context
subtask: true
---

# Test Runner

Run tests for the SeyCode codebase following project conventions.

## Critical Rules

1. **NEVER run tests from repo root** - Will fail with guard error
2. **Always run from package directory** like `packages/seycode`
3. **Use timeout flag** - Default is 5s, many tests need more

## Running Tests

### Run all tests in a package
```bash
cd packages/seycode
sey test --timeout 30000
```

### Run specific test file
```bash
cd packages/seycode
sey test test/session.test.ts --timeout 30000
```

### Run tests matching pattern
```bash
cd packages/seycode
sey test --timeout 30000 test/tool/
```

### Run with coverage
```bash
cd packages/seycode
sey test --coverage --timeout 30000
```

## Test Files by Area

Check what exists:
```bash
ls -la packages/seycode/test/
```

Common test areas:
- `test/agent/` - Agent system tests
- `test/tool/` - Tool execution tests
- `test/session/` - Session management tests
- `test/config/` - Configuration tests
- `test/project/` - Project detection tests

## Testing After Changes

**Changed a tool?**
```bash
cd packages/seycode
sey test test/tool/$(basename your-tool).test.ts
```

**Changed server routes?**
```bash
cd packages/seycode
sey test test/server/
```

**Changed agent system?**
```bash
cd packages/seycode
sey test test/agent/
```

## Creating New Tests

Follow testing principles from AGENTS.md:
- ✅ Test actual implementation
- ✅ Use real data and services
- ❌ Avoid mocks unless necessary
- ❌ Don't duplicate logic in tests

Example test structure:
```typescript
import { test, expect } from "bun:test"

test("tool executes correctly", async () => {
  const result = await tool.execute(input, context)
  expect(result).toBeDefined()
})
```

## Current Test Status

Check test status:
```bash
cd packages/seycode
sey test --timeout 30000 2>&1 | tee test-results.txt
```

$ARGUMENTS
