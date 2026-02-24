---
name: provider-adder
description: Add a new LLM provider to SeyCode
---

# Provider Adder

Add support for a new LLM provider to SeyCode.

## Process

### 1. Add to models.dev (Required First)

Submit PR to https://github.com/anomalyco/models.dev with:
- Provider metadata
- Available models
- Pricing information
- Authentication method

### 2. Add Provider Integration

In `packages/seycode/src/provider/provider.ts`:

```typescript
import { createProvider as createYourProvider } from "@ai-sdk/your-provider"

// Add provider creation logic
case "your-provider":
  return createYourProvider({
    apiKey: config.apiKey,
    // Provider-specific options
  })
```

### 3. Add Provider Configuration Schema

Add to provider config validation:

```typescript
const YourProviderConfig = z.object({
  apiKey: z.string().optional(),
  baseURL: z.string().optional(),
  // Provider-specific fields
})
```

### 4. Update Model Mapping

Add model mapping if provider uses different model IDs:

```typescript
const modelMap = {
  "your-provider": {
    "model-name": "actual-api-model-id"
  }
}
```

### 5. Test the Provider

```bash
# Set API key
export YOUR_PROVIDER_API_KEY="your-key"

# Test with SeyCode
bun dev

# Select your provider in agent configuration
```

### 6. Document Usage

Add example configuration to CLAUDE.md:

```json
{
  "agents": {
    "build": {
      "provider": "your-provider",
      "model": "your-model-name",
      "config": {
        "apiKey": "${YOUR_PROVIDER_API_KEY}"
      }
    }
  }
}
```

## Supported Provider Types

SeyCode supports any provider compatible with the Vercel AI SDK:
- OpenAI-compatible APIs
- Anthropic-style APIs
- Custom API formats

## Authentication Methods

- **API Key**: Most common, passed in headers
- **OAuth**: For providers like GitHub Copilot
- **Custom**: Implement in plugin

## Provider Features to Support

- ✅ Text generation
- ✅ Tool calling (function calling)
- ⚠️ Streaming (preferred)
- ⚠️ Context window limits
- ⚠️ Cost tracking

## Reference Implementations

- `@ai-sdk/anthropic` - Anthropic provider
- `@ai-sdk/openai` - OpenAI provider
- `@gitlab/gitlab-ai-provider` - Custom GitLab provider

$ARGUMENTS
