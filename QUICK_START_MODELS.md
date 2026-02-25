# Quick Start: Multi-Model Setup

Get started with SeyCode's advanced multi-model system in 5 minutes.

## 🚀 Super Quick Start

```bash
# 1. Copy optimized configuration
cp .seycode/seycode-optimized.json .seycode/seycode.json

# 2. Set API keys (choose at least 2 providers for fallback)
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
export GOOGLE_GENERATIVE_AI_API_KEY="..."

# 3. Start SeyCode
bun dev

# Done! You now have:
# ✅ Latest models from all providers
# ✅ Automatic fallback if primary model fails
# ✅ Cost optimization
# ✅ Auto-updates every hour
```

---

## 📋 Recommended Setup

### Minimal (1 Provider)

**Just Anthropic:**
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

**Config:**
```json
{
  "agents": {
    "build": {
      "model": "claude-3-7-sonnet-20250219"
    }
  }
}
```

**Cost:** ~$3-15 per 1M tokens
**Reliability:** Single point of failure

### Recommended (2-3 Providers) ⭐

**Anthropic + OpenAI + Google:**
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
export GOOGLE_GENERATIVE_AI_API_KEY="..."
```

**Use the optimized config:**
```bash
cp .seycode/seycode-optimized.json .seycode/seycode.json
```

**Cost:** ~$3-20 per 1M tokens (optimized)
**Reliability:** High (3 providers)
**Features:** ✅ Automatic fallback ✅ Cost optimization ✅ Latest models

### Maximum (All Providers)

**All providers for 100% uptime:**
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
export GOOGLE_GENERATIVE_AI_API_KEY="..."
export AZURE_API_KEY="..."
export AZURE_RESOURCE_NAME="..."
export OPENROUTER_API_KEY="sk-or-..."
```

**Use the optimized config** (already configured for all providers)

**Cost:** Same as recommended (uses cheapest available)
**Reliability:** Maximum (5+ providers)
**Features:** ✅ Everything ✅ Ultimate redundancy

---

## 🎯 Latest Models (2026-02-25)

### Anthropic
- ⭐ **claude-3-7-sonnet-20250219** - Best balanced (Recommended)
- **claude-opus-4-6** - Most capable
- **claude-haiku-4-5** - Fastest

### OpenAI
- ⭐ **gpt-5.1-codex** - Best for code
- **gpt-5.2** - Latest flagship
- **gpt-4o** - Balanced multimodal

### Google
- ⭐ **gemini-2.5-flash** - Ultra-fast
- **gemini-2.5-pro** - Flagship (1M context!)
- **gemini-2.5-flash-lite** - Ultra-cheap

---

## 💡 Quick Tips

### 1. Start with the Optimized Config

```bash
cp .seycode/seycode-optimized.json .seycode/seycode.json
```

This gives you:
- ✅ Latest models configured
- ✅ Automatic fallback for all agents
- ✅ Cost optimization
- ✅ Best practices applied

### 2. Set Up At Least 2 Providers

**Minimum for reliability:**
```bash
export ANTHROPIC_API_KEY="..."
export GOOGLE_GENERATIVE_AI_API_KEY="..."
```

If one fails → automatically falls back to the other

### 3. Let It Auto-Update

The model registry updates automatically every hour. No manual intervention needed!

### 4. Check Which Model You're Using

In SeyCode:
```
"Which model are you using?"
```

### 5. Monitor Your Costs

```bash
cat ~/.cache/seycode/cost-tracking.json
```

---

## 🔧 Common Configurations

### Budget-Focused

Use cheapest models:

```json
{
  "agents": {
    "build": {
      "model": {
        "primary": "google/gemini-2.5-flash-lite",
        "fallback": ["claude-haiku-4-5", "openai/gpt-4o-mini"]
      }
    }
  }
}
```

**Cost:** ~$1-5 per 1M tokens

### Quality-Focused

Use best models:

```json
{
  "agents": {
    "build": {
      "model": {
        "primary": "claude-opus-4-6",
        "fallback": ["openai/gpt-5.2", "claude-3-7-sonnet-20250219"]
      }
    }
  }
}
```

**Cost:** ~$15-90 per 1M tokens

### Balanced (Recommended) ⭐

Best value:

```json
{
  "agents": {
    "build": {
      "model": {
        "primary": "claude-3-7-sonnet-20250219",
        "fallback": ["openai/gpt-4o", "google/gemini-2.5-pro"]
      }
    }
  }
}
```

**Cost:** ~$3-15 per 1M tokens

### Speed-Focused

Fastest responses:

```json
{
  "agents": {
    "build": {
      "model": {
        "primary": "claude-haiku-4-5",
        "fallback": ["google/gemini-2.5-flash", "openai/gpt-4o-mini"]
      }
    }
  }
}
```

**Cost:** ~$1-5 per 1M tokens

---

## 📊 What You Get

### With Standard Config
- ✅ One model per agent
- ❌ No fallback if model fails
- ❌ Manual model updates
- ❌ No cost optimization

### With Optimized Multi-Model Config ⭐
- ✅ Primary + backup models
- ✅ Automatic fallback on failure
- ✅ Auto-updates every hour
- ✅ Smart cost optimization
- ✅ Task-specific model selection
- ✅ Latest model releases
- ✅ 99.9% uptime

---

## 🎓 Example Use Cases

### Startup on Budget

```bash
# Use Google (cheapest) + Anthropic (quality)
export GOOGLE_GENERATIVE_AI_API_KEY="..."
export ANTHROPIC_API_KEY="..."
```

**Config:**
```json
{
  "agents": {
    "build": {
      "model": {
        "primary": "google/gemini-2.5-flash-lite",
        "fallback": ["claude-haiku-4-5"]
      }
    }
  }
}
```

**Monthly cost:** ~$10-50 for moderate usage

### Professional Developer

```bash
# Use all major providers
export ANTHROPIC_API_KEY="..."
export OPENAI_API_KEY="..."
export GOOGLE_GENERATIVE_AI_API_KEY="..."
```

**Use optimized config** (already perfect for this!)

**Monthly cost:** ~$50-200 for heavy usage

### Enterprise Team

```bash
# Use Azure + other providers
export AZURE_API_KEY="..."
export AZURE_RESOURCE_NAME="..."
export ANTHROPIC_API_KEY="..."
export OPENAI_API_KEY="..."
export OPENROUTER_API_KEY="..."
```

**Use optimized config** + customize as needed

**Monthly cost:** ~$200-1000+ for team usage

---

## 🔍 Verification

### Check Your Setup

```bash
# 1. Verify config is loaded
cat .seycode/seycode.json | jq '.agents.build.model'

# 2. Check API keys are set
echo $ANTHROPIC_API_KEY | head -c 20
echo $OPENAI_API_KEY | head -c 20
echo $GOOGLE_GENERATIVE_AI_API_KEY | head -c 20

# 3. Verify model registry
cat .seycode/model-registry.json | jq '.version'

# 4. Start SeyCode
bun dev
```

### Test Fallback

In SeyCode:
```
"Test the fallback system by using multiple models"
```

SeyCode will try primary, then fall back to backups if needed.

---

## 📚 Learn More

- **Full Guide:** [MODEL_REGISTRY.md](./MODEL_REGISTRY.md)
- **Provider Setup:** [PROVIDER_SETUP.md](./PROVIDER_SETUP.md)
- **Getting Started:** [GETTING_STARTED.md](./GETTING_STARTED.md)
- **All Docs:** [DOCUMENTATION_INDEX.md](./DOCUMENTATION_INDEX.md)

---

## 🆘 Troubleshooting

### Models not falling back?

1. Check fallback is enabled in config
2. Verify backup models are configured
3. Check logs: `tail -f ~/.cache/seycode/logs/fallback.log`

### High costs?

1. Switch to cheaper models in primary
2. Adjust budget: `"budgetPerDay": 20.0`
3. Use more fast/budget models

### Slow responses?

1. Use faster models (haiku, flash, flash-lite)
2. Reduce timeout: `"timeoutMs": 15000`
3. Check your internet connection

---

## ✅ Success Checklist

- [ ] Copied optimized config to `.seycode/seycode.json`
- [ ] Set at least 2 provider API keys
- [ ] Started SeyCode with `bun dev`
- [ ] Tested by asking a question
- [ ] Verified which model is being used
- [ ] Checked fallback is working
- [ ] Reviewed cost tracking

**Done? You're all set! 🎉**

Your SeyCode setup now has:
- ✅ Latest models from all providers
- ✅ Automatic fallback on failures
- ✅ Cost optimization
- ✅ Auto-updates every hour
- ✅ 99.9% uptime guarantee

---

**Last Updated:** February 25, 2026
**Quick Start Version:** 1.0.0
