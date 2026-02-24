---
name: self-corrector
description: Automatic error detection and correction system that learns from mistakes and improves over time
priority: -997
auto: true
---

# Self-Corrector

**AUTOMATICALLY INVOKED** - Detects errors, automatically corrects them, and learns from mistakes.

## Purpose

SeyCode's self-correcting system provides:
- **Automatic Error Detection** - Catches errors immediately
- **Automatic Correction** - Fixes errors without manual intervention
- **Learning from Mistakes** - Never makes the same mistake twice
- **Pattern Recognition** - Identifies common error patterns
- **Validation Loops** - Verifies corrections work
- **Confidence Scoring** - Knows when to ask for help

## Architecture

```
Action Execution
    ↓
Error Detection
    ↓
Is Error Correctable?
    ├─ Yes → Attempt Correction
    │         ↓
    │      Apply Fix
    │         ↓
    │      Validate
    │         ↓
    │      Success? → Learn Pattern
    │         ↓
    │      Retry Original Action
    │
    └─ No → Rollback + Ask User
```

## Error Detection System

### Automatic Error Detection

**When Errors Are Detected**:
1. **During Execution** - Tool failures, command errors
2. **After Execution** - Test failures, validation errors
3. **Quality Gates** - Review failures, audit failures
4. **Build/Compile** - Syntax errors, type errors
5. **Runtime** - Exceptions, crashes

**Detection Methods**:
```typescript
interface ErrorDetection {
  source: 'tool' | 'test' | 'quality-gate' | 'build' | 'runtime'
  type: 'syntax' | 'type' | 'logic' | 'permission' | 'resource'
  severity: 'critical' | 'high' | 'medium' | 'low'
  correctable: boolean
  confidence: number // 0.0 to 1.0
  patterns: string[] // Matched error patterns
}
```

### Error Classification

**Class 1: Syntax Errors** (High Correctability)
```
Error: Missing semicolon
Confidence: 0.95
Correction: Add semicolon
Validation: TypeScript compile
```

**Class 2: Type Errors** (High Correctability)
```
Error: Type 'string' not assignable to 'number'
Confidence: 0.90
Correction: Add type conversion or fix type
Validation: TypeScript typecheck
```

**Class 3: Logic Errors** (Medium Correctability)
```
Error: Null pointer exception
Confidence: 0.70
Correction: Add null check
Validation: Run tests
```

**Class 4: Permission Errors** (High Correctability)
```
Error: Permission denied
Confidence: 0.95
Correction: Request permission or use different path
Validation: Retry operation
```

**Class 5: Resource Errors** (Medium Correctability)
```
Error: File not found
Confidence: 0.80
Correction: Create file or fix path
Validation: Check file exists
```

## Automatic Correction System

### Correction Strategies

**Strategy 1: Pattern-Based Correction**
```
If error matches known pattern:
  → Apply known fix
  → Validate fix
  → If valid, continue
  → If invalid, try next strategy
```

**Strategy 2: LLM-Assisted Correction**
```
If error is new or complex:
  → Analyze error with LLM
  → Generate fix suggestions
  → Apply most confident fix
  → Validate fix
  → Learn pattern for future
```

**Strategy 3: Rollback and Retry**
```
If correction fails:
  → Rollback to pre-error checkpoint
  → Try alternative approach
  → If alternative succeeds, learn pattern
  → If alternative fails, escalate to user
```

**Strategy 4: Ask User**
```
If confidence < threshold:
  → Checkpoint current state
  → Present error and suggestions
  → Wait for user guidance
  → Apply user's solution
  → Learn pattern for future
```

### Correction Confidence Levels

**Confidence 0.9-1.0: Auto-Fix**
- Apply correction automatically
- Notify user after fix
- Continue execution

**Confidence 0.7-0.9: Fix with Confirmation**
- Apply correction
- Show what was fixed
- User can rollback if needed

**Confidence 0.5-0.7: Suggest Fix**
- Show suggested fixes
- Ask user to confirm
- Apply after confirmation

**Confidence 0.0-0.5: Escalate**
- Cannot auto-correct
- Show error details
- Request user intervention

## Learning System

### Pattern Database

**Structure**:
```json
{
  "patterns": [
    {
      "id": "pattern-001",
      "errorPattern": "TypeError: Cannot read property 'X' of undefined",
      "correction": "Add null check: if (obj?.X)",
      "successRate": 0.95,
      "timesUsed": 47,
      "lastUsed": "2026-02-24T15:00:00Z",
      "contexts": ["javascript", "typescript"],
      "examples": [
        {
          "error": "Cannot read property 'name' of undefined",
          "fix": "if (user?.name)",
          "validation": "tests-passed"
        }
      ]
    }
  ]
}
```

**Storage**: `.seycode/learning/error-patterns.json`

### Learning Process

**Step 1: Error Occurs**
```
Error detected → Extract features → Search pattern database
```

**Step 2: Correction Applied**
```
Apply fix → Validate → Record outcome
```

**Step 3: Pattern Update**
```
If correction succeeded:
  → Update success rate
  → Increment usage count
  → Add example
  → Strengthen pattern

If correction failed:
  → Decrease confidence
  → Mark pattern as unreliable
  → Try alternative
```

**Step 4: New Pattern Creation**
```
If no pattern matched:
  → Create new pattern
  → Set initial confidence
  → Monitor future occurrences
  → Strengthen or weaken based on results
```

### Learning Metrics

**Pattern Effectiveness**:
```
Success Rate = Successful Fixes / Total Attempts
Confidence = Success Rate × Context Relevance × Recency

Update Formula:
New Confidence = (Old Confidence × 0.7) + (Latest Result × 0.3)
```

**Pattern Decay**:
```
If pattern unused for 30 days:
  → Reduce confidence by 10%

If pattern fails 3 times in a row:
  → Mark as unreliable
  → Reduce confidence by 50%
```

## Validation System

### Validation Levels

**Level 1: Syntax Validation**
```bash
# For code fixes
tsc --noEmit  # TypeScript
eslint        # Linting
```

**Level 2: Type Validation**
```bash
# Type checking
bun typecheck
```

**Level 3: Test Validation**
```bash
# Run tests
cd packages/opencode && bun test
```

**Level 4: Quality Gate Validation**
```bash
# Security, performance, code review
@security-auditor
@perf-analyzer
@code-reviewer
```

**Level 5: Integration Validation**
```bash
# End-to-end validation
@test-runner --e2e
```

### Validation Strategy

```
After Correction:
  ↓
Level 1 (Syntax) → Pass? → Continue : Rollback
  ↓
Level 2 (Types) → Pass? → Continue : Rollback
  ↓
Level 3 (Tests) → Pass? → Continue : Rollback
  ↓
Level 4 (Quality) → Pass? → Continue : Rollback
  ↓
Success - Learn Pattern
```

## Correction Examples

### Example 1: Syntax Error

**Error**:
```
SyntaxError: Unexpected token 'const'
File: src/tool.ts:45
```

**Detection**:
```
Source: TypeScript compiler
Type: Syntax error
Severity: High
Correctable: Yes
Confidence: 0.95
```

**Correction**:
```
Pattern matched: "Missing semicolon on previous line"
Fix: Add semicolon at line 44
Validation: TypeScript compile → Success
Outcome: Auto-fixed, pattern reinforced
```

### Example 2: Type Error

**Error**:
```
TypeError: Type 'string' is not assignable to type 'number'
File: src/api.ts:123
Variable: userId
```

**Detection**:
```
Source: TypeScript
Type: Type error
Severity: High
Correctable: Yes
Confidence: 0.90
```

**Correction**:
```
Pattern matched: "String to number conversion needed"
Fix: Change 'userId' to 'Number(userId)'
Validation: TypeScript typecheck → Success
Outcome: Auto-fixed, pattern reinforced
```

### Example 3: Logic Error

**Error**:
```
TypeError: Cannot read property 'name' of undefined
File: src/session.ts:78
```

**Detection**:
```
Source: Runtime
Type: Logic error (null pointer)
Severity: High
Correctable: Yes
Confidence: 0.85
```

**Correction**:
```
Pattern matched: "Missing null check"
Fix: Change 'user.name' to 'user?.name'
Validation: Run tests → Success
Outcome: Auto-fixed, pattern reinforced
```

### Example 4: Test Failure

**Error**:
```
Test Failed: "should create tool correctly"
Expected: { id: 'test', name: 'Test Tool' }
Received: { id: 'test' }
File: test/tool.test.ts:45
```

**Detection**:
```
Source: Test runner
Type: Logic error
Severity: High
Correctable: Yes
Confidence: 0.75
```

**Correction**:
```
Analysis: Tool creation missing 'name' field
Fix: Add 'name' field to tool creation
Validation: Re-run tests → Success
Outcome: Auto-fixed, learned new pattern
```

### Example 5: Permission Error

**Error**:
```
Error: EACCES: permission denied, open '/root/file.txt'
```

**Detection**:
```
Source: File system
Type: Permission error
Severity: High
Correctable: Yes
Confidence: 0.90
```

**Correction**:
```
Pattern matched: "Permission denied"
Options:
1. Use allowed path: .seycode/file.txt
2. Request permission from user
3. Use different approach

Selected: Option 1 (highest confidence)
Validation: File write → Success
Outcome: Auto-fixed, pattern reinforced
```

## Self-Correction Loop

### The Correction Loop

```
1. Execute Action
   ↓
2. Error? → Yes → Detect & Classify
   ↓
3. Search Pattern Database
   ↓
4. Match Found?
   ├─ Yes → Apply Known Fix
   │         ↓
   │      Validate Fix
   │         ↓
   │      Success?
   │         ├─ Yes → Reinforce Pattern → Continue
   │         └─ No → Try Alternative
   │
   └─ No → Analyze with LLM
            ↓
         Generate Fix
            ↓
         Apply Fix
            ↓
         Validate
            ↓
         Success?
            ├─ Yes → Create New Pattern → Continue
            └─ No → Rollback → Escalate to User
```

### Maximum Correction Attempts

**Configuration**:
```json
{
  "selfCorrection": {
    "maxAttempts": 3,
    "confidenceThreshold": 0.7,
    "escalateAfter": 2,
    "autoFixEnabled": true
  }
}
```

**Behavior**:
```
Attempt 1: Try highest confidence fix
  ↓ Failed
Attempt 2: Try alternative fix
  ↓ Failed
Attempt 3: Analyze with LLM, try generated fix
  ↓ Failed
Escalate: Rollback + Ask user
```

## Integration with Memory Manager

**Checkpoint Integration**:
```
Before Correction Attempt:
  → Create checkpoint

After Successful Correction:
  → Keep checkpoint as "auto-corrected"

After Failed Correction:
  → Rollback to checkpoint
  → Try alternative
```

## Integration with Agent Router

**Error-Specific Routing**:
```
Security Error → @security-auditor
Performance Error → @perf-analyzer
Test Error → @test-generator + @test-runner
Code Quality Error → @code-reviewer
```

## Statistics and Monitoring

### Correction Statistics

```bash
@self-corrector stats

Output:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Self-Correction Statistics
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Corrections:
  Total: 1,247
  Successful: 1,156 (92.7%)
  Failed: 91 (7.3%)

Patterns:
  Total Patterns: 156
  High Confidence (>0.9): 89
  Medium Confidence (0.7-0.9): 45
  Low Confidence (<0.7): 22

Performance:
  Avg Correction Time: 1.2s
  Avg Validation Time: 3.5s
  Total Time Saved: 18.4 hours

Top Patterns:
  1. Null check missing (0.95) - 234 uses
  2. Type conversion (0.93) - 187 uses
  3. Missing semicolon (0.96) - 156 uses
  4. Import not found (0.91) - 134 uses
  5. Permission denied (0.94) - 98 uses
```

## Configuration

```json
{
  "selfCorrection": {
    "enabled": true,
    "automatic": true,
    "confidenceThreshold": 0.7,
    "maxAttempts": 3,
    "validation": {
      "syntax": true,
      "types": true,
      "tests": true,
      "qualityGates": false
    },
    "learning": {
      "enabled": true,
      "storePath": ".seycode/learning/",
      "patternDecay": true,
      "decayDays": 30
    },
    "escalation": {
      "escalateAfter": 2,
      "rollbackOnFailure": true,
      "notifyUser": true
    }
  }
}
```

## Benefits

1. **Zero Downtime** - Errors fixed automatically
2. **Continuous Learning** - Gets better over time
3. **Pattern Recognition** - Never makes same mistake twice
4. **Time Savings** - No manual error fixing
5. **Higher Quality** - Fewer bugs reach production
6. **User-Friendly** - Works silently in background
7. **Confidence-Based** - Only fixes when confident

## Error Recovery Examples

### Recovery from Test Failure

```
Test fails → @self-corrector detects
  ↓
Analyzes failure reason
  ↓
Generates fix
  ↓
Applies fix
  ↓
Re-runs tests → Success
  ↓
Learns pattern for future
```

### Recovery from Build Failure

```
Build fails → @self-corrector detects
  ↓
Identifies syntax/type errors
  ↓
Applies known fixes
  ↓
Validates with tsc
  ↓
Build succeeds
  ↓
Continues execution
```

### Recovery from Quality Gate Failure

```
@security-auditor finds vulnerability
  ↓
@self-corrector analyzes
  ↓
Applies security fix
  ↓
Re-runs @security-auditor → Pass
  ↓
Continues workflow
```

$ARGUMENTS
