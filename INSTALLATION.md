# SeyCode Installation & Usage Guide

Complete guide to installing, configuring, and using SeyCode - the revolutionary AI coding agent.

---

## Table of Contents

1. [System Requirements](#system-requirements)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Getting Started](#getting-started)
5. [Basic Usage](#basic-usage)
6. [Advanced Features](#advanced-features)
7. [Troubleshooting](#troubleshooting)

---

## System Requirements

### Operating Systems
- ✅ macOS (10.15+)
- ✅ Linux (Ubuntu 20.04+, Debian 11+, or equivalent)
- ✅ Windows (via WSL2 recommended)

### Prerequisites

**Required:**
- Git
- 4GB+ RAM
- Internet connection
- macOS, Linux, or Windows (WSL2)

**Optional:**
- VS Code (for VS Code extension)
- Rust toolchain (for desktop app development)

**Note**: All runtimes and dependencies are installed automatically.

---

## Installation

### Option 1: One-Command Install (Recommended)

```bash
# Install everything with one command
curl -fsSL https://raw.githubusercontent.com/viseyyon/seycode/dev/install.sh | bash

# Restart terminal or reload profile
source ~/.zshrc

# Done! Start using it
sey dev
```

This automatically installs:
- ✅ Runtime dependencies
- ✅ SeyCode CLI
- ✅ All required packages
- ✅ The `sey` command

### Option 2: Manual Install

```bash
# Clone the repository
git clone https://github.com/viseyyon/seycode.git
cd seycode

# Run installer
./install.sh

# Restart terminal
source ~/.zshrc
```

### Option 3: From Source (Development)

### Option 3: From Source (Development)

```bash
# Clone the repository
git clone https://github.com/viseyyon/seycode.git
cd seycode

# Run installer
./install.sh

# Run in development mode
sey dev

# Or run against a specific directory
sey dev /path/to/your/project
```

---

## Configuration

### Step 1: Set Up API Keys

SeyCode requires at least one LLM provider API key. Get your keys from:

**Anthropic (Recommended)**
1. Go to https://console.anthropic.com/
2. Create an account
3. Navigate to API Keys
4. Create a new key
5. Copy the key (starts with `sk-ant-`)

**OpenAI (Optional but recommended)**
1. Go to https://platform.openai.com/
2. Create an account
3. Navigate to API Keys
4. Create a new key
5. Copy the key (starts with `sk-`)

**Google AI (Optional)**
1. Go to https://aistudio.google.com/
2. Create an account
3. Get API key
4. Copy the key

### Step 2: Configure Environment Variables

Add these to your shell profile (`~/.zshrc`, `~/.bashrc`, or `~/.profile`):

```bash
# Essential (choose at least one)
export ANTHROPIC_API_KEY="sk-ant-your-key-here"  # Recommended
export OPENAI_API_KEY="sk-your-key-here"

# Optional (for additional features)
export GOOGLE_GENERATIVE_AI_API_KEY="your-key-here"
export OPENROUTER_API_KEY="sk-or-your-key-here"
export AZURE_API_KEY="your-key-here"

# Optional: Custom data directory
export SEYCODE_DATA="$HOME/.seycode"
```

**Apply changes:**
```bash
source ~/.zshrc  # or ~/.bashrc
```

### Step 3: Initialize Configuration

```bash
# Navigate to your project
cd /path/to/your/project

# Initialize SeyCode configuration (creates .seycode directory)
mkdir -p .seycode
cp /path/to/seycode/.seycode/seycode-optimized.json .seycode/seycode.json

# Or start with minimal config
cat > .seycode/seycode.json << 'EOF'
{
  "agents": {
    "build": {
      "model": "claude-3-7-sonnet-20250219",
      "temperature": 0.7
    }
  }
}
EOF
```

### Step 4: Verify Installation

```bash
# Check Bun version
sey --version

# Check SeyCode can start
cd /path/to/seycode
sey dev --help

# Test with a simple command
sey dev
```

You should see the SeyCode TUI (Terminal User Interface) start up.

---

## Getting Started

### First Run

```bash
# Navigate to your project directory
cd /path/to/your/project

# Start SeyCode
seycode  # if installed globally
# OR
sey dev  # from SeyCode directory
```

### TUI (Terminal User Interface)

When you start SeyCode, you'll see:

```
┌─────────────────────────────────────────┐
│ SeyCode - AI Coding Agent               │
│                                         │
│ Type your message...                    │
│                                         │
│ Commands:                               │
│ /help     - Show help                   │
│ /clear    - Clear conversation          │
│ /exit     - Exit SeyCode                │
│                                         │
│ Skills available: 16                    │
│ Agents available: 13                    │
└─────────────────────────────────────────┘
```

### Your First Interaction

Try these simple commands:

```bash
# Get help
/help

# Ask about your codebase
"What does this project do?"

# Use a skill
@architecture-explorer "Show me the project structure"

# Use workflow orchestrator
@workflow-orchestrator "I want to add user authentication"

# Get recommendations
"What's the best way to add a new feature?"
```

---

## Basic Usage

### 1. Natural Language Commands

Just type what you want:

```
"Fix the bug in authentication"
"Add a new API endpoint for users"
"Optimize the database queries"
"Write tests for the login function"
"Document the API routes"
```

**SeyCode automatically:**
- ✨ Enhances your prompt (via `@prompt-engineer`)
- 🧠 Routes to optimal agents (via `@agent-router`)
- 💾 Creates checkpoints (via `@memory-manager`)
- 🔧 Fixes errors (via `@self-corrector`)
- 📈 Learns and improves (via `@self-evolver`)

### 2. Using Skills

Skills are specialized workflows. Invoke them with `@skill-name`:

```bash
# Get workflow recommendations
@workflow-orchestrator "add user authentication"

# Explore architecture
@architecture-explorer "How does the session system work?"

# Create a new tool
@tool-creator "Create a tool for processing images"

# Run tests
@test-runner "Run all tests"

# Debug issues
@debug-helper "Debug the server startup"

# Generate documentation
@doc-generator "Document the authentication module"

# Create an agent
@agent-creator "Create an agent for API testing"

# Add a provider
@provider-adder "Add OpenRouter provider"

# Regenerate SDK
@sdk-regenerator "Update SDK after API changes"
```

### 3. Using Specialized Agents

Invoke specialized agents with `@agent-name`:

```bash
# Security audit
@security-auditor "Review authentication code for vulnerabilities"

# Generate tests
@test-generator "Generate tests for user service"

# Code review
@code-reviewer "Review my recent changes"

# Performance analysis
@perf-analyzer "Analyze the query performance"

# Write documentation
@doc-writer "Document the new feature"

# Refactor code
@refactor-agent "Refactor the session handler"

# Design API
@api-designer "Create REST API for user management"
```

### 4. Memory Management

SeyCode automatically creates checkpoints, but you can manage memory manually:

```bash
# View checkpoint history
@memory-manager history

# View last 10 checkpoints
@memory-manager history 10

# Rollback last action
@memory-manager rollback

# Rollback last 3 actions
@memory-manager rollback 3

# Rollback to specific checkpoint
@memory-manager rollback checkpoint-abc123

# Resume from last checkpoint
@memory-manager resume last

# Resume from specific checkpoint
@memory-manager resume checkpoint-abc123

# Create a branch for experiments
@memory-manager branch "try-alternative-approach"

# Switch branches
@memory-manager switch main

# Compare branches
@memory-manager compare main experiment

# View statistics
@memory-manager stats
```

### 5. Built-in Commands

```bash
# Show help
/help

# Clear conversation
/clear

# Show available skills
/skills

# Show available agents
/agents

# Show current configuration
/config

# Exit SeyCode
/exit
```

---

## Advanced Features

### 1. Multi-Agent Workflows

Chain multiple agents for complex tasks:

```bash
# Complete feature development workflow
@architecture-explorer "Where to add payment integration?"
# → Understand the codebase

@api-designer "Create payment API endpoints"
# → Design and implement

@test-generator "Generate tests for payment API"
# → Create comprehensive tests

@test-runner "Run payment tests"
# → Verify everything works

@security-auditor "Audit payment code"
# → Security review

@doc-writer "Document payment integration"
# → Create documentation
```

### 2. Automatic Features (Always Active)

These run automatically without invocation:

**🌟 @prompt-engineer** (Killer Feature #1)
- Enhances every prompt you write
- Adds context, skills, quality checks
- Makes prompts optimally effective

**💾 @memory-manager** (Killer Feature #2)
- Creates checkpoints after every action
- Enables rollback and resume
- Tracks complete history

**🎯 @agent-router** (Killer Feature #3)
- Routes to optimal agents automatically
- Selects best skills for each task
- No manual routing needed

**🔧 @self-corrector** (Killer Feature #4)
- Detects and fixes errors automatically
- Learns from mistakes
- Never repeats same error

**📈 @self-evolver** (Killer Feature #5)
- Discovers usage patterns
- Creates new skills automatically
- Adapts to your workflow
- Gets better every day

### 3. Running Different Modes

```bash
# TUI mode (default)
sey dev

# TUI on specific directory
sey dev /path/to/project

# Server mode (for web/desktop UI)
sey dev serve

# Server on custom port
sey dev serve --port 8080

# Attach TUI to existing server
seycode attach http://localhost:4096

# Debug mode with breakpoints
sey dev spawn
```

### 4. Custom Configuration

Create `.seycode/seycode.json` in your project:

```json
{
  "agents": {
    "build": {
      "model": "claude-3-7-sonnet-20250219",
      "temperature": 0.7,
      "permission": {
        "read": { "*": "allow" },
        "write": { "*": "allow" },
        "bash": { "*": "ask" }
      }
    },
    "my-custom-agent": {
      "mode": "subagent",
      "description": "Custom agent for specific tasks",
      "model": "gpt-4o",
      "permission": {
        "read": { "*": "allow" },
        "write": { "src/**": "allow", "*": "deny" }
      }
    }
  },
  "modelFallback": {
    "enabled": true,
    "strategy": "auto",
    "retryAttempts": 3
  },
  "costOptimization": {
    "enabled": true,
    "budgetPerDay": 50.0
  }
}
```

### 5. Creating Custom Skills

Create `.seycode/skill/my-skill.md`:

```markdown
---
name: my-skill
description: What this skill does
---

# My Custom Skill

Instructions for the agent...

## Steps

1. Do this
2. Then this
3. Finally this

## Context

$ARGUMENTS
```

Use it:
```bash
@my-skill "arguments here"
```

---

## Common Workflows

### Workflow 1: Fixing a Bug

```bash
# 1. Understand the area
@architecture-explorer "How does authentication work?"

# 2. Analyze the bug
"Show me the authentication error in the logs"

# 3. Setup debugging
@debug-helper "Debug authentication flow"

# 4. Fix the bug
"Fix the token validation issue"

# 5. Test the fix
@test-runner "Run authentication tests"

# 6. Review
@code-reviewer "Review the authentication fix"
```

### Workflow 2: Adding a New Feature

```bash
# 1. Get optimal workflow
@workflow-orchestrator "add user profile management"

# 2. Follow recommended steps
# (SeyCode will suggest the optimal sequence)

# 3. Use suggested skills
@architecture-explorer → @api-designer → @test-generator → ...
```

### Workflow 3: Code Review & Optimization

```bash
# 1. Review code quality
@code-reviewer "Review user service implementation"

# 2. Check security
@security-auditor "Audit user service for vulnerabilities"

# 3. Analyze performance
@perf-analyzer "Check user service performance"

# 4. Refactor if needed
@refactor-agent "Optimize user service based on findings"

# 5. Verify improvements
@test-runner "Run all tests"
```

### Workflow 4: Documentation

```bash
# 1. Generate docs for module
@doc-generator "Document the authentication module"

# 2. Generate API docs
@doc-generator "Create API documentation"

# 3. Update README
@doc-writer "Update README with new features"
```

---

## Troubleshooting

### Issue: "API key not found"

**Solution:**
```bash
# Check if key is set
echo $ANTHROPIC_API_KEY

# If empty, add to shell profile
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.zshrc
source ~/.zshrc
```

### Issue: "Runtime not available"

**Solution:**
```bash
# Reinstall SeyCode (includes runtime)
curl -fsSL https://raw.githubusercontent.com/viseyyon/seycode/dev/install.sh | bash

# Restart terminal or source profile
source ~/.zshrc
```

### Issue: "Port 4096 already in use"

**Solution:**
```bash
# Find process using port
lsof -i :4096

# Kill the process
kill -9 <PID>

# Or use different port
sey dev serve --port 8080
```

### Issue: "Model not responding"

**Solution:**
```bash
# Check API key is valid
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-3-7-sonnet-20250219","max_tokens":100,"messages":[{"role":"user","content":"test"}]}'

# Try fallback model
# Edit .seycode/seycode.json and add fallback models
```

### Issue: "Out of memory"

**Solution:**
```bash
# Increase Node memory limit
export NODE_OPTIONS="--max-old-space-size=4096"

# Restart SeyCode
sey dev
```

### Issue: "Tests failing from root"

**Solution:**
```bash
# Don't run tests from repository root
# Always run from package directories

cd packages/seycode
sey test

# Not from root:
# sey test  # ❌ Will fail
```

### Issue: "Breakpoints not working"

**Solution:**
```bash
# Use spawn mode for debugging
sey dev spawn

# Or debug server separately
bun run --inspect=ws://localhost:6499/ --cwd packages/seycode ./src/index.ts serve
```

### Issue: "Skills not found"

**Solution:**
```bash
# Check skills directory exists
ls -la .seycode/skill/

# Copy default skills from SeyCode repository
cp -r /path/to/seycode/.seycode/skill/ .seycode/

# Verify skills are loaded
# Start SeyCode and type: /skills
```

### Issue: "Permission denied errors"

**Solution:**
```bash
# Check file permissions
ls -la .seycode/

# Fix permissions
chmod -R 755 .seycode/

# Check agent permissions in seycode.json
# Make sure the agent has appropriate permissions
```

---

## Performance Tips

### 1. Cost Optimization

```json
{
  "costOptimization": {
    "enabled": true,
    "strategy": "balanced",
    "budgetPerDay": 50.0,
    "preferCheaperModels": {
      "forTaskTypes": ["quick_tasks", "planning"],
      "costThreshold": 5.0
    }
  }
}
```

### 2. Model Selection

```json
{
  "agents": {
    "build": {
      "model": {
        "primary": "claude-3-7-sonnet-20250219",  // Balanced
        "fallback": ["claude-haiku-4-5", "gpt-4o-mini"]  // Faster
      }
    },
    "plan": {
      "model": "claude-haiku-4-5"  // Fast & cheap for planning
    }
  }
}
```

### 3. Context Management

```bash
# Clear old sessions
@memory-manager cleanup

# Use compact mode for large codebases
# SeyCode automatically compacts context when needed

# Focus on specific directories
sey dev src/  # Only work on src/ directory
```

### 4. Parallel Execution

SeyCode automatically runs independent tasks in parallel:
- Reading multiple files
- Running multiple checks
- Parallel skill execution

No configuration needed!

---

## Next Steps

### 1. **Learn the Skills**
```bash
# Explore available skills
/skills

# Try each skill
@workflow-orchestrator "help me learn SeyCode"
```

### 2. **Customize Your Setup**
```bash
# Create project-specific config
vim .seycode/seycode.json

# Create custom skills
vim .seycode/skill/my-workflow.md

# Add custom agents for your project
```

### 3. **Read Documentation**
- `CLAUDE.md` - Complete development guide
- `MODEL_REGISTRY.md` - Model selection guide
- `PROVIDER_SETUP.md` - Provider configuration
- `PROMPTING_TECHNIQUES.md` - Prompt optimization
- `MONETIZATION_STRATEGY.md` - Business model (if building commercial)

### 4. **Join the Community**
- GitHub: https://github.com/viseyyon/seycode
- Discord: [Coming soon]
- Issues: https://github.com/viseyyon/seycode/issues

---

## Quick Reference Card

### Essential Commands

| Command | Purpose |
|---------|---------|
| `sey dev` | Start SeyCode |
| `@workflow-orchestrator` | Get optimal workflow |
| `@architecture-explorer` | Understand codebase |
| `@test-runner` | Run tests |
| `@memory-manager rollback` | Undo changes |
| `/help` | Show help |
| `/exit` | Exit |

### Key Skills

| Skill | When to Use |
|-------|-------------|
| `@workflow-orchestrator` | Any complex task |
| `@architecture-explorer` | Before making changes |
| `@tool-creator` | Creating new tools |
| `@test-runner` | After changes |
| `@debug-helper` | Investigating issues |
| `@doc-generator` | Writing documentation |

### API Keys Required

| Provider | Required? | Get Key |
|----------|-----------|---------|
| Anthropic | ⭐ Yes (recommended) | https://console.anthropic.com/ |
| OpenAI | Optional but recommended | https://platform.openai.com/ |
| Google | Optional | https://aistudio.google.com/ |

---

## Support

### Getting Help

1. **Built-in help**: Type `/help` in SeyCode
2. **Documentation**: Read `CLAUDE.md` for complete guide
3. **GitHub Issues**: https://github.com/viseyyon/seycode/issues
4. **Workflow help**: `@workflow-orchestrator "help me with X"`

### Reporting Issues

```bash
# Include these details:
- SeyCode version: sey --version
- Operating system
- Error message
- Steps to reproduce
- Configuration (sanitized, no API keys!)
```

---

## Summary

**Installation**: 5 minutes
```bash
curl -fsSL https://bun.sh/install | bash
git clone https://github.com/viseyyon/seycode.git
cd seycode && sey install
export ANTHROPIC_API_KEY="sk-ant-..."
sey dev
```

**First command**: Start with workflow orchestrator
```bash
@workflow-orchestrator "help me get started"
```

**Key features**:
- 🌟 5 automatic killer features
- 🎯 16 production-ready skills
- 🤖 13 specialized agents
- 💾 Automatic checkpoints
- 🔧 Self-correcting
- 📈 Self-evolving

**Cost**: ~$3-18/day depending on usage (with Sonnet)

**You're ready!** Start coding with AI assistance that actually makes you 100% more productive. 🚀
