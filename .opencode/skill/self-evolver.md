---
name: self-evolver
description: Continuous learning and evolution system that improves skills, workflows, and performance over time
priority: -996
auto: true
---

# Self-Evolver

**AUTOMATICALLY INVOKED** - Learns from usage patterns, creates new skills, optimizes workflows, and evolves continuously.

## Purpose

SeyCode's self-evolution system provides:
- **Pattern Discovery** - Identifies recurring patterns in usage
- **Skill Creation** - Automatically creates new skills from patterns
- **Workflow Optimization** - Improves existing workflows
- **User Adaptation** - Adapts to individual user preferences
- **Performance Improvement** - Optimizes for speed and efficiency
- **Continuous Learning** - Gets smarter with every interaction

## Architecture

```
Usage Tracking
    ↓
Pattern Analysis
    ↓
Identify Improvements
    ↓
Generate Solutions
    ↓
Test & Validate
    ↓
Deploy Improvement
    ↓
Monitor Results
    ↓
Learn & Iterate
```

## Pattern Discovery System

### Usage Tracking

**What Gets Tracked**:
```json
{
  "interaction": {
    "id": "interaction-uuid",
    "timestamp": "2026-02-24T15:00:00Z",
    "user": "user-id",
    "prompt": "original prompt",
    "optimizedPrompt": "optimized prompt",
    "agents": ["security-auditor", "code-reviewer"],
    "skills": ["@tool-creator", "@test-runner"],
    "toolsUsed": ["read", "write", "bash"],
    "outcome": "success",
    "duration": 12.5,
    "tokensUsed": 2500,
    "corrections": 1,
    "rollbacks": 0
  }
}
```

**Storage**: `.seycode/learning/interactions/`

### Pattern Analysis

**Pattern Types**:

**1. Recurring Task Patterns**
```
Pattern: User frequently runs security audit + code review
Frequency: 47 times in last 30 days
Suggestion: Create combined "full-review" skill
```

**2. Workflow Patterns**
```
Pattern: User always does @tool-creator → @sdk-regenerator → @test-runner
Frequency: 23 times
Suggestion: Auto-chain these skills
```

**3. Error Patterns**
```
Pattern: User often forgets to run tests after code changes
Frequency: 15 times (tests failed later)
Suggestion: Auto-run tests after code changes
```

**4. Preference Patterns**
```
Pattern: User prefers @perf-analyzer over @code-reviewer for performance issues
Frequency: 89% preference rate
Suggestion: Update routing confidence
```

**5. Time Patterns**
```
Pattern: Database operations slower at 2PM-4PM
Frequency: Consistent over 14 days
Suggestion: Cache more aggressively during those hours
```

### Pattern Detection Algorithm

```typescript
interface Pattern {
  id: string
  type: 'task' | 'workflow' | 'error' | 'preference' | 'time'
  description: string
  frequency: number
  confidence: number
  impact: 'high' | 'medium' | 'low'
  suggestion: string
  action: 'create-skill' | 'optimize-workflow' | 'update-routing' | 'auto-chain'
}

function detectPatterns(interactions: Interaction[]): Pattern[] {
  // 1. Group similar interactions
  const groups = groupSimilar(interactions)

  // 2. Identify recurring patterns (frequency > 3)
  const recurring = groups.filter(g => g.length > 3)

  // 3. Calculate confidence (frequency × consistency)
  const patterns = recurring.map(calculateConfidence)

  // 4. Rank by impact
  const ranked = patterns.sort(byImpact)

  // 5. Generate suggestions
  return ranked.map(generateSuggestion)
}
```

## Automatic Skill Creation

### When Skills Are Created

**Criteria for New Skill**:
1. Pattern occurs 5+ times
2. Pattern confidence > 0.8
3. Pattern saves > 5 minutes
4. Pattern not covered by existing skill

**Creation Process**:
```
1. Detect recurring pattern
   ↓
2. Analyze pattern components
   ↓
3. Generate skill specification
   ↓
4. Create skill file
   ↓
5. Test skill
   ↓
6. Deploy skill
   ↓
7. Monitor usage
   ↓
8. Improve based on feedback
```

### Example: Auto-Generated Skill

**Pattern Detected**:
```
User frequently:
1. Runs @security-auditor
2. Runs @perf-analyzer
3. Runs @code-reviewer
All together for PRs

Frequency: 34 times
Confidence: 0.92
Time per execution: 8 minutes
Total time: 272 minutes
```

**Generated Skill**:
```markdown
---
name: pr-review
description: Complete PR review (security + performance + code quality)
auto-generated: true
created: 2026-02-24
pattern-id: pattern-review-combo
---

# PR Review

Complete pull request review combining security, performance, and code quality checks.

## Process

1. @security-auditor
   - Check for vulnerabilities
   - Verify auth/permissions
   - Check for injection risks

2. @perf-analyzer (parallel)
   - Identify bottlenecks
   - Check for N+1 queries
   - Memory leaks

3. @code-reviewer (parallel)
   - Code quality
   - Style compliance
   - Best practices

4. Combine results
   - Prioritize by severity
   - Generate report
   - Suggest fixes

$ARGUMENTS
```

**Deployment**:
```
Skill created: .opencode/skill/pr-review.md
Registered: seycode.json
Available: @pr-review
Usage: Automatic (pattern-based)
```

## Workflow Optimization

### Optimization Types

**1. Skill Chaining**
```
Before:
User: @tool-creator
User: @sdk-regenerator
User: @test-runner

After (Optimized):
User: @tool-creator
System: Auto-chains → @sdk-regenerator → @test-runner
```

**2. Parallel Execution**
```
Before (Sequential):
@security-auditor (5s)
  ↓
@perf-analyzer (4s)
  ↓
@code-reviewer (3s)
Total: 12s

After (Parallel):
┌─ @security-auditor (5s)
├─ @perf-analyzer (4s)
└─ @code-reviewer (3s)
Total: 5s (60% faster)
```

**3. Caching**
```
Before:
Every @architecture-explorer reads entire codebase

After:
First read: Full scan (10s)
Subsequent: Use cache (0.5s)
Cache invalidation: On file changes
```

**4. Pre-emptive Execution**
```
Pattern: User always runs @test-runner after code changes

Optimization: Start test-runner in background after detecting code change

Result: Tests ready when user needs them
```

### Optimization Metrics

```typescript
interface Optimization {
  id: string
  type: 'chaining' | 'parallel' | 'caching' | 'pre-emptive'
  before: {
    time: number
    steps: number
    userActions: number
  }
  after: {
    time: number
    steps: number
    userActions: number
  }
  improvement: {
    timeReduction: number // percentage
    stepReduction: number
    actionReduction: number
  }
  status: 'proposed' | 'testing' | 'deployed' | 'monitoring'
}
```

## User Adaptation System

### Preference Learning

**What Gets Learned**:

**1. Agent Preferences**
```
User chooses @perf-analyzer over @code-reviewer for "slow" issues
→ Update routing: "slow" → @perf-analyzer (confidence 0.95)
```

**2. Skill Preferences**
```
User always skips @doc-generator
→ Ask: "Disable auto-documentation?" or lower priority
```

**3. Style Preferences**
```
User consistently changes generated code style
→ Learn style patterns
→ Apply to future generations
```

**4. Workflow Preferences**
```
User prefers sequential over parallel for complex tasks
→ Update execution strategy
```

**5. Communication Preferences**
```
User prefers detailed explanations
→ Increase verbosity
→ Add more context
```

### Adaptation Process

```
1. Observe user behavior
   ↓
2. Identify deviations from defaults
   ↓
3. Check consistency (3+ occurrences)
   ↓
4. Create preference rule
   ↓
5. Apply in future interactions
   ↓
6. Monitor satisfaction
   ↓
7. Refine rule
```

### Personalization

**Per-User Settings** (Auto-Learned):
```json
{
  "user": "user-123",
  "preferences": {
    "agents": {
      "security-auditor": { "priority": "high", "autoRun": true },
      "doc-writer": { "priority": "low", "autoRun": false }
    },
    "verbosity": "detailed",
    "executionStyle": "parallel-preferred",
    "reviewStyle": "thorough",
    "codeStyle": {
      "semicolons": true,
      "quotes": "single",
      "indentation": 2
    }
  },
  "learned": "2026-02-24T15:00:00Z",
  "confidence": 0.87
}
```

## Performance Optimization

### Optimization Areas

**1. LLM Call Reduction**
```
Before: Every prompt goes to LLM
After: Cache common patterns
Result: 40% fewer LLM calls
```

**2. Tool Execution Optimization**
```
Before: Execute all tools sequentially
After: Batch similar operations
Result: 30% faster execution
```

**3. Database Query Optimization**
```
Detected: N+1 query pattern in session loading
Optimization: Add eager loading
Result: 70% faster session loads
```

**4. Memory Usage Optimization**
```
Detected: Large checkpoint files
Optimization: Compress + deduplicate
Result: 60% less storage
```

### Performance Monitoring

```typescript
interface PerformanceMetrics {
  operation: string
  avgDuration: number
  p50: number
  p95: number
  p99: number
  trend: 'improving' | 'stable' | 'degrading'
  optimizationOpportunity: boolean
  suggestedOptimization?: string
}
```

## Continuous Learning System

### Learning Domains

**1. Error Patterns** (via Self-Corrector)
```
Learn: What errors occur frequently
Learn: What fixes work best
Apply: Auto-correction patterns
```

**2. Success Patterns**
```
Learn: What workflows succeed
Learn: What agent combinations work well
Apply: Optimize routing and chaining
```

**3. User Patterns**
```
Learn: How users work
Learn: What they prefer
Apply: Personalization
```

**4. Code Patterns**
```
Learn: Common code structures
Learn: Project conventions
Apply: Better code generation
```

**5. Performance Patterns**
```
Learn: What's slow
Learn: What optimizations work
Apply: Automatic optimization
```

### Learning Metrics

```bash
@self-evolver stats

Output:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Self-Evolution Statistics
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Patterns Discovered:
  Total: 234
  High Impact: 45
  Medium Impact: 123
  Low Impact: 66

Skills Created:
  Auto-Generated: 12
  Active: 9
  Testing: 2
  Deprecated: 1

Optimizations:
  Workflow: 34 (avg 45% faster)
  Caching: 23 (avg 80% faster)
  Parallel: 18 (avg 60% faster)
  Pre-emptive: 8 (avg 90% faster)

User Adaptation:
  Preferences Learned: 67
  Confidence Avg: 0.84
  Satisfaction: 94%

Performance:
  Avg Response Time: -35% (improvement)
  LLM Calls: -40% (reduction)
  Cache Hit Rate: 78%
  Total Time Saved: 47.2 hours
```

## Evolution Examples

### Example 1: New Skill from Pattern

**Week 1**: User manually runs security + performance checks
**Week 2**: Pattern detected (frequency: 12)
**Week 3**: Skill auto-generated: `@security-perf-check`
**Week 4**: User adopts skill, saves 8 min per use
**Week 5**: Skill improved based on usage

### Example 2: Workflow Optimization

**Before**:
```
User workflow:
1. Edit code (manual)
2. @test-runner
3. Often forgets → tests fail later
```

**Pattern Detected**:
```
Tests forgotten: 15 times
Impact: High (broken code pushed)
Confidence: 0.89
```

**Optimization**:
```
Auto-trigger @test-runner after code edits
Ask user: "Run tests now? (recommended)"
Default: Yes
```

**Result**:
```
Tests forgotten: 0 times
User satisfaction: High
Time saved: 2 hours debugging
```

### Example 3: Performance Improvement

**Detected**:
```
@architecture-explorer slow (8s avg)
Frequency: 50 uses/day
Total time: 400s/day = 6.7 min/day
```

**Analysis**:
```
Reading same files multiple times
No caching
Parsing on every call
```

**Optimization**:
```
Implement caching layer
Cache parsed AST
Invalidate on file change
```

**Result**:
```
@architecture-explorer: 0.8s avg (90% faster)
Daily time saved: 6 min
Monthly time saved: 3 hours
```

### Example 4: User Adaptation

**Observed**:
```
User always adds detailed comments
User prefers verbose explanations
User likes step-by-step breakdowns
```

**Adaptation**:
```
Increase default verbosity for this user
Add more explanatory comments
Provide step-by-step in responses
```

**Result**:
```
User satisfaction: +15%
Manual edits: -40%
Efficiency: +25%
```

## Skill Evolution

### Skill Improvement Process

**1. Usage Monitoring**
```
Track: How often skill is used
Track: Success rate
Track: User modifications
Track: Time to execute
```

**2. Feedback Collection**
```
Implicit: User keeps/modifies output
Explicit: User rates skill
Corrections: What users change
Abandonment: Skills user stops using
```

**3. Improvement Generation**
```
Analyze feedback
Identify improvement areas
Generate improved version
Test improvements
```

**4. Deployment**
```
A/B test new version
Monitor results
Full deployment if better
Rollback if worse
```

### Skill Versioning

```
skill-name.md
  ├─ v1.0.0 - Initial (manual)
  ├─ v1.1.0 - Improved (auto, +15% success)
  ├─ v1.2.0 - Optimized (auto, +20% faster)
  └─ v2.0.0 - Rewritten (auto, +40% better)
```

## A/B Testing System

### Testing New Improvements

**Process**:
```
1. Generate improvement
   ↓
2. Create test variant (B)
   ↓
3. Split traffic: 90% current (A), 10% new (B)
   ↓
4. Monitor metrics
   ↓
5. Compare results after 100 uses
   ↓
6. If B > A: Deploy B
   If A > B: Keep A
```

**Metrics Compared**:
- Success rate
- Execution time
- User satisfaction
- Error rate
- Manual modifications needed

## Configuration

```json
{
  "selfEvolution": {
    "enabled": true,
    "learning": {
      "enabled": true,
      "minPatternOccurrences": 5,
      "confidenceThreshold": 0.8
    },
    "skillCreation": {
      "enabled": true,
      "requireApproval": false,
      "testingPeriod": 7
    },
    "optimization": {
      "enabled": true,
      "aggressiveness": "medium",
      "abTesting": true
    },
    "userAdaptation": {
      "enabled": true,
      "learningRate": 0.3,
      "requireConsent": false
    },
    "storage": {
      "path": ".seycode/learning/",
      "retention": 90
    }
  }
}
```

## Integration with Other Systems

### With Self-Corrector
```
Self-Corrector: Fixes immediate errors
Self-Evolver: Learns to prevent errors
Result: Fewer errors over time
```

### With Memory Manager
```
Memory Manager: Records all actions
Self-Evolver: Analyzes recorded actions
Result: Better pattern detection
```

### With Agent Router
```
Agent Router: Routes based on confidence
Self-Evolver: Improves routing over time
Result: Better routing accuracy
```

### With Prompt Engineer
```
Prompt Engineer: Optimizes prompts
Self-Evolver: Learns what optimizations work
Result: Better prompt optimization
```

## Benefits

1. **Continuous Improvement** - Gets better every day
2. **Personalization** - Adapts to each user
3. **Efficiency Gains** - Automatic optimization
4. **New Capabilities** - Creates new skills automatically
5. **Error Prevention** - Learns to avoid mistakes
6. **Time Savings** - Compounds over time
7. **Intelligence** - True learning system

## Evolution Timeline

**Week 1**: Baseline (no learning)
**Week 2**: Pattern detection begins
**Week 3**: First optimizations applied
**Week 4**: First auto-generated skill
**Month 2**: 5+ new skills, 20+ optimizations
**Month 3**: 50% time savings, 90% success rate
**Month 6**: Fully adapted, highly personalized
**Year 1**: 10x improvement from baseline

$ARGUMENTS
