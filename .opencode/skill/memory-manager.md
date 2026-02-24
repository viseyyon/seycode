---
name: memory-manager
description: Automatic memory management with checkpoint, resume, and rollback capabilities for every action
priority: -999
auto: true
---

# Memory Manager

**AUTOMATICALLY INVOKED** - Creates checkpoints after every significant action, enabling perfect resume and rollback capabilities.

## Purpose

SeyCode's memory management system provides:
- **Automatic Checkpoints** - After every action
- **Resume Capability** - Continue from any checkpoint
- **Rollback Support** - Undo any action or series of actions
- **State Preservation** - Complete context saved
- **History Tracking** - Full audit trail
- **Smart Recovery** - Recover from failures automatically

## Architecture

```
Action Start
    ↓
Create Pre-Checkpoint
    ↓
Execute Action
    ↓
Create Post-Checkpoint
    ↓
Save to Memory Store
    ↓
Continue or Rollback
```

## Checkpoint System

### Checkpoint Structure

```json
{
  "id": "checkpoint-uuid",
  "timestamp": "2026-02-24T14:30:00Z",
  "type": "pre-action" | "post-action" | "milestone",
  "action": {
    "name": "tool-execution | file-edit | command-run",
    "skill": "@tool-creator",
    "agent": "build",
    "input": { /* action input */ },
    "output": { /* action output */ }
  },
  "state": {
    "files": {
      "modified": ["file1.ts", "file2.ts"],
      "created": ["file3.ts"],
      "deleted": ["file4.ts"],
      "snapshots": {
        "file1.ts": "git-hash-or-content"
      }
    },
    "session": {
      "id": "session-uuid",
      "messageCount": 15,
      "context": "current-context-summary"
    },
    "agents": ["build", "code-reviewer"],
    "skills": ["@tool-creator", "@test-runner"],
    "metadata": {
      "tokensUsed": 1500,
      "duration": 2.5,
      "success": true
    }
  },
  "parent": "previous-checkpoint-id",
  "children": ["next-checkpoint-id-1", "next-checkpoint-id-2"]
}
```

### Checkpoint Types

1. **Pre-Action Checkpoints**
   - Created BEFORE any action
   - Captures current state
   - Enables perfect rollback

2. **Post-Action Checkpoints**
   - Created AFTER successful action
   - Captures result state
   - Enables resume from completion

3. **Milestone Checkpoints**
   - Created at major completion points
   - "Tests passing"
   - "Feature complete"
   - "Review approved"

4. **Branch Checkpoints**
   - When trying multiple approaches
   - Parallel exploration paths
   - Easy comparison

## Automatic Checkpoint Creation

### When Checkpoints Are Created

**File Operations**:
```
Before: write, edit, delete
After: successful operation
```

**Tool Execution**:
```
Before: any tool execution
After: tool completion (success or error)
```

**Skill Invocation**:
```
Before: skill starts
After: skill completes
Milestone: skill chain completes
```

**Agent Actions**:
```
Before: agent starts task
After: agent completes task
Milestone: quality gates pass
```

**Session Events**:
```
Before: major session change
After: compaction
Milestone: session archived
```

### Checkpoint Granularity

```
Level 0 (Automatic): Every action
Level 1 (Smart): Significant actions only
Level 2 (Milestone): Major completions only
Level 3 (Manual): User-triggered only
```

Default: Level 0 (Automatic)

## Memory Storage

### Storage Backends

1. **Primary: SQLite**
   ```sql
   CREATE TABLE checkpoints (
     id TEXT PRIMARY KEY,
     timestamp INTEGER NOT NULL,
     type TEXT NOT NULL,
     action_json TEXT NOT NULL,
     state_json TEXT NOT NULL,
     parent_id TEXT,
     metadata_json TEXT,
     FOREIGN KEY (parent_id) REFERENCES checkpoints(id)
   );

   CREATE INDEX idx_timestamp ON checkpoints(timestamp);
   CREATE INDEX idx_parent ON checkpoints(parent_id);
   CREATE INDEX idx_type ON checkpoints(type);
   ```

2. **File Snapshots: Git**
   ```bash
   .seycode/snapshots/
   ├── checkpoint-{id}/
   │   ├── files/
   │   │   ├── file1.ts
   │   │   └── file2.ts
   │   └── metadata.json
   ```

3. **Hot Cache: Memory**
   - Last 10 checkpoints in RAM
   - Fast rollback for recent actions
   - Automatic flush to disk

### Compression

- **Text files**: gzip compression
- **Binary files**: Store git hash only
- **Metadata**: JSON with zstd compression
- **Deduplication**: Content-addressable storage

## Resume Capabilities

### Resume from Checkpoint

```bash
# Resume from specific checkpoint
@memory-manager resume checkpoint-abc123

# Resume from last action
@memory-manager resume last

# Resume from time
@memory-manager resume "2026-02-24 14:30:00"

# Resume from milestone
@memory-manager resume milestone "tests-passing"
```

### What Gets Resumed

- **File state** - All files restored
- **Session context** - Full conversation history
- **Agent state** - Active agents and their context
- **Skill state** - In-progress skill chains
- **Tool state** - Pending tool executions
- **Quality gates** - Pending reviews/audits

### Resume Modes

1. **Exact Resume**
   - Restore exact state
   - Continue from checkpoint

2. **Smart Resume**
   - Restore state
   - Re-evaluate context
   - Skip completed steps

3. **Partial Resume**
   - Restore files only
   - Manual context review
   - User-guided continuation

## Rollback Capabilities

### Rollback Commands

```bash
# Rollback last action
@memory-manager rollback

# Rollback to checkpoint
@memory-manager rollback checkpoint-abc123

# Rollback N actions
@memory-manager rollback 3

# Rollback to milestone
@memory-manager rollback milestone "before-refactor"

# Rollback time range
@memory-manager rollback "last 30 minutes"
```

### What Gets Rolled Back

- ✅ **File changes** - All modifications reverted
- ✅ **Git commits** - Commits reverted (optional)
- ✅ **Database changes** - Migrations rolled back
- ✅ **Session state** - Messages removed
- ✅ **Agent actions** - Undone
- ✅ **Tool executions** - Effects reversed

### Rollback Safety

**Pre-Rollback Checks**:
1. Verify no conflicts with current work
2. Check for dependent changes
3. Warn about data loss
4. Create safety checkpoint

**Rollback Confirmation**:
```
Rolling back to checkpoint-abc123 (2026-02-24 14:30:00)

Will revert:
- 3 file modifications
- 1 file creation
- 2 tool executions
- 5 session messages

Continue? (y/N):
```

**Post-Rollback**:
- Create "rolled-back" checkpoint
- Store rolled-back state for redo
- Update session context
- Notify user of changes

## History & Audit Trail

### View History

```bash
# View all checkpoints
@memory-manager history

# View last N checkpoints
@memory-manager history 10

# View checkpoints for file
@memory-manager history src/tool/mytool.ts

# View checkpoints by agent
@memory-manager history agent:security-auditor

# View checkpoints by time range
@memory-manager history "today"
```

### History Output

```
Checkpoint History (Last 10)
════════════════════════════════════════════════════════════

[checkpoint-abc123] 2026-02-24 14:35:00 (5 minutes ago)
Type: post-action
Action: @tool-creator created src/tool/mytool.ts
Agent: build
Files: 1 created, 2 modified
Status: ✅ Success

[checkpoint-abc122] 2026-02-24 14:34:55 (5 minutes ago)
Type: pre-action
Action: @tool-creator starting
Agent: build
Status: ⏸️ Pre-action

[checkpoint-abc121] 2026-02-24 14:30:00 (10 minutes ago)
Type: milestone
Action: Tests passing
Agent: test-runner
Files: 0 changed
Status: ✅ Milestone

[checkpoint-abc120] 2026-02-24 14:25:00 (15 minutes ago)
Type: post-action
Action: @test-runner executed tests
Agent: test-runner
Files: 0 changed
Status: ❌ Tests failed (rolled back)
```

## Smart Recovery

### Automatic Recovery

When action fails:

```
Action Failed: @tool-creator
Error: File write failed

Auto-Recovery:
1. Checkpoint current failure state
2. Rollback to pre-action checkpoint
3. Analyze error
4. Suggest fixes:
   - Retry with fixes
   - Skip and continue
   - Abort operation
   - Manual intervention

Select option: _
```

### Recovery Strategies

1. **Retry with Fixes**
   - Analyze failure
   - Apply automatic fixes
   - Retry from pre-checkpoint

2. **Skip and Continue**
   - Rollback failed action
   - Continue with next action
   - Mark as skipped

3. **Partial Success**
   - Keep successful parts
   - Rollback failed parts
   - Resume from partial state

4. **Manual Intervention**
   - Pause at checkpoint
   - Allow user fixes
   - Resume when ready

## Branch Management

### Creating Branches

When exploring multiple approaches:

```bash
# Create branch at current checkpoint
@memory-manager branch "try-alternative-approach"

# Work on branch
@tool-creator "alternative implementation"

# Switch branches
@memory-manager switch main
@memory-manager switch "try-alternative-approach"

# Compare branches
@memory-manager compare main "try-alternative-approach"

# Merge branch
@memory-manager merge "try-alternative-approach"
```

### Branch Visualization

```
main: [cp1]─[cp2]─[cp3]─[cp4]─[cp5]
              │
              └─[branch1]─[cp6]─[cp7]
                           │
                           └─[branch2]─[cp8]
```

## Memory Optimization

### Checkpoint Compression

**Immediate Compression**:
- Compress text files
- Deduplicate content
- Store deltas for similar files

**Background Compression**:
- Merge sequential checkpoints
- Compress old checkpoints
- Archive milestone checkpoints

**Storage Limits**:
- Default: 1000 checkpoints
- Configurable per project
- Automatic cleanup of old checkpoints

### Selective Storage

**Always Store**:
- File modifications
- Tool executions
- Session milestones

**Optional Store**:
- Read operations (disabled by default)
- Query operations (disabled by default)
- Transient state (disabled by default)

**Never Store**:
- Sensitive data (credentials, tokens)
- Temporary files
- Cache files

## Configuration

### In seycode.json

```json
{
  "memory": {
    "enabled": true,
    "checkpointLevel": "automatic",
    "storage": {
      "backend": "sqlite",
      "path": ".seycode/memory/",
      "maxCheckpoints": 1000,
      "compression": true
    },
    "retention": {
      "keepLast": 100,
      "keepMilestones": true,
      "keepBranches": true,
      "autoCleanup": true,
      "cleanupAfterDays": 30
    },
    "resume": {
      "autoResume": true,
      "resumeOnStart": false
    },
    "rollback": {
      "confirmBefore": true,
      "createSafetyCheckpoint": true,
      "allowGitRollback": true
    }
  }
}
```

### Environment Variables

```bash
# Enable/disable memory management
export SEYCODE_MEMORY_ENABLED=true

# Checkpoint level
export SEYCODE_CHECKPOINT_LEVEL=automatic

# Storage location
export SEYCODE_MEMORY_PATH=.seycode/memory

# Max checkpoints
export SEYCODE_MAX_CHECKPOINTS=1000
```

## Integration with Skills

### Skill Checkpoints

Skills automatically create checkpoints:

```
@tool-creator starts
  ↓
PRE checkpoint: before-tool-creation
  ↓
Tool created
  ↓
POST checkpoint: after-tool-creation
  ↓
@sdk-regenerator starts
  ↓
PRE checkpoint: before-sdk-regen
  ↓
SDK regenerated
  ↓
POST checkpoint: after-sdk-regen
  ↓
MILESTONE checkpoint: tool-creation-complete
```

### Skill Chain Rollback

```bash
# Rollback entire skill chain
@memory-manager rollback chain "tool-creation"

# This rolls back:
# - Tool creation
# - SDK regeneration
# - Any dependent actions

# Returns to state before chain started
```

## Integration with Agents

### Agent Checkpoints

Agents create checkpoints at key points:

```
@security-auditor starts
  ↓
PRE checkpoint: before-security-audit
  ↓
Code analyzed
  ↓
Vulnerabilities found
  ↓
MILESTONE checkpoint: audit-complete
  ↓
Fixes suggested
  ↓
POST checkpoint: after-suggestions
```

### Agent Rollback

```bash
# Rollback agent actions
@memory-manager rollback agent:security-auditor

# Returns to state before agent started
```

## Best Practices

### When to Create Manual Checkpoints

```bash
# Before major changes
@memory-manager checkpoint "before-major-refactor"

# After successful milestones
@memory-manager checkpoint "v1-complete"

# Before experiments
@memory-manager checkpoint "before-trying-new-approach"

# After quality gates pass
@memory-manager checkpoint "all-tests-passing"
```

### When to Use Branches

- Trying multiple approaches
- Experimental features
- A/B testing implementations
- Parallel development

### When to Rollback

- Failed quality gates
- Broken tests
- Security vulnerabilities found
- Performance regressions
- User request to undo

## Performance

### Checkpoint Creation: <10ms
- Async operation
- Non-blocking
- Background compression

### Resume: <100ms
- Hot cache lookup
- Lazy file loading
- Incremental restore

### Rollback: <500ms
- File restoration
- State update
- Context refresh

### History Query: <50ms
- Indexed lookups
- Cached results
- Fast pagination

## Monitoring

### Memory Usage

```bash
# Check memory usage
@memory-manager stats

Output:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Memory Manager Statistics
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Checkpoints:
  Total: 847
  Today: 156
  Last Hour: 23

Storage:
  Database: 45.2 MB
  Snapshots: 123.8 MB
  Total: 169.0 MB
  Compressed: 58.3% savings

Performance:
  Avg Checkpoint Time: 7ms
  Avg Resume Time: 85ms
  Avg Rollback Time: 340ms

Branches:
  Active: 2
  Archived: 5
```

## Error Handling

### Checkpoint Failure

If checkpoint creation fails:
1. Log error
2. Continue operation (non-blocking)
3. Retry in background
4. Alert if persistent

### Resume Failure

If resume fails:
1. Try previous checkpoint
2. Try milestone checkpoint
3. Partial resume
4. Manual intervention

### Rollback Failure

If rollback fails:
1. Create emergency checkpoint
2. Try partial rollback
3. Restore from backup
4. Manual recovery

$ARGUMENTS
