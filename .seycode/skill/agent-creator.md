---
name: agent-creator
description: Create or configure a new agent for SeyCode with custom permissions and settings
---

# Agent Creator

Create or configure an SeyCode agent with specific behaviors and permissions.

## Creating a New Agent

1. **Define agent configuration** in project's `seycode.json`:
   ```json
   {
     "agents": {
       "your-agent": {
         "mode": "subagent",
         "description": "What this agent does",
         "model": "claude-sonnet-4",
         "temperature": 0.7,
         "permission": {
           "read": {
             "*": "allow"
           },
           "write": {
             "*": "deny",
             "docs/**": "allow"
           },
           "bash": {
             "*": "ask"
           }
         }
       }
     }
   }
   ```

2. **Agent modes**:
   - `primary` - Main agent users interact with directly
   - `subagent` - Helper agent invoked by other agents
   - `all` - Can be both primary and subagent

3. **Permission structure**:
   - `allow` - Auto-approve
   - `deny` - Auto-reject
   - `ask` - Prompt user for approval
   - Use glob patterns for path matching

## Common Agent Configurations

**Read-only analyst**:
```json
{
  "analyst": {
    "mode": "subagent",
    "permission": {
      "read": { "*": "allow" },
      "write": { "*": "deny" },
      "edit": { "*": "deny" },
      "bash": { "*": "deny" }
    }
  }
}
```

**Test runner**:
```json
{
  "test-runner": {
    "mode": "subagent",
    "permission": {
      "bash": {
        "cd * && sey test*": "allow",
        "sey test*": "allow",
        "*": "deny"
      }
    }
  }
}
```

**Documentation writer**:
```json
{
  "doc-writer": {
    "mode": "subagent",
    "permission": {
      "read": { "*": "allow" },
      "write": { "docs/**": "allow", "*.md": "allow", "*": "deny" },
      "edit": { "docs/**": "allow", "*.md": "allow", "*": "deny" }
    }
  }
}
```

## Testing Your Agent

1. Load config: Restart SeyCode or use `seycode attach`
2. Test permissions: Try restricted operations
3. Verify model: Check which model is used
4. Test subagent invocation: Use `@your-agent` in messages

## Reference

See `packages/seycode/src/agent/agent.ts` for agent schema and implementation.

$ARGUMENTS
