# Provider Setup Guide

Complete guide for configuring AI providers in SeyCode.

## Supported Providers

SeyCode supports **30+ AI providers** out of the box. This guide covers the most popular providers:

- **Anthropic** (Claude models)
- **OpenAI** (GPT models)
- **Google** (Gemini models)
- **Azure AI Foundry** (Azure OpenAI)
- **OpenRouter** (Access to 100+ models from various providers)
- Plus: Amazon Bedrock, Vertex AI, GitHub Copilot, and many more

---

## Quick Start

### 1. Anthropic (Claude)

The default and recommended provider for SeyCode.

**Setup:**

```bash
# Set API key
export ANTHROPIC_API_KEY="sk-ant-..."

# Or add to your shell profile
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.zshrc
```

**Configuration in `.seycode/seycode.json`:**

```json
{
  "agents": {
    "build": {
      "model": "claude-sonnet-4",
      "temperature": 0.7
    }
  }
}
```

**Available Models:**
- `claude-opus-4` - Most capable
- `claude-sonnet-4` - Balanced (recommended)
- `claude-haiku-4` - Fast and efficient

**Get API Key:** https://console.anthropic.com/

---

### 2. OpenAI (GPT)

**Setup:**

```bash
# Set API key
export OPENAI_API_KEY="sk-..."

# Or add to your shell profile
echo 'export OPENAI_API_KEY="sk-..."' >> ~/.zshrc
```

**Configuration:**

```json
{
  "agents": {
    "build": {
      "model": "openai/gpt-4o",
      "temperature": 0.7
    }
  }
}
```

**Available Models:**
- `openai/gpt-4o` - Multimodal, fast
- `openai/gpt-4-turbo` - Previous generation
- `openai/o1` - Reasoning model
- `openai/o1-mini` - Fast reasoning model

**Get API Key:** https://platform.openai.com/api-keys

---

### 3. Google (Gemini)

**Setup:**

```bash
# Set API key
export GOOGLE_GENERATIVE_AI_API_KEY="..."

# Or add to your shell profile
echo 'export GOOGLE_GENERATIVE_AI_API_KEY="..."' >> ~/.zshrc
```

**Configuration:**

```json
{
  "agents": {
    "build": {
      "model": "google/gemini-2.0-flash-exp",
      "temperature": 0.7
    }
  }
}
```

**Available Models:**
- `google/gemini-2.0-flash-exp` - Latest, fastest
- `google/gemini-1.5-pro` - Most capable
- `google/gemini-1.5-flash` - Fast and efficient

**Get API Key:** https://aistudio.google.com/app/apikey

---

### 4. Azure AI Foundry (Azure OpenAI)

Azure AI Foundry uses Azure OpenAI Service. You can deploy OpenAI models in your Azure subscription.

**Setup Method 1: Using Azure OpenAI Resource**

```bash
# Set Azure OpenAI credentials
export AZURE_API_KEY="your-azure-api-key"
export AZURE_RESOURCE_NAME="your-resource-name"
```

**Configuration:**

```json
{
  "provider": {
    "azure": {
      "options": {
        "apiKey": "${AZURE_API_KEY}",
        "resourceName": "${AZURE_RESOURCE_NAME}"
      }
    }
  },
  "agents": {
    "build": {
      "model": "azure/gpt-4o",
      "temperature": 0.7
    }
  }
}
```

**Setup Method 2: Using Azure Cognitive Services**

```bash
# Set Azure Cognitive Services credentials
export AZURE_COGNITIVE_SERVICES_API_KEY="..."
export AZURE_COGNITIVE_SERVICES_RESOURCE_NAME="..."
```

**Configuration:**

```json
{
  "provider": {
    "azure-cognitive-services": {
      "options": {
        "apiKey": "${AZURE_COGNITIVE_SERVICES_API_KEY}"
      }
    }
  },
  "agents": {
    "build": {
      "model": "azure-cognitive-services/gpt-4o",
      "temperature": 0.7
    }
  }
}
```

**Setup Method 3: Using Azure AI Foundry Deployment**

If you have models deployed in Azure AI Foundry:

```bash
export AZURE_API_KEY="..."
export AZURE_RESOURCE_NAME="your-foundry-resource"
export AZURE_DEPLOYMENT_NAME="your-deployment-name"
```

**Configuration:**

```json
{
  "provider": {
    "azure": {
      "options": {
        "apiKey": "${AZURE_API_KEY}",
        "resourceName": "${AZURE_RESOURCE_NAME}",
        "deployment": "${AZURE_DEPLOYMENT_NAME}"
      }
    }
  },
  "agents": {
    "build": {
      "model": "azure/${AZURE_DEPLOYMENT_NAME}",
      "temperature": 0.7
    }
  }
}
```

**Available Models (through Azure):**
- `azure/gpt-4o` - GPT-4 Optimized
- `azure/gpt-4-turbo` - GPT-4 Turbo
- `azure/gpt-35-turbo` - GPT-3.5 Turbo
- Or use your custom deployment name

**Setup Azure:**
1. Create Azure OpenAI resource: https://portal.azure.com/
2. Deploy a model (e.g., GPT-4o)
3. Get API key and resource name
4. Configure SeyCode with credentials above

---

### 5. OpenRouter

Access 100+ models from various providers through a single API.

**Setup:**

```bash
# Set OpenRouter API key
export OPENROUTER_API_KEY="sk-or-..."

# Or add to your shell profile
echo 'export OPENROUTER_API_KEY="sk-or-..."' >> ~/.zshrc
```

**Configuration:**

```json
{
  "agents": {
    "build": {
      "model": "openrouter/anthropic/claude-sonnet-4",
      "temperature": 0.7
    }
  }
}
```

**Available Models (Examples):**
- `openrouter/anthropic/claude-opus-4` - Claude Opus via OpenRouter
- `openrouter/anthropic/claude-sonnet-4` - Claude Sonnet via OpenRouter
- `openrouter/openai/gpt-4o` - GPT-4o via OpenRouter
- `openrouter/google/gemini-2.0-flash-exp` - Gemini via OpenRouter
- `openrouter/meta-llama/llama-3.3-70b` - Llama models
- `openrouter/deepseek/deepseek-chat` - DeepSeek models
- And 100+ more models

**Get API Key:** https://openrouter.ai/keys

**Benefits of OpenRouter:**
- Single API key for all providers
- Automatic fallback if one provider is down
- Cost tracking across providers
- Access to models not available elsewhere

---

## Advanced Configuration

### Multiple Providers

You can configure multiple providers and switch between them:

```json
{
  "provider": {
    "anthropic": {
      "options": {
        "apiKey": "${ANTHROPIC_API_KEY}"
      }
    },
    "openai": {
      "options": {
        "apiKey": "${OPENAI_API_KEY}"
      }
    },
    "google": {
      "options": {
        "apiKey": "${GOOGLE_GENERATIVE_AI_API_KEY}"
      }
    },
    "azure": {
      "options": {
        "apiKey": "${AZURE_API_KEY}",
        "resourceName": "${AZURE_RESOURCE_NAME}"
      }
    },
    "openrouter": {
      "options": {
        "apiKey": "${OPENROUTER_API_KEY}"
      }
    }
  },
  "agents": {
    "build": {
      "model": "claude-sonnet-4"
    },
    "plan": {
      "model": "openai/gpt-4o"
    },
    "test-generator": {
      "model": "google/gemini-2.0-flash-exp"
    },
    "security-auditor": {
      "model": "azure/gpt-4o"
    }
  }
}
```

### Per-Agent Model Configuration

Different agents can use different models:

```json
{
  "agents": {
    "build": {
      "model": "claude-sonnet-4",
      "temperature": 0.7
    },
    "plan": {
      "model": "claude-haiku-4",
      "temperature": 0.5
    },
    "security-auditor": {
      "model": "openai/gpt-4o",
      "temperature": 0.3
    },
    "test-generator": {
      "model": "google/gemini-2.0-flash-exp",
      "temperature": 0.8
    },
    "perf-analyzer": {
      "model": "openrouter/anthropic/claude-opus-4",
      "temperature": 0.6
    }
  }
}
```

### Cost Optimization Strategy

Use different models based on task complexity:

```json
{
  "agents": {
    "build": {
      "model": "claude-sonnet-4",
      "temperature": 0.7,
      "description": "Balanced for most tasks"
    },
    "plan": {
      "model": "claude-haiku-4",
      "temperature": 0.5,
      "description": "Fast and cheap for planning"
    },
    "prompt-enhancer": {
      "model": "google/gemini-2.0-flash-exp",
      "temperature": 0.7,
      "description": "Fast prompt optimization"
    },
    "code-reviewer": {
      "model": "claude-opus-4",
      "temperature": 0.3,
      "description": "Most thorough for code review"
    },
    "doc-writer": {
      "model": "openai/gpt-4o",
      "temperature": 0.8,
      "description": "Creative for documentation"
    }
  }
}
```

### Environment-Specific Configuration

**Development:**
```json
{
  "agents": {
    "build": {
      "model": "claude-haiku-4"
    }
  }
}
```

**Production:**
```json
{
  "agents": {
    "build": {
      "model": "claude-opus-4"
    }
  }
}
```

---

## Provider Comparison

| Provider | Best For | Pros | Cons | Cost |
|----------|----------|------|------|------|
| **Anthropic** | Code generation, reasoning | Excellent code quality, large context | Limited availability | $$ |
| **OpenAI** | General tasks, multimodal | Good balance, wide adoption | Can be expensive | $$$ |
| **Google** | Fast responses, multimodal | Very fast, free tier | Less code-focused | $ |
| **Azure** | Enterprise, compliance | Security, SLA, regional | Setup complexity | $$$ |
| **OpenRouter** | Access to all models | Single API, fallback | Additional markup | Varies |

---

## Troubleshooting

### Provider Not Working

**Check API key:**
```bash
# For Anthropic
echo $ANTHROPIC_API_KEY

# For OpenAI
echo $OPENAI_API_KEY

# For Google
echo $GOOGLE_GENERATIVE_AI_API_KEY

# For Azure
echo $AZURE_API_KEY
echo $AZURE_RESOURCE_NAME
```

**Test API key:**
```bash
# Anthropic
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-haiku-4","max_tokens":10,"messages":[{"role":"user","content":"Hi"}]}'

# OpenAI
curl https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"gpt-4o","messages":[{"role":"user","content":"Hi"}],"max_tokens":10}'

# Google
curl "https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash-exp:generateContent?key=$GOOGLE_GENERATIVE_AI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"contents":[{"parts":[{"text":"Hi"}]}]}'
```

### Azure-Specific Issues

**Error: "Resource not found"**
- Verify `AZURE_RESOURCE_NAME` is correct
- Check that the resource exists in your subscription

**Error: "Deployment not found"**
- Ensure model is deployed in Azure AI Foundry
- Verify deployment name matches configuration

**Error: "Authentication failed"**
- Check API key is correct
- Verify key hasn't expired
- Ensure key has proper permissions

### Rate Limits

Different providers have different rate limits:

| Provider | Free Tier | Paid Tier |
|----------|-----------|-----------|
| Anthropic | None | Based on plan |
| OpenAI | Limited | Based on plan |
| Google | 15 RPM | 360+ RPM |
| Azure | None | Configured in deployment |
| OpenRouter | Varies | Varies by model |

**Handle rate limits:**
```json
{
  "agents": {
    "build": {
      "model": "claude-sonnet-4",
      "temperature": 0.7,
      "maxRetries": 3,
      "retryDelay": 1000
    }
  }
}
```

---

## Model Selection Guide

### For Code Generation

**Best:**
- `claude-sonnet-4` (Anthropic) - ⭐ Recommended
- `openai/gpt-4o` (OpenAI)
- `google/gemini-2.0-flash-exp` (Google)

**Budget:**
- `claude-haiku-4` (Anthropic)
- `google/gemini-1.5-flash` (Google)

### For Code Review

**Best:**
- `claude-opus-4` (Anthropic) - Most thorough
- `openai/gpt-4o` (OpenAI)

### For Documentation

**Best:**
- `openai/gpt-4o` (OpenAI) - More creative
- `google/gemini-2.0-flash-exp` (Google) - Fast

### For Quick Tasks

**Best:**
- `claude-haiku-4` (Anthropic)
- `google/gemini-2.0-flash-exp` (Google)

### For Security Audits

**Best:**
- `claude-opus-4` (Anthropic)
- `openai/gpt-4o` (OpenAI)

---

## All Available Providers

SeyCode supports **30+ providers** through models.dev:

- **Major Providers:** Anthropic, OpenAI, Google, Azure, OpenRouter
- **Cloud Providers:** Amazon Bedrock, Google Vertex, Azure Cognitive Services
- **Specialized:** GitHub Copilot, GitLab, Perplexity, Groq, Cerebras
- **Alternative:** DeepSeek, Together AI, Fireworks AI, DeepInfra, Replicate
- **Regional:** Alibaba, Cohere, Mistral, and more

**See full list:**
```bash
# List all available providers
curl -s https://models.dev/api.json | jq 'keys'
```

---

## Configuration Files

### Global Configuration

`~/.config/seycode/seycode.json`:
```json
{
  "provider": {
    "anthropic": {
      "options": {
        "apiKey": "${ANTHROPIC_API_KEY}"
      }
    }
  }
}
```

### Project Configuration

`.seycode/seycode.json`:
```json
{
  "agents": {
    "build": {
      "model": "claude-sonnet-4"
    }
  }
}
```

### Environment Variables

`.env`:
```bash
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
GOOGLE_GENERATIVE_AI_API_KEY=...
AZURE_API_KEY=...
AZURE_RESOURCE_NAME=...
OPENROUTER_API_KEY=sk-or-...
```

---

## Security Best Practices

**1. Never commit API keys**
```bash
# Add to .gitignore
echo ".env" >> .gitignore
echo ".seycode/seycode.json" >> .gitignore  # If it contains keys
```

**2. Use environment variables**
```json
{
  "provider": {
    "anthropic": {
      "options": {
        "apiKey": "${ANTHROPIC_API_KEY}"
      }
    }
  }
}
```

**3. Rotate keys regularly**
- Rotate keys every 90 days
- Use different keys for development and production
- Revoke unused keys

**4. Use Azure Key Vault (for Azure)**
```bash
# Use managed identity instead of API keys
export AZURE_USE_MANAGED_IDENTITY=true
```

---

## Getting Help

**Provider-specific documentation:**
- Anthropic: https://docs.anthropic.com/
- OpenAI: https://platform.openai.com/docs/
- Google: https://ai.google.dev/docs
- Azure: https://learn.microsoft.com/azure/ai-services/openai/
- OpenRouter: https://openrouter.ai/docs

**SeyCode documentation:**
- GETTING_STARTED.md - General setup
- CLAUDE.md - Developer guide
- DOCUMENTATION_INDEX.md - All documentation

**Support:**
- GitHub Issues: https://github.com/viseyyon/seycode/issues
- Documentation: All *.md files in repository

---

**Last Updated:** February 25, 2026
**Status:** ✅ All providers tested and verified
