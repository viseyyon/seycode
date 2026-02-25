---
name: debug-helper
description: Set up debugging for SeyCode server, TUI, or specific components
---

# Debug Helper

Set up debugging for SeyCode development with proper breakpoint support.

## Quick Debug Commands

### Debug Server (Recommended Method)
```bash
# Terminal 1: Start server with debugger
bun run --inspect=ws://localhost:6499/ --cwd packages/seycode ./src/index.ts serve --port 4096

# Terminal 2: Attach TUI
seycode attach http://localhost:4096
```

### Debug with Spawn (Avoid Worker Thread Issues)
```bash
sey dev spawn
```

### Debug TUI Separately
```bash
bun run --inspect=ws://localhost:6499/ --cwd packages/seycode --conditions=browser ./src/index.ts
```

## Environment Setup

Set persistent debug URL:
```bash
export BUN_OPTIONS=--inspect=ws://localhost:6499/
```

Add to your shell profile (`.zshrc`, `.bashrc`):
```bash
# SeyCode debugging
alias seycode-debug='bun run --inspect=ws://localhost:6499/ --cwd packages/seycode ./src/index.ts'
```

## VSCode Debugging

1. Copy example configs:
```bash
cp .vscode/settings.example.json .vscode/settings.json
cp .vscode/launch.example.json .vscode/launch.json
```

2. Start SeyCode with `--inspect` flag

3. Use VSCode "Attach" configuration (NOT "Launch")

**Why?** Launch configurations often have incorrectly mapped breakpoints with Bun.

## Common Debug Scenarios

### Debugging Tool Execution
1. Set breakpoint in `packages/seycode/src/tool/builtin/your-tool.ts`
2. Start with `sey dev spawn`
3. Invoke tool from TUI
4. Breakpoint hits

### Debugging Session Processing
1. Set breakpoint in `packages/seycode/src/session/processor.ts`
2. Debug server separately
3. Send message from TUI
4. Step through LLM streaming and tool calls

### Debugging Server Routes
1. Set breakpoint in `packages/seycode/src/server/routes/*.ts`
2. Start server with `--inspect`
3. Make API request
4. Breakpoint hits

## Debugging Flags

- `--inspect` - Enable debugger
- `--inspect-wait` - Wait for debugger before starting
- `--inspect-brk` - Break on first line

## Useful Debug Points

Key files to set breakpoints:
- `src/session/processor.ts` - LLM streaming loop
- `src/tool/registry.ts` - Tool discovery and execution
- `src/agent/agent.ts` - Agent initialization
- `src/server/server.ts` - HTTP request handling
- `src/cli/cmd/tui/index.tsx` - TUI rendering

## Debugging Tips

1. **Use `console.log` liberally** - Shows in terminal immediately
2. **Check logs** - Server logs show in terminal running `sey dev serve`
3. **Use `why-is-node-running`** - Debug hanging processes
4. **Check event bus** - Many bugs are event timing issues

## Troubleshooting

**Breakpoints not hitting?**
- Use `sey dev spawn` instead of `sey dev`
- Ensure using attach configuration, not launch
- Check file paths match exactly

**Port already in use?**
- Use different port: `--port 4097`
- Kill existing process: `lsof -ti:4096 | xargs kill -9`

**Debugger disconnects?**
- Increase timeout in debugger config
- Check firewall settings

$ARGUMENTS
