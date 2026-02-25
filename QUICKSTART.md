# SeyCode Quick Start (5 Minutes)

Get SeyCode running in 5 minutes. For complete guide, see [INSTALLATION.md](./INSTALLATION.md).

---

## 1. Get API Key

Choose **ONE** provider (Anthropic recommended):

### Option A: Anthropic (Recommended) ⭐

1. Go to https://console.anthropic.com/
2. Sign up / Log in
3. Go to "API Keys"
4. Click "Create Key"
5. Copy key (starts with `sk-ant-`)

**Cost**: ~$3-18/day for typical use

### Option B: OpenAI

1. Go to https://platform.openai.com/
2. Sign up / Log in
3. Go to "API Keys"
4. Click "Create new secret key"
5. Copy key (starts with `sk-`)

---

## 2. Install SeyCode

**One-command installation:**

```bash
curl -fsSL https://raw.githubusercontent.com/viseyyon/seycode/dev/install.sh | bash
```

This installs everything you need automatically.

**Or clone and install manually:**

```bash
git clone https://github.com/viseyyon/seycode.git
cd seycode
./install.sh
```

---

## 3. Set API Key

```bash
# Add to ~/.zshrc or ~/.bashrc
export ANTHROPIC_API_KEY="sk-ant-your-key-here"
echo 'export ANTHROPIC_API_KEY="sk-ant-your-key-here"' >> ~/.zshrc

# Apply changes
source ~/.zshrc
```

**Verify:**
```bash
echo $ANTHROPIC_API_KEY
# Should show: sk-ant-...
```

---

## 4. Start SeyCode

```bash
# Start in current directory
sey dev

# Or start in your project
sey dev /path/to/your/project
```

You should see the SeyCode TUI (Terminal User Interface) start up!

---

## 5. First Commands

Try these in the SeyCode prompt:

```bash
# Get help
/help

# Get workflow recommendation for any task
@workflow-orchestrator "I want to add user authentication"

# Explore your codebase
@architecture-explorer "Show me the project structure"

# Or just ask naturally
"What does this project do?"

"Help me understand the codebase"

"Fix the bug in the login function"
```

---

## That's It! 🎉

You're now running SeyCode with:
- ✨ Automatic prompt enhancement
- 💾 Automatic checkpoints (undo/redo anything)
- 🎯 Automatic agent routing
- 🔧 Automatic error correction
- 📈 Self-evolving (gets better every day)

---

## Quick Reference

### Most Useful Commands

```bash
@workflow-orchestrator "task description"  # Get optimal workflow for any task
@architecture-explorer "question"          # Understand codebase
@test-runner                               # Run tests
@memory-manager rollback                   # Undo last action
/help                                      # Show help
/exit                                      # Exit SeyCode
```

### Common Tasks

| Task | Command |
|------|---------|
| Add a feature | `@workflow-orchestrator "add feature X"` |
| Fix a bug | `"Fix bug in X"` (natural language) |
| Understand code | `@architecture-explorer "How does X work?"` |
| Run tests | `@test-runner` |
| Review code | `@code-reviewer "Review my changes"` |
| Undo changes | `@memory-manager rollback` |
| Write tests | `@test-generator "Generate tests for X"` |
| Create docs | `@doc-generator "Document module X"` |

---

## Troubleshooting

### "API key not found"
```bash
echo $ANTHROPIC_API_KEY  # Check if set
# If empty, add to ~/.zshrc and source it
```

### "Command not found: bun"
```bash
curl -fsSL https://bun.sh/install | bash
# Restart terminal
```

### "Port already in use"
```bash
sey dev serve --port 8080  # Use different port
```

---

## Next Steps

1. **Read the full guide**: [INSTALLATION.md](./INSTALLATION.md)
2. **Learn the system**: [CLAUDE.md](./CLAUDE.md)
3. **Understand models**: [MODEL_REGISTRY.md](./MODEL_REGISTRY.md)
4. **Master prompting**: [PROMPTING_TECHNIQUES.md](./PROMPTING_TECHNIQUES.md)

---

## Cost Estimate

**With Claude Sonnet (recommended):**
- Light use (daily coding, 1-2 hours): $1-3/day
- Medium use (full-time dev, 4-6 hours): $3-10/day
- Heavy use (intensive dev, 8+ hours): $10-20/day

**Tips to reduce costs:**
- Use Haiku for quick tasks (75% cheaper)
- Set daily budget limits in config
- Use free tier when learning

---

## Need Help?

- **In-app**: Type `/help` or `@workflow-orchestrator "help me with X"`
- **Documentation**: Check `CLAUDE.md` for complete guide
- **Issues**: https://github.com/viseyyon/seycode/issues
- **Website**: [Coming soon]

---

## Why SeyCode > Claude Code?

| Feature | Claude Code | SeyCode |
|---------|-------------|---------|
| Prompt enhancement | ❌ Manual | ✅ Automatic |
| Checkpoints/Undo | ❌ No | ✅ Automatic |
| Agent routing | ❌ Manual | ✅ Automatic |
| Error correction | ❌ No | ✅ Automatic |
| Self-improving | ❌ No | ✅ Yes |
| Production skills | 0 | 16 |
| Specialized agents | Generic | 13 |

---

**You're ready to code 100% more productively!** 🚀

Start with: `@workflow-orchestrator "help me learn SeyCode"`
