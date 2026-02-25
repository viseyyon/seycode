# Model Registry & Multi-Model Fallback System

Complete guide to SeyCode's advanced model registry and automatic fallback system.

## Overview

SeyCode includes a sophisticated **model registry system** with:
- **Latest model tracking** - Always uses the newest, most capable models
- **Automatic fallback** - Seamlessly switches to backup models if primary fails
- **Cost optimization** - Smart model selection based on task complexity
- **Auto-update** - Syncs with models.dev every hour for latest releases
- **Task-specific recommendations** - Best models for each type of work

---

## Quick Start

### 1. Use the Optimized Configuration

Copy the optimized configuration:

```bash
# Copy optimized config to your project
cp .seycode/seycode-optimized.json .seycode/seycode.json

# Or use it as reference
cat .seycode/seycode-optimized.json
```

### 2. Set Up API Keys

```bash
# Add to your shell profile (~/.zshrc or ~/.bashrc)
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
export GOOGLE_GENERATIVE_AI_API_KEY="..."

# Optional: For even more coverage
export AZURE_API_KEY="..."
export OPENROUTER_API_KEY="sk-or-..."
```

### 3. Start Using

```bash
bun dev

# SeyCode will automatically:
# - Use the best model for each task
# - Fall back to backup models if needed
# - Optimize costs based on task complexity
# - Update model information hourly
```

---

## Model Registry Structure

### Latest Models (as of 2026-02-25)

#### Anthropic (Claude)
- **Flagship**: `claude-opus-4-6` (most capable)
- **Balanced**: `claude-3-7-sonnet-20250219` ⭐ Recommended
- **Fast**: `claude-haiku-4-5` (quick responses)

#### OpenAI (GPT)
- **Flagship**: `gpt-5.2` (latest reasoning)
- **Coding**: `gpt-5.1-codex` ⭐ Code specialist
- **Balanced**: `gpt-4o` (multimodal)
- **Fast**: `gpt-4o-mini` (budget-friendly)

#### Google (Gemini)
- **Flagship**: `gemini-2.5-pro` (huge context)
- **Balanced**: `gemini-2.5-flash` (fast)
- **Budget**: `gemini-2.5-flash-lite` (ultra cheap)

---

## Model Categories

SeyCode organizes models into categories for easy selection:

### 1. Flagship Models
**Use for:** Critical tasks, complex reasoning, important decisions

| Model | Provider | Cost (per 1M tokens) | Context Window |
|-------|----------|---------------------|----------------|
| claude-opus-4-6 | Anthropic | $15/$75 | 200K |
| gpt-5.2 | OpenAI | Variable | 200K |
| gemini-2.5-pro | Google | $3.50/$10.50 | 1M |

**Fallback chain:**
1. claude-opus-4-6
2. gpt-5.2
3. claude-opus-4-5

### 2. Balanced Models ⭐ Recommended
**Use for:** Most development tasks, default choice

| Model | Provider | Cost (per 1M tokens) | Context Window |
|-------|----------|---------------------|----------------|
| claude-3-7-sonnet-20250219 | Anthropic | $3/$15 | 200K |
| gpt-4o | OpenAI | $2.50/$10 | 128K |
| gemini-2.5-pro | Google | $3.50/$10.50 | 1M |

**Fallback chain:**
1. claude-3-7-sonnet-20250219
2. gpt-4o
3. gemini-2.5-pro

### 3. Fast Models
**Use for:** Quick tasks, planning, routing

| Model | Provider | Cost (per 1M tokens) | Context Window |
|-------|----------|---------------------|----------------|
| claude-haiku-4-5 | Anthropic | $0.80/$4 | 200K |
| gemini-2.5-flash | Google | $0.15/$0.60 | 1M |
| gpt-4o-mini | OpenAI | $0.15/$0.60 | 128K |

**Fallback chain:**
1. claude-haiku-4-5
2. gemini-2.5-flash
3. gpt-4o-mini

### 4. Coding Specialists
**Use for:** Code generation, refactoring, testing

| Model | Provider | Features |
|-------|----------|----------|
| gpt-5.1-codex | OpenAI | Advanced code understanding |
| claude-3-7-sonnet | Anthropic | Excellent code quality |
| gpt-5-codex | OpenAI | Code-optimized |

**Fallback chain:**
1. gpt-5.1-codex
2. claude-3-7-sonnet-20250219
3. gpt-5-codex

### 5. Reasoning Models
**Use for:** Complex problem solving, architecture design

| Model | Provider | Features |
|-------|----------|----------|
| gpt-5.2 | OpenAI | Extended thinking |
| claude-opus-4-6 | Anthropic | Deep reasoning |
| gpt-5.1 | OpenAI | Advanced reasoning |

### 6. Multimodal Models
**Use for:** Image, audio, video, PDF processing

| Model | Provider | Modalities |
|-------|----------|------------|
| gemini-2.5-pro | Google | Text, image, audio, video, PDF |
| gpt-4o | OpenAI | Text, image, audio |
| claude-opus-4-6 | Anthropic | Text, image, PDF |

### 7. Budget Models
**Use for:** High-volume, simple tasks

| Model | Provider | Cost (per 1M tokens) |
|-------|----------|---------------------|
| gemini-2.5-flash-lite | Google | $0.075/$0.30 |
| claude-haiku-4-5 | Anthropic | $0.80/$4 |
| gpt-4o-mini | OpenAI | $0.15/$0.60 |

---

## Agent Model Recommendations

Each agent has optimized model selection:

### Automatic Agents (5 Revolutionary Features)

**1. prompt-enhancer** (Killer Feature #1)
- **Primary**: claude-haiku-4-5
- **Fallback**: gemini-2.5-flash-lite, gpt-4o-mini
- **Why**: Must be ultra-fast to avoid workflow delays

**2. memory-manager** (Killer Feature #2)
- **Primary**: claude-haiku-4-5
- **Fallback**: gemini-2.5-flash
- **Why**: Memory operations need instant responses

**3. agent-router** (Killer Feature #3)
- **Primary**: claude-haiku-4-5
- **Fallback**: gemini-2.5-flash, gpt-4o-mini
- **Why**: Routing decisions must be instantaneous

**4. self-corrector** (Killer Feature #4)
- **Primary**: claude-3-7-sonnet-20250219
- **Fallback**: gpt-4o, gemini-2.5-pro
- **Why**: Error correction needs good reasoning

**5. self-evolver** (Killer Feature #5)
- **Primary**: claude-opus-4-6
- **Fallback**: gpt-5.2, claude-opus-4-5
- **Why**: Pattern analysis requires best model

### Manual Agents

**build** (Main development)
- **Primary**: claude-3-7-sonnet-20250219
- **Fallback**: gpt-4o, gemini-2.5-pro
- **Why**: Best balance of quality and cost

**security-auditor**
- **Primary**: claude-opus-4-6
- **Fallback**: gpt-5.2, claude-3-7-sonnet
- **Why**: Security is critical

**test-generator**
- **Primary**: gpt-5.1-codex
- **Fallback**: claude-3-7-sonnet, gpt-5-codex
- **Why**: Specialized code generation

**code-reviewer**
- **Primary**: claude-opus-4-6
- **Fallback**: gpt-5.2, claude-3-7-sonnet
- **Why**: Code quality is critical

**perf-analyzer**
- **Primary**: claude-3-7-sonnet-20250219
- **Fallback**: gpt-4o, gemini-2.5-pro
- **Why**: Balanced reasoning for optimization

**doc-writer**
- **Primary**: gpt-4o
- **Fallback**: claude-3-7-sonnet, gemini-2.5-pro
- **Why**: Excellent language generation

**refactor-agent**
- **Primary**: gpt-5.1-codex
- **Fallback**: claude-3-7-sonnet, gpt-5-codex
- **Why**: Code-specialized

**api-designer**
- **Primary**: claude-3-7-sonnet-20250219
- **Fallback**: gpt-4o, gemini-2.5-pro
- **Why**: Balanced capabilities

---

## Fallback Strategy

### How It Works

```
Request → Primary Model
            ↓ (if fails)
         Backup Model 1
            ↓ (if fails)
         Backup Model 2
            ↓ (if fails)
         Backup Model 3
            ↓ (if all fail)
         Error with suggestions
```

### Error Handling

Different failures trigger different behaviors:

| Error Type | Action |
|------------|--------|
| **Rate Limit** | Switch to backup immediately |
| **Timeout** | Retry 3x, then fallback |
| **API Error** | Fallback immediately |
| **Invalid Request** | No fallback (fix request) |

### Configuration

```json
{
  "modelFallback": {
    "enabled": true,
    "strategy": "auto",
    "retryAttempts": 3,
    "retryDelay": 1000,
    "timeoutMs": 30000,
    "errorHandling": {
      "rate_limit": "use_backup_immediately",
      "timeout": "retry_then_fallback",
      "api_error": "fallback_immediately",
      "invalid_request": "no_fallback"
    }
  }
}
```

---

## Cost Optimization

### Automatic Cost Management

SeyCode automatically optimizes costs:

**Budget-Based Routing:**
```json
{
  "costOptimization": {
    "enabled": true,
    "strategy": "balanced",
    "budgetPerDay": 50.0,
    "alertThreshold": 0.8,
    "preferCheaperModels": {
      "forTaskTypes": ["quick_tasks", "planning", "routing"],
      "costThreshold": 5.0
    }
  }
}
```

**Smart Model Selection:**
- **Simple tasks** → Fast/budget models (claude-haiku, gemini-flash-lite)
- **Normal tasks** → Balanced models (claude-sonnet, gpt-4o)
- **Critical tasks** → Flagship models (claude-opus, gpt-5.2)

### Cost Comparison

**Example: 1M tokens processed**

| Strategy | Models Used | Cost | Quality |
|----------|-------------|------|---------|
| **All Flagship** | opus-4-6 only | $90 | ⭐⭐⭐⭐⭐ |
| **Balanced** ⭐ | 70% sonnet, 30% haiku | $15 | ⭐⭐⭐⭐ |
| **Budget** | 80% haiku, 20% flash-lite | $4 | ⭐⭐⭐ |

**Recommendation**: Use "Balanced" strategy (configured by default)

---

## Auto-Update System

### How It Works

SeyCode automatically updates model information:

1. **Syncs with models.dev** every hour
2. **Checks for new models** from all providers
3. **Updates model registry** with latest info
4. **Preserves your custom configurations**

### Configuration

```json
{
  "modelRegistry": {
    "autoUpdate": true,
    "updateInterval": 3600000,
    "registryFile": ".seycode/model-registry.json",
    "fallbackToRegistry": true
  }
}
```

### Manual Update

Force update the registry:

```bash
# Update model information
curl -s https://models.dev/api.json > .seycode/models-latest.json

# Review changes
diff .seycode/models-latest.json ~/.cache/seycode/models.json

# SeyCode will automatically pick up changes
```

---

## Task-Specific Recommendations

### Code Generation

**Best models:**
1. gpt-5.1-codex (OpenAI) - Specialized for code
2. claude-3-7-sonnet (Anthropic) - Excellent quality
3. gpt-5-codex (OpenAI) - Code-optimized

**Configuration:**
```json
{
  "agents": {
    "build": {
      "model": {
        "primary": "openai/gpt-5.1-codex",
        "fallback": ["claude-3-7-sonnet-20250219", "openai/gpt-5-codex"]
      }
    }
  }
}
```

### Code Review

**Best models:**
1. claude-opus-4-6 (Anthropic) - Most thorough
2. gpt-5.2 (OpenAI) - Advanced reasoning
3. claude-3-7-sonnet (Anthropic) - Excellent quality

### Debugging

**Best models:**
1. claude-3-7-sonnet (Anthropic) - Great at finding issues
2. gpt-4o (OpenAI) - Good debugging
3. gemini-2.5-pro (Google) - Fast analysis

### Documentation

**Best models:**
1. gpt-4o (OpenAI) - Best language generation
2. claude-3-7-sonnet (Anthropic) - Clear writing
3. gemini-2.5-pro (Google) - Good documentation

### Testing

**Best models:**
1. gpt-5.1-codex (OpenAI) - Code-specialized
2. claude-3-7-sonnet (Anthropic) - Comprehensive tests
3. gpt-4o (OpenAI) - Good test coverage

### Security Auditing

**Best models:**
1. claude-opus-4-6 (Anthropic) - Most thorough
2. gpt-5.2 (OpenAI) - Advanced analysis
3. claude-3-7-sonnet (Anthropic) - Detailed review

### Performance Optimization

**Best models:**
1. claude-3-7-sonnet (Anthropic) - Good analysis
2. gpt-4o (OpenAI) - Performance insights
3. gemini-2.5-pro (Google) - Fast optimization

### Architecture Design

**Best models:**
1. claude-opus-4-6 (Anthropic) - Deep thinking
2. gpt-5.2 (OpenAI) - Complex reasoning
3. claude-3-7-sonnet (Anthropic) - Good design

### Quick Tasks

**Best models:**
1. claude-haiku-4-5 (Anthropic) - Fast & capable
2. gemini-2.5-flash (Google) - Ultra-fast
3. gpt-4o-mini (OpenAI) - Quick responses

---

## Advanced Configuration

### Custom Fallback Chain

Define your own fallback sequence:

```json
{
  "agents": {
    "custom-agent": {
      "model": {
        "primary": "claude-opus-4-6",
        "fallback": [
          "openai/gpt-5.2",
          "claude-3-7-sonnet-20250219",
          "google/gemini-2.5-pro",
          "openrouter/anthropic/claude-opus-4"
        ]
      },
      "temperature": 0.7,
      "maxRetries": 5
    }
  }
}
```

### Provider-Specific Fallback

Stay within one provider:

```json
{
  "agents": {
    "anthropic-only": {
      "model": {
        "primary": "claude-opus-4-6",
        "fallback": [
          "claude-opus-4-5",
          "claude-3-7-sonnet-20250219",
          "claude-sonnet-4-0",
          "claude-haiku-4-5"
        ]
      }
    }
  }
}
```

### Cost-Optimized Fallback

Progressively cheaper models:

```json
{
  "agents": {
    "budget-aware": {
      "model": {
        "primary": "claude-3-7-sonnet-20250219",
        "fallback": [
          "claude-haiku-4-5",
          "google/gemini-2.5-flash",
          "google/gemini-2.5-flash-lite",
          "openai/gpt-4o-mini"
        ]
      }
    }
  }
}
```

### Multi-Provider Redundancy

Maximum availability:

```json
{
  "agents": {
    "always-available": {
      "model": {
        "primary": "claude-opus-4-6",
        "fallback": [
          "openai/gpt-5.2",
          "google/gemini-2.5-pro",
          "azure/gpt-4o",
          "openrouter/anthropic/claude-opus-4",
          "openrouter/openai/gpt-4o",
          "claude-3-7-sonnet-20250219"
        ]
      }
    }
  }
}
```

---

## Monitoring & Debugging

### Check Which Model Is Being Used

```bash
# View current session
bun dev

# In SeyCode, ask:
"Which model are you using?"

# Or check logs
tail -f ~/.cache/seycode/logs/provider.log
```

### Track Model Usage

```bash
# View usage statistics
cat ~/.cache/seycode/usage-stats.json

# Check costs
cat ~/.cache/seycode/cost-tracking.json
```

### Debug Fallback Events

```bash
# Enable debug logging
export SEYCODE_LOG_LEVEL=debug

# Watch for fallback events
tail -f ~/.cache/seycode/logs/fallback.log
```

---

## Provider Status

Current status of all providers (as of 2026-02-25):

| Provider | Status | Latest Model | Last Checked |
|----------|--------|-------------|--------------|
| **Anthropic** | ✅ Active | claude-opus-4-6 | 2026-02-25 |
| **OpenAI** | ✅ Active | gpt-5.2 | 2026-02-25 |
| **Google** | ✅ Active | gemini-2.5-pro | 2026-02-25 |
| **Azure** | ✅ Active | gpt-4o | 2026-02-25 |
| **OpenRouter** | ✅ Active | All providers | 2026-02-25 |

---

## Best Practices

### 1. Use Balanced Strategy (Default)

The optimized configuration uses a balanced approach:
- Fast models for quick tasks (haiku, flash)
- Balanced models for most work (sonnet, gpt-4o)
- Flagship models for critical tasks (opus, gpt-5)

### 2. Set Up Multiple Providers

Having multiple providers ensures maximum uptime:

```bash
export ANTHROPIC_API_KEY="..."
export OPENAI_API_KEY="..."
export GOOGLE_GENERATIVE_AI_API_KEY="..."
```

### 3. Monitor Costs

Check your usage regularly:

```bash
# Daily cost check
cat ~/.cache/seycode/cost-tracking.json | jq '.today'

# Weekly cost
cat ~/.cache/seycode/cost-tracking.json | jq '.thisWeek'
```

### 4. Customize for Your Needs

Adjust model selection based on your priorities:

**Priority: Quality** → Use more flagship models
**Priority: Speed** → Use more fast models
**Priority: Cost** → Use more budget models

### 5. Keep Models Updated

Let SeyCode auto-update:

```json
{
  "modelRegistry": {
    "autoUpdate": true,
    "updateInterval": 3600000
  }
}
```

---

## Troubleshooting

### Issue: Models Not Falling Back

**Check:**
1. Is fallback enabled?
   ```json
   { "modelFallback": { "enabled": true } }
   ```

2. Are backup models configured?
   ```json
   {
     "model": {
       "primary": "claude-opus-4-6",
       "fallback": ["gpt-5.2", "claude-sonnet-4-0"]
     }
   }
   ```

3. Check logs:
   ```bash
   tail -f ~/.cache/seycode/logs/fallback.log
   ```

### Issue: High Costs

**Solutions:**
1. Adjust cost optimization:
   ```json
   {
     "costOptimization": {
       "budgetPerDay": 20.0,
       "preferCheaperModels": { "costThreshold": 3.0 }
     }
   }
   ```

2. Use more budget-friendly models:
   ```json
   {
     "agents": {
       "build": {
         "model": {
           "primary": "claude-haiku-4-5",
           "fallback": ["google/gemini-2.5-flash-lite"]
         }
       }
     }
   }
   ```

### Issue: Slow Responses

**Solutions:**
1. Use faster models:
   ```json
   {
     "model": {
       "primary": "claude-haiku-4-5",
       "fallback": ["google/gemini-2.5-flash"]
     }
   }
   ```

2. Reduce timeout:
   ```json
   { "modelFallback": { "timeoutMs": 15000 } }
   ```

### Issue: Registry Not Updating

**Solutions:**
1. Force update:
   ```bash
   rm ~/.cache/seycode/models.json
   # Restart SeyCode - it will fetch latest
   ```

2. Check internet connection
3. Verify models.dev is accessible:
   ```bash
   curl -s https://models.dev/api.json | head -20
   ```

---

## Migration Guide

### From Single Model to Multi-Model

**Before:**
```json
{
  "agents": {
    "build": {
      "model": "claude-sonnet-4"
    }
  }
}
```

**After:**
```json
{
  "agents": {
    "build": {
      "model": {
        "primary": "claude-3-7-sonnet-20250219",
        "fallback": ["claude-sonnet-4-0", "openai/gpt-4o"]
      }
    }
  }
}
```

### From Simple to Optimized

**Step 1**: Copy the optimized config
```bash
cp .seycode/seycode-optimized.json .seycode/seycode.json
```

**Step 2**: Add your API keys
```bash
export ANTHROPIC_API_KEY="..."
export OPENAI_API_KEY="..."
export GOOGLE_GENERATIVE_AI_API_KEY="..."
```

**Step 3**: Test it
```bash
bun dev
# Try various tasks to see different models in action
```

**Step 4**: Customize if needed
Edit `.seycode/seycode.json` to adjust model selections

---

## Files Reference

### Model Registry Database
- **Location**: `.seycode/model-registry.json`
- **Purpose**: Latest model information and recommendations
- **Updates**: Automatically every hour from models.dev

### Optimized Configuration
- **Location**: `.seycode/seycode-optimized.json`
- **Purpose**: Production-ready multi-model configuration
- **Usage**: Copy to `.seycode/seycode.json` to use

### Model Cache
- **Location**: `~/.cache/seycode/models.json`
- **Purpose**: Cached model data from models.dev
- **Updates**: Every hour automatically

### Usage Statistics
- **Location**: `~/.cache/seycode/usage-stats.json`
- **Purpose**: Track model usage and costs
- **Updates**: After each request

---

## Additional Resources

**Provider Documentation:**
- Anthropic: https://docs.anthropic.com/
- OpenAI: https://platform.openai.com/docs/
- Google: https://ai.google.dev/docs
- Azure: https://learn.microsoft.com/azure/ai-services/openai/
- OpenRouter: https://openrouter.ai/docs

**SeyCode Documentation:**
- PROVIDER_SETUP.md - Provider configuration
- GETTING_STARTED.md - General setup
- CLAUDE.md - Developer guide
- DOCUMENTATION_INDEX.md - All documentation

---

**Last Updated:** February 25, 2026
**Model Registry Version:** 1.0.0
**Auto-Update:** Enabled (hourly)
**Status:** ✅ All systems operational
