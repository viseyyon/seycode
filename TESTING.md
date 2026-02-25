# Testing Guide

This guide covers testing strategy, infrastructure, and best practices for SeyCode.

## Table of Contents

- [Testing Philosophy](#testing-philosophy)
- [Testing Infrastructure](#testing-infrastructure)
- [Running Tests](#running-tests)
- [Unit Testing](#unit-testing)
- [Integration Testing](#integration-testing)
- [E2E Testing](#e2e-testing)
- [Testing Revolutionary Features](#testing-revolutionary-features)
- [Testing Skills](#testing-skills)
- [Writing Tests](#writing-tests)
- [Test Coverage](#test-coverage)
- [Performance Testing](#performance-testing)
- [Security Testing](#security-testing)
- [CI/CD Testing](#cicd-testing)
- [Troubleshooting Tests](#troubleshooting-tests)

---

## Testing Philosophy

SeyCode follows a pragmatic testing philosophy:

### Core Principles

1. **Avoid Mocks as Much as Possible**
   - Test actual implementation, not mocked behavior
   - Mocks hide bugs and create false confidence
   - Use real databases, real files, real systems

2. **Tests Guard Against Running from Root**
   - NEVER run tests from repository root
   - Tests must run from package directories
   - Enforced with `do-not-run-tests-from-root` check

3. **Test Behavior, Not Implementation**
   - Test what the code does, not how it does it
   - Don't duplicate logic in tests
   - Focus on inputs, outputs, and side effects

4. **Write Tests That Fail for the Right Reasons**
   - Tests should only fail when actual behavior breaks
   - Avoid brittle tests that fail on refactoring
   - Clear error messages

5. **Test the Happy Path AND Edge Cases**
   - Test normal usage first
   - Add edge cases and error conditions
   - Test boundary conditions

---

## Testing Infrastructure

### Test Frameworks

**Unit & Integration Tests:**
- **Bun Test**: Built-in testing framework
  ```bash
  sey test
  ```

**E2E Tests:**
- **Playwright**: Browser automation and testing
  ```bash
  cd packages/app && sey playwright test
  ```

### Test Locations

```
packages/
├── seycode/
│   ├── test/              # Unit & integration tests
│   │   ├── session.test.ts
│   │   ├── tool/
│   │   ├── agent/
│   │   └── ...
│   └── src/              # Source files
│       └── __tests__/    # Co-located tests (optional)
│
├── app/
│   ├── e2e/              # E2E Playwright tests
│   │   ├── session.test.ts
│   │   ├── projects.test.ts
│   │   └── ...
│   └── playwright.config.ts
│
└── [other packages]/
    └── test/             # Package-specific tests
```

### Test Configuration

**Bun Test** (`packages/seycode/`):
- Configuration in `package.json`:
  ```json
  {
    "scripts": {
      "test": "sey test --timeout 30000"
    }
  }
  ```

**Playwright** (`packages/app/playwright.config.ts`):
```typescript
export default defineConfig({
  testDir: './e2e',
  timeout: 30000,
  use: {
    baseURL: 'http://localhost:4096',
    trace: 'on-first-retry',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
  ],
})
```

---

## Running Tests

### ⚠️ CRITICAL: Test Location Rules

**DO NOT run tests from repository root!**

```bash
# ❌ WRONG - Will fail
cd /path/to/seycode
sey test

# ✅ CORRECT - Run from package directory
cd /path/to/seycode/packages/seycode
sey test
```

### Unit & Integration Tests

**Run all tests in a package:**
```bash
cd packages/seycode
sey test --timeout 30000
```

**Run specific test file:**
```bash
cd packages/seycode
sey test test/session.test.ts
```

**Run tests matching pattern:**
```bash
cd packages/seycode
sey test --test-name-pattern="session.*create"
```

**Run with coverage:**
```bash
cd packages/seycode
sey test --coverage
```

**Watch mode:**
```bash
cd packages/seycode
sey test --watch
```

### E2E Tests

**Run all E2E tests:**
```bash
cd packages/app
sey playwright test
```

**Run specific test:**
```bash
cd packages/app
sey playwright test e2e/session.test.ts
```

**Run in headed mode (see browser):**
```bash
cd packages/app
sey playwright test --headed
```

**Run specific browser:**
```bash
cd packages/app
sey playwright test --project=chromium
```

**Debug mode:**
```bash
cd packages/app
sey playwright test --debug
```

**View test report:**
```bash
cd packages/app
sey playwright show-report
```

### All Tests (CI-style)

```bash
# From root, run tests in all packages
bun run test:all

# Or manually:
cd packages/seycode && sey test
cd packages/app && sey playwright test
cd packages/sdk/js && sey test
# ... etc
```

---

## Unit Testing

### Writing Unit Tests

**Basic structure:**
```typescript
import { describe, expect, it, beforeEach, afterEach } from 'bun:test'

describe('SessionManager', () => {
  let manager: SessionManager

  beforeEach(() => {
    manager = new SessionManager()
  })

  afterEach(() => {
    // Cleanup
  })

  it('should create a new session', () => {
    const session = manager.create()
    expect(session.id).toBeDefined()
    expect(session.messages).toHaveLength(0)
  })

  it('should retrieve session by id', () => {
    const session = manager.create()
    const retrieved = manager.get(session.id)
    expect(retrieved).toBe(session)
  })

  it('should throw when session not found', () => {
    expect(() => manager.get('nonexistent')).toThrow()
  })
})
```

### Testing Tools

**Example: Testing the Read tool**

```typescript
import { describe, expect, it } from 'bun:test'
import { ReadTool } from '../src/tool/builtin/read'
import { writeFile, unlink } from 'fs/promises'
import { join } from 'path'

describe('ReadTool', () => {
  const testFile = join(__dirname, 'test.txt')

  beforeEach(async () => {
    await writeFile(testFile, 'Hello\nWorld\n')
  })

  afterEach(async () => {
    await unlink(testFile).catch(() => {})
  })

  it('should read file contents', async () => {
    const result = await ReadTool.execute({
      file_path: testFile
    })

    expect(result.content).toContain('Hello')
    expect(result.content).toContain('World')
  })

  it('should respect line limits', async () => {
    const result = await ReadTool.execute({
      file_path: testFile,
      limit: 1
    })

    expect(result.lines).toHaveLength(1)
  })
})
```

### Testing Agents

**Example: Testing agent permissions**

```typescript
import { describe, expect, it } from 'bun:test'
import { AgentManager } from '../src/agent/manager'

describe('AgentPermissions', () => {
  it('plan agent should deny writes', () => {
    const agent = AgentManager.get('plan')
    expect(agent.canWrite('src/file.ts')).toBe(false)
  })

  it('build agent should allow writes', () => {
    const agent = AgentManager.get('build')
    expect(agent.canWrite('src/file.ts')).toBe(true)
  })

  it('custom agent should respect permissions', () => {
    const agent = AgentManager.create({
      name: 'test-agent',
      permission: {
        write: { 'docs/**': 'allow', '*': 'deny' }
      }
    })

    expect(agent.canWrite('docs/readme.md')).toBe(true)
    expect(agent.canWrite('src/file.ts')).toBe(false)
  })
})
```

---

## Integration Testing

Integration tests verify multiple components working together.

### Testing Session Flow

```typescript
import { describe, expect, it } from 'bun:test'
import { SessionProcessor } from '../src/session/processor'
import { ToolRegistry } from '../src/tool/registry'

describe('Session Integration', () => {
  it('should process message with tool calls', async () => {
    const processor = new SessionProcessor()
    const session = processor.createSession()

    // Add message
    const message = await processor.addMessage(session, {
      role: 'user',
      content: 'Read the file test.txt'
    })

    // Process with LLM (mocked or real)
    await processor.process(session, message)

    // Verify tool was called
    const tools = processor.getToolCalls(message)
    expect(tools).toContain('read')

    // Verify result
    expect(session.messages.length).toBeGreaterThan(1)
  })
})
```

### Testing Storage

```typescript
import { describe, expect, it, beforeEach, afterEach } from 'bun:test'
import { SessionStorage } from '../src/storage/session'
import { rm } from 'fs/promises'

describe('SessionStorage Integration', () => {
  let storage: SessionStorage
  const testDb = './test.db'

  beforeEach(() => {
    storage = new SessionStorage(testDb)
  })

  afterEach(async () => {
    await rm(testDb).catch(() => {})
  })

  it('should persist and retrieve session', async () => {
    const session = { id: 'test-123', messages: [] }

    await storage.save(session)
    const retrieved = await storage.get('test-123')

    expect(retrieved.id).toBe('test-123')
  })
})
```

---

## E2E Testing

E2E tests verify the entire application from user perspective.

### Web UI E2E Tests

**Example: Testing session creation**

```typescript
import { test, expect } from '@playwright/test'

test('create and interact with session', async ({ page }) => {
  await page.goto('/')

  // Create new session
  await page.click('[data-testid="new-session"]')
  await expect(page).toHaveURL(/\/session\/.*/)

  // Send message
  const input = page.locator('[data-testid="prompt-input"]')
  await input.fill('Hello SeyCode')
  await input.press('Enter')

  // Wait for response
  await expect(page.locator('[data-testid="message"]')).toContainText('Hello')

  // Verify message appears
  const messages = page.locator('[data-testid="message"]')
  await expect(messages).toHaveCount(2) // User + assistant
})

test('agent switching', async ({ page }) => {
  await page.goto('/session/test-123')

  // Switch to plan agent
  await page.keyboard.press('Tab')
  await expect(page.locator('[data-testid="current-agent"]')).toContainText('plan')

  // Verify read-only mode
  const input = page.locator('[data-testid="prompt-input"]')
  await input.fill('Write a file')
  await input.press('Enter')

  // Should show permission denied
  await expect(page.locator('[data-testid="error"]')).toContainText('permission')
})
```

### TUI E2E Tests

For TUI testing, use snapshot testing or screen scraping:

```typescript
import { spawn } from 'child_process'
import { expect, test } from 'bun:test'

test('TUI starts and shows prompt', async () => {
  const proc = spawn('seycode', ['--test-mode'])

  let output = ''
  proc.stdout.on('data', (data) => {
    output += data.toString()
  })

  // Wait for TUI to initialize
  await new Promise(resolve => setTimeout(resolve, 1000))

  expect(output).toContain('SeyCode')
  expect(output).toContain('>')

  proc.kill()
})
```

---

## Testing Revolutionary Features

### 1. Testing Automatic Prompt Engineering

**Unit Test:**
```typescript
import { describe, expect, it } from 'bun:test'
import { PromptEngineer } from '../src/skill/prompt-engineer'

describe('Prompt Engineering', () => {
  it('should enhance basic prompt', async () => {
    const input = 'fix this bug'
    const enhanced = await PromptEngineer.enhance(input)

    expect(enhanced).toContain('@debug-helper')
    expect(enhanced).toContain('@test-runner')
    expect(enhanced.length).toBeGreaterThan(input.length)
  })

  it('should add context', async () => {
    const input = 'create a tool'
    const enhanced = await PromptEngineer.enhance(input)

    expect(enhanced).toContain('@tool-creator')
    expect(enhanced).toContain('@architecture-explorer')
  })

  it('should inject quality gates', async () => {
    const input = 'add authentication'
    const enhanced = await PromptEngineer.enhance(input)

    expect(enhanced).toContain('@security-auditor')
    expect(enhanced).toContain('@test-generator')
  })
})
```

**Integration Test:**
```typescript
describe('Prompt Engineering Integration', () => {
  it('should auto-enhance every prompt', async () => {
    const session = createSession()
    const message = 'fix the bug in session.ts'

    const processed = await session.processMessage(message)

    // Verify prompt was enhanced
    expect(processed.enhancedPrompt).toBeDefined()
    expect(processed.enhancedPrompt).not.toBe(message)
    expect(processed.enhancedPrompt).toContain('@')
  })
})
```

### 2. Testing Automatic Memory Management

**Unit Test:**
```typescript
import { describe, expect, it } from 'bun:test'
import { MemoryManager } from '../src/skill/memory-manager'

describe('Memory Management', () => {
  it('should create checkpoint before action', async () => {
    const manager = new MemoryManager()
    const session = createSession()

    await manager.beforeAction(session, 'write-file')

    const checkpoints = await manager.getCheckpoints(session)
    expect(checkpoints.length).toBeGreaterThan(0)
    expect(checkpoints[0].type).toBe('pre-action')
  })

  it('should create checkpoint after action', async () => {
    const manager = new MemoryManager()
    const session = createSession()

    await manager.afterAction(session, 'write-file', { success: true })

    const checkpoints = await manager.getCheckpoints(session)
    const postCheckpoint = checkpoints.find(c => c.type === 'post-action')
    expect(postCheckpoint).toBeDefined()
  })

  it('should rollback to checkpoint', async () => {
    const manager = new MemoryManager()
    const session = createSession()

    // Create checkpoint
    const checkpoint = await manager.checkpoint(session)

    // Make changes
    session.data.modified = true

    // Rollback
    await manager.rollback(session, checkpoint.id)

    expect(session.data.modified).toBeUndefined()
  })
})
```

**Integration Test:**
```typescript
describe('Memory Management Integration', () => {
  it('should auto-checkpoint every action', async () => {
    const session = createSession()
    const file = 'test.txt'

    // Write file (should auto-checkpoint)
    await session.tool('write', { file_path: file, content: 'test' })

    // Verify checkpoint exists
    const checkpoints = await session.getCheckpoints()
    expect(checkpoints.length).toBeGreaterThan(0)

    // Rollback
    await session.rollback()

    // Verify file doesn't exist
    expect(existsSync(file)).toBe(false)
  })
})
```

### 3. Testing Automatic Agent Routing

**Unit Test:**
```typescript
import { describe, expect, it } from 'bun:test'
import { AgentRouter } from '../src/skill/agent-router'

describe('Agent Routing', () => {
  it('should detect security intent', async () => {
    const prompt = 'check this for security issues'
    const intent = await AgentRouter.detectIntent(prompt)

    expect(intent.type).toBe('security-review')
    expect(intent.confidence).toBeGreaterThan(0.8)
  })

  it('should route to security-auditor', async () => {
    const prompt = 'check for vulnerabilities'
    const agent = await AgentRouter.selectAgent(prompt)

    expect(agent).toBe('security-auditor')
  })

  it('should route to test-runner', async () => {
    const prompt = 'run the tests'
    const agent = await AgentRouter.selectAgent(prompt)

    expect(agent).toBe('test-runner')
  })
})
```

### 4. Testing Self-Correction

**Unit Test:**
```typescript
import { describe, expect, it } from 'bun:test'
import { SelfCorrector } from '../src/skill/self-corrector'

describe('Self-Correction', () => {
  it('should detect syntax error', async () => {
    const error = 'SyntaxError: Unexpected token'
    const detected = await SelfCorrector.detectError(error)

    expect(detected.type).toBe('syntax')
    expect(detected.confidence).toBeGreaterThan(0.9)
  })

  it('should apply fix', async () => {
    const error = { type: 'syntax', message: 'Missing semicolon' }
    const fix = await SelfCorrector.getFix(error)

    expect(fix.action).toBe('add-semicolon')
    expect(fix.confidence).toBeGreaterThan(0.8)
  })

  it('should learn from correction', async () => {
    const pattern = { error: 'TypeError', fix: 'add-null-check' }
    await SelfCorrector.learn(pattern)

    const patterns = await SelfCorrector.getPatterns()
    expect(patterns).toContainEqual(expect.objectContaining(pattern))
  })
})
```

### 5. Testing Self-Evolution

**Unit Test:**
```typescript
import { describe, expect, it } from 'bun:test'
import { SelfEvolver } from '../src/skill/self-evolver'

describe('Self-Evolution', () => {
  it('should detect usage pattern', async () => {
    const interactions = [
      { skills: ['security-auditor', 'code-reviewer'] },
      { skills: ['security-auditor', 'code-reviewer'] },
      { skills: ['security-auditor', 'code-reviewer'] }
    ]

    const patterns = await SelfEvolver.analyzePatterns(interactions)
    expect(patterns.length).toBeGreaterThan(0)
    expect(patterns[0].frequency).toBe(3)
  })

  it('should create new skill from pattern', async () => {
    const pattern = {
      skills: ['security-auditor', 'perf-analyzer'],
      frequency: 5,
      confidence: 0.9
    }

    const skill = await SelfEvolver.createSkill(pattern)
    expect(skill.name).toBeDefined()
    expect(skill.content).toContain('@security-auditor')
    expect(skill.content).toContain('@perf-analyzer')
  })
})
```

---

## Testing Skills

Test all 16 skills:

```typescript
describe('Skills', () => {
  // Automatic skills
  test('prompt-engineer enhances prompts', async () => { /* ... */ })
  test('memory-manager creates checkpoints', async () => { /* ... */ })
  test('agent-router selects agents', async () => { /* ... */ })
  test('self-corrector fixes errors', async () => { /* ... */ })
  test('self-evolver discovers patterns', async () => { /* ... */ })

  // Manual skills
  test('workflow-orchestrator plans workflow', async () => { /* ... */ })
  test('tool-creator creates tools', async () => { /* ... */ })
  test('agent-creator creates agents', async () => { /* ... */ })
  test('provider-adder adds providers', async () => { /* ... */ })
  test('test-runner runs tests', async () => { /* ... */ })
  test('debug-helper sets up debugging', async () => { /* ... */ })
  test('sdk-regenerator regenerates SDK', async () => { /* ... */ })
  test('architecture-explorer explores code', async () => { /* ... */ })
  test('migration-creator creates migrations', async () => { /* ... */ })
  test('lsp-configurator configures LSP', async () => { /* ... */ })
  test('doc-generator generates docs', async () => { /* ... */ })
})
```

---

## Writing Tests

### Best Practices

1. **Use Descriptive Names**
   ```typescript
   // ✅ Good
   it('should create checkpoint before write action')

   // ❌ Bad
   it('test1')
   ```

2. **Arrange, Act, Assert (AAA)**
   ```typescript
   it('should enhance prompt', async () => {
     // Arrange
     const input = 'fix bug'
     const enhancer = new PromptEngineer()

     // Act
     const result = await enhancer.enhance(input)

     // Assert
     expect(result).toContain('@debug-helper')
   })
   ```

3. **Test One Thing Per Test**
   ```typescript
   // ✅ Good - tests one thing
   it('should validate prompt length', () => {
     expect(() => validate('')).toThrow()
   })

   it('should validate prompt content', () => {
     expect(() => validate('test')).not.toThrow()
   })

   // ❌ Bad - tests multiple things
   it('should validate prompt', () => {
     expect(() => validate('')).toThrow()
     expect(() => validate('test')).not.toThrow()
     expect(validate('test').length).toBeGreaterThan(0)
   })
   ```

4. **Clean Up After Tests**
   ```typescript
   afterEach(async () => {
     await cleanup()
     await deleteTestFiles()
   })
   ```

5. **Use Test Fixtures**
   ```typescript
   const fixtures = {
     session: () => ({ id: 'test', messages: [] }),
     message: () => ({ role: 'user', content: 'test' })
   }
   ```

---

## Test Coverage

### Measuring Coverage

```bash
cd packages/seycode
sey test --coverage
```

### Coverage Goals

- **Overall**: 80%+ code coverage
- **Critical paths**: 95%+ coverage
- **Revolutionary features**: 100% coverage
- **Tools**: 90%+ coverage
- **Skills**: 85%+ coverage

### Coverage Report

```bash
# Generate HTML report
sey test --coverage --coverage-reporter=html

# Open in browser
open coverage/index.html
```

---

## Performance Testing

### Load Testing

```typescript
import { test, expect } from 'bun:test'

test('handles 100 concurrent sessions', async () => {
  const sessions = Array.from({ length: 100 }, () => createSession())

  const start = Date.now()
  await Promise.all(sessions.map(s => s.process('test message')))
  const duration = Date.now() - start

  expect(duration).toBeLessThan(10000) // < 10 seconds
})
```

### Memory Testing

```typescript
test('memory usage stays bounded', async () => {
  const initial = process.memoryUsage().heapUsed

  // Process 1000 messages
  for (let i = 0; i < 1000; i++) {
    await session.process(`message ${i}`)
  }

  const final = process.memoryUsage().heapUsed
  const increase = (final - initial) / 1024 / 1024 // MB

  expect(increase).toBeLessThan(100) // < 100MB increase
})
```

---

## Security Testing

### Input Validation

```typescript
test('rejects malicious file paths', () => {
  expect(() => readTool('../../../etc/passwd')).toThrow()
  expect(() => readTool('/etc/passwd')).toThrow()
})

test('sanitizes command injection', () => {
  expect(() => bashTool('ls; rm -rf /')).toThrow()
})
```

### Permission Testing

```typescript
test('enforces agent permissions', () => {
  const planAgent = getAgent('plan')
  expect(() => planAgent.write('file.ts')).toThrow('permission denied')
})
```

---

## CI/CD Testing

### GitHub Actions

```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        node: [20]

    steps:
      - uses: actions/checkout@v3
      - uses: oven-sh/setup-bun@v1

      - run: sey install
      - run: cd packages/seycode && sey test
      - run: cd packages/app && sey playwright test
```

---

## Troubleshooting Tests

### Common Issues

**Tests fail with "do not run from root"**
```bash
# Solution: Run from package directory
cd packages/seycode
sey test
```

**Timeout errors**
```bash
# Solution: Increase timeout
sey test --timeout 60000
```

**Database locked errors**
```bash
# Solution: Use unique test databases
const testDb = `test-${Date.now()}.db`
```

**Flaky E2E tests**
```typescript
// Solution: Add proper waits
await expect(element).toBeVisible({ timeout: 10000 })
```

---

## Summary

- **Run tests from package directories, NEVER from root**
- **Avoid mocks, test actual behavior**
- **Test the 5 revolutionary features thoroughly**
- **Maintain 80%+ test coverage**
- **Use Playwright for E2E testing**
- **Write clear, descriptive test names**
- **Clean up after tests**

For questions about testing, see [CONTRIBUTING.md](./CONTRIBUTING.md) or ask in Discord.
