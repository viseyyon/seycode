# Getting Started with SeyCode

Welcome to **SeyCode** - the world's first truly intelligent AI coding agent with revolutionary automatic features!

This guide will help you install SeyCode, create your first session, and start experiencing the power of automatic prompt engineering, memory management, agent routing, self-correction, and self-evolution.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [macOS / Linux](#macos--linux)
  - [Windows](#windows)
  - [Package Managers](#package-managers)
  - [From Source](#from-source)
- [First Session](#first-session)
- [Understanding the Basics](#understanding-the-basics)
- [The 5 Revolutionary Features](#the-5-revolutionary-features)
- [Basic Commands](#basic-commands)
- [Configuration Basics](#configuration-basics)
- [Next Steps](#next-steps)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before installing SeyCode, ensure you have:

### Required
- **Operating System**: macOS, Linux, or Windows
- **Internet Connection**: For downloading and LLM API access
- **API Keys**: At least one LLM provider API key (Anthropic, OpenAI, etc.)

### Recommended
- **Bun 1.3+**: For development (auto-installed with most methods)
- **Git**: For version control integration
- **Terminal**: Basic terminal/command-line knowledge

### System Requirements
- **RAM**: 4GB minimum, 8GB+ recommended
- **Disk Space**: 500MB for installation
- **Network**: Stable internet connection for LLM API calls

---

## Installation

Choose your preferred installation method:

### macOS / Linux

#### Quick Install (Recommended)

```bash
curl -fsSL https://seycode.ai/install | bash
```

This will:
1. Download the latest SeyCode binary
2. Install to `~/.seycode/bin/seycode`
3. Add to your PATH
4. Verify installation

#### Verify Installation

```bash
seycode --version
```

You should see output like:
```
seycode 1.2.10
```

### Windows

#### PowerShell Install

```powershell
irm https://seycode.ai/install.ps1 | iex
```

#### Using Scoop

```powershell
scoop install seycode
```

#### Using Chocolatey

```powershell
choco install seycode
```

### Package Managers

#### Homebrew (macOS/Linux)

```bash
brew install seycode
```

#### npm/bun/pnpm/yarn

```bash
# Using npm
npm install -g seycode

# Using bun
sey install -g seycode

# Using pnpm
pnpm install -g seycode

# Using yarn
yarn global add seycode
```

#### mise (Universal)

```bash
mise use -g seycode@latest
```

#### Nix

```bash
nix profile install github:viseyyon/seycode
```

#### Arch Linux (AUR)

```bash
yay -S seycode
```

### From Source

For development or building from source:

```bash
# Clone the repository
git clone https://github.com/viseyyon/seycode.git
cd seycode

# Install dependencies
sey install

# Build
cd packages/seycode
sey run build

# Run
./bin/seycode
```

See [DEVELOPMENT.md](./DEVELOPMENT.md) for detailed development setup.

---

## First Session

Let's create your first SeyCode session!

### 1. Set Up API Key

SeyCode needs an LLM provider API key. Set your preferred provider:

**Anthropic (Recommended):**
```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

**OpenAI:**
```bash
export OPENAI_API_KEY="your-api-key-here"
```

**Add to shell profile** to persist:
```bash
# For bash
echo 'export ANTHROPIC_API_KEY="your-key"' >> ~/.bashrc

# For zsh
echo 'export ANTHROPIC_API_KEY="your-key"' >> ~/.zshrc
```

### 2. Start SeyCode

```bash
seycode
```

You'll see the SeyCode TUI (Text User Interface):

```
┌─ SeyCode ─────────────────────────────────────┐
│                                                │
│  Welcome to SeyCode!                          │
│  The world's first truly intelligent          │
│  AI coding agent.                             │
│                                                │
│  Type your first prompt below...              │
│                                                │
└────────────────────────────────────────────────┘
>
```

### 3. Your First Prompt

Try this simple prompt:

```
Create a hello world program in Python
```

**Watch the magic happen!** 🪄

SeyCode will:
1. **🎯 Automatically optimize your prompt** (Killer Feature #1)
   - Adds context: "Create Python file"
   - Adds quality checks: "Verify syntax"
   - Structures the task optimally

2. **📝 Create the file** using the Write tool

3. **💾 Automatically checkpoint** (Killer Feature #2)
   - Saves state before and after action
   - Enables rollback if needed

4. **✅ Verify the result**

### 4. Experience Automatic Features

Try this prompt to see agent routing:

```
check this code for security issues
```

**SeyCode will automatically:**
1. **Detect intent**: Security review needed
2. **Route to agent**: `@security-auditor` selected automatically
3. **Execute**: Security audit runs without you specifying anything

This is **Automatic Agent Routing** (Killer Feature #3)!

### 5. Try Memory Management

Make a change, then undo it:

```
@memory-manager rollback
```

Your workspace is restored to the previous checkpoint! This is **Automatic Memory Management** (Killer Feature #2).

To see your checkpoint history:

```
@memory-manager history
```

---

## Understanding the Basics

### SeyCode Interface

SeyCode has **three interfaces**:

1. **TUI (Text User Interface)** - Terminal-based (default)
   ```bash
   seycode
   ```

2. **Web UI** - Browser-based
   ```bash
   seycode serve
   # Then open http://localhost:4096 in browser
   ```

3. **Desktop App** - Native application
   ```bash
   # Download from https://seycode.ai/download
   ```

### Agent Modes

SeyCode has **three built-in agents**:

- **build** (default) - Full access, can read, write, execute
- **plan** - Read-only, for planning and analysis
- **general** - Subagent for complex searches

Switch between agents by pressing **Tab**.

### Skills

Skills are specialized workflows. SeyCode has **16 built-in skills**:

**5 Automatic (Always Active):**
- `@prompt-engineer` - Optimizes every prompt
- `@memory-manager` - Checkpoints every action
- `@agent-router` - Routes to optimal agents
- `@self-corrector` - Fixes errors automatically
- `@self-evolver` - Gets smarter over time

**11 Manual (Invoke with @):**
- `@workflow-orchestrator` - Plans optimal workflow
- `@tool-creator` - Creates new tools
- `@agent-creator` - Creates new agents
- `@provider-adder` - Adds LLM providers
- `@test-runner` - Runs tests intelligently
- `@debug-helper` - Sets up debugging
- `@sdk-regenerator` - Regenerates SDK
- `@architecture-explorer` - Explores codebase
- `@migration-creator` - Creates DB migrations
- `@lsp-configurator` - Configures LSP
- `@doc-generator` - Generates documentation

Use skills by typing `@skill-name` in your prompt.

---

## The 5 Revolutionary Features

### 1. ⚡ Automatic Prompt Engineering

**Every prompt you write is automatically optimized BEFORE execution.**

**Example:**
```
Your input: "fix this bug"

SeyCode transforms to:
"Investigate [bug] in [component]:
1. @architecture-explorer - Understand the code
2. @debug-helper - Setup debugging
3. Identify root cause
4. Implement fix
5. @test-runner - Verify fix
6. @code-reviewer - Review"
```

**You get perfect prompts every time, zero effort!**

### 2. 💾 Automatic Memory Management

**Every action automatically creates checkpoints.**

```
Action Start → Pre-Checkpoint → Execute → Post-Checkpoint → Continue
```

**Commands:**
- `@memory-manager rollback` - Undo last action
- `@memory-manager resume last` - Resume from checkpoint
- `@memory-manager history` - View checkpoints
- `@memory-manager branch "name"` - Create branch for experiments

**Never lose work again!**

### 3. 🎯 Automatic Agent Routing

**Every prompt is automatically analyzed to select the optimal agent.**

```
You type: "check for security issues"

SeyCode automatically:
→ Detects intent: Security review
→ Selects agent: @security-auditor
→ Initiates: Starts automatically
→ Returns: Security audit report
```

**Zero manual routing needed!**

### 4. 🔧 Automatic Self-Correction

**Every error is automatically detected and fixed.**

```
Error occurs
  ↓
@self-corrector detects
  ↓
Searches pattern database
  ↓
Applies fix automatically
  ↓
Validates correction
  ↓
Learns pattern
  ↓
Never makes same mistake twice
```

**Zero downtime, continuous learning!**

### 5. 🧠 Automatic Self-Evolution

**The system gets smarter every day automatically.**

```
Usage patterns tracked
  ↓
Patterns analyzed
  ↓
New skills created
  ↓
Workflows optimized
  ↓
User preferences learned
  ↓
System improves daily
```

**After 30 days, SeyCode will have created custom skills specifically for how YOU work!**

---

## Basic Commands

### Session Management

```bash
# Start new session
seycode

# Start in specific directory
seycode /path/to/project

# Resume last session
seycode --resume

# List sessions
seycode sessions list

# Delete session
seycode sessions delete <session-id>
```

### Server Mode

```bash
# Start headless server
seycode serve

# Start on custom port
seycode serve --port 8080

# Connect TUI to server
seycode attach http://localhost:4096
```

### Configuration

```bash
# Show configuration
seycode config show

# Edit configuration
seycode config edit

# Validate configuration
seycode config validate
```

### Skill Usage

```bash
# In a session, use skills with @
@workflow-orchestrator "add user authentication"
@test-runner "test my changes"
@security-auditor "review for vulnerabilities"
@architecture-explorer "how does session handling work?"
```

### Memory Management

```bash
# In a session:
@memory-manager rollback          # Undo last action
@memory-manager rollback 3        # Undo last 3 actions
@memory-manager resume last       # Resume from last checkpoint
@memory-manager history           # View checkpoint history
@memory-manager branch "feature"  # Create experimental branch
@memory-manager switch main       # Switch to main branch
```

### Help

```bash
# General help
seycode --help

# Command help
seycode sessions --help

# In-session help
/help
```

---

## Configuration Basics

### Configuration File Location

SeyCode looks for configuration in this order:

1. Project: `.seycode/seycode.json` or `.seycode/seycode.jsonc`
2. Global: `~/.config/seycode/seycode.json`
3. Environment: `SEYCODE_CONFIG` variable

### Basic Configuration

Create `.seycode/seycode.json` in your project:

```json
{
  "$schema": "https://seycode.ai/config.json",
  "agents": {
    "build": {
      "model": "claude-sonnet-4",
      "temperature": 0.7
    }
  },
  "memory": {
    "enabled": true,
    "checkpointLevel": "automatic"
  }
}
```

### Provider Configuration

Configure your preferred LLM provider:

```json
{
  "providers": {
    "anthropic": {
      "apiKey": "${ANTHROPIC_API_KEY}",
      "defaultModel": "claude-sonnet-4"
    },
    "openai": {
      "apiKey": "${OPENAI_API_KEY}",
      "defaultModel": "gpt-4"
    }
  }
}
```

### Agent Configuration

Create custom agents with specific permissions:

```json
{
  "agents": {
    "code-reviewer": {
      "mode": "subagent",
      "description": "Review code for quality and security",
      "permission": {
        "read": { "*": "allow" },
        "write": { "*": "deny" },
        "bash": { "*": "deny" }
      }
    }
  }
}
```

See [USER_GUIDE.md](./USER_GUIDE.md) for complete configuration reference.

---

## Next Steps

Congratulations! You're now ready to use SeyCode. Here's what to explore next:

### 1. Learn More

- **[USER_GUIDE.md](./USER_GUIDE.md)** - Complete user manual
- **[CLAUDE.md](./CLAUDE.md)** - Developer guide (if you're coding)
- **[API.md](./API.md)** - API reference (for integrations)
- **[SKILLS.md](./SKILLS.md)** - Skill authoring guide

### 2. Try the 5 Killer Features

- Experience automatic prompt engineering on every prompt
- Create checkpoints and try `@memory-manager rollback`
- Watch automatic agent routing in action
- Observe self-correction when errors occur
- Track self-evolution creating custom skills for you

### 3. Explore Skills

Try these powerful skills:

```bash
# Get workflow recommendations
@workflow-orchestrator "implement user authentication"

# Explore your codebase
@architecture-explorer "how does the API layer work?"

# Run tests intelligently
@test-runner "run tests for changed files"

# Get a security audit
@security-auditor "audit authentication code"

# Generate documentation
@doc-generator "document the user module"
```

### 4. Configure for Your Workflow

- Set up your preferred LLM provider
- Create project-specific `.seycode/seycode.json`
- Configure custom agents for your needs
- Create custom skills for repetitive tasks

### 5. Join the Community

- **GitHub**: [https://github.com/viseyyon/seycode](https://github.com/viseyyon/seycode)
- **Discord**: [https://discord.gg/seycode](https://discord.gg/seycode)
- **Documentation**: [https://docs.seycode.ai](https://docs.seycode.ai)
- **Twitter/X**: [@seycode](https://twitter.com/seycode)

---

## Troubleshooting

### Installation Issues

**Problem: `seycode: command not found`**

Solution: Add to PATH:
```bash
export PATH="$HOME/.seycode/bin:$PATH"
# Add to ~/.bashrc or ~/.zshrc to persist
```

**Problem: Permission denied**

Solution: Make binary executable:
```bash
chmod +x ~/.seycode/bin/seycode
```

**Problem: Installation script fails**

Solution: Download manually:
```bash
# macOS/Linux
curl -L https://github.com/viseyyon/seycode/releases/latest/download/seycode-$(uname -s)-$(uname -m) -o seycode
chmod +x seycode
sudo mv seycode /usr/local/bin/
```

### Connection Issues

**Problem: Cannot connect to LLM provider**

Check:
1. API key is set: `echo $ANTHROPIC_API_KEY`
2. API key is valid: Test at provider website
3. Internet connection: `ping api.anthropic.com`
4. Firewall/proxy settings

**Problem: "Rate limit exceeded"**

Solution:
- Wait and retry
- Check your API plan limits
- Consider upgrading API plan

### Runtime Issues

**Problem: SeyCode is slow**

Solutions:
- Check internet speed
- Try a faster model (e.g., claude-haiku)
- Check system resources (RAM, CPU)
- Close other applications

**Problem: Errors in automatic features**

Solutions:
- Check `.seycode/seycode.json` configuration
- Verify automatic features are enabled:
  ```json
  {
    "memory": { "enabled": true },
    "selfCorrection": { "enabled": true },
    "selfEvolution": { "enabled": true }
  }
  ```
- Check logs: `~/.seycode/logs/`

### Getting Help

If you're still having issues:

1. **Check documentation**: [https://docs.seycode.ai](https://docs.seycode.ai)
2. **Search issues**: [https://github.com/viseyyon/seycode/issues](https://github.com/viseyyon/seycode/issues)
3. **Ask on Discord**: [https://discord.gg/seycode](https://discord.gg/seycode)
4. **Create an issue**: [https://github.com/viseyyon/seycode/issues/new](https://github.com/viseyyon/seycode/issues/new)

See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for comprehensive troubleshooting guide.

---

## What Makes SeyCode Different?

SeyCode isn't just another AI coding agent. It's revolutionary because:

| Feature | Other AI Agents | SeyCode |
|---------|----------------|---------|
| **Prompt Quality** | Depends on you | **Automatically optimized** |
| **Undo/Rollback** | Manual or none | **Automatic checkpoints** |
| **Agent Selection** | Manual routing | **Automatic routing** |
| **Error Handling** | Breaks workflow | **Auto-fixes & learns** |
| **Improvement** | Static system | **Gets smarter daily** |

**Every. Single. Prompt. Optimized. Automatically.** 🚀

---

**Welcome to the future of AI-assisted development. Welcome to SeyCode!**

For questions, feedback, or contributions, visit:
- GitHub: [https://github.com/viseyyon/seycode](https://github.com/viseyyon/seycode)
- Documentation: [https://docs.seycode.ai](https://docs.seycode.ai)
- Community: [https://discord.gg/seycode](https://discord.gg/seycode)
