---
name: lsp-configurator
description: Configure Language Server Protocol (LSP) integration for SeyCode
---

# LSP Configurator

Configure language servers to enhance SeyCode's code intelligence.

## Current LSP Support

Built-in language servers in `packages/seycode/src/lsp/server.ts`:
- TypeScript/JavaScript (tsserver)
- Python (pyright or ty)
- Go (gopls)
- Rust (rust-analyzer)
- And more...

## Configuration

### In seycode.json

```json
{
  "lsp": {
    "typescript": {
      "disabled": false,
      "command": ["typescript-language-server", "--stdio"],
      "extensions": ["ts", "tsx", "js", "jsx"],
      "env": {
        "NODE_ENV": "production"
      }
    },
    "python": {
      "disabled": false,
      "command": ["pyright-langserver", "--stdio"]
    }
  }
}
```

### Adding a New Language Server

1. **Install the language server**:
```bash
npm install -g your-language-server
# or
brew install your-language-server
```

2. **Add configuration**:
```json
{
  "lsp": {
    "your-language": {
      "command": ["your-language-server", "--stdio"],
      "extensions": ["ext1", "ext2"],
      "rootPatterns": ["package.json", "go.mod"]
    }
  }
}
```

3. **Test the server**:
```bash
# Start SeyCode
bun dev

# Open a file with the extension
# LSP should start automatically
```

## LSP Features Available

When properly configured, LSP provides:
- ✅ **Document symbols** - Outline of functions/classes
- ✅ **Go to definition** - Jump to symbol definition
- ✅ **Find references** - Find all usages
- ✅ **Hover information** - Type info and documentation
- ✅ **Diagnostics** - Errors and warnings
- ⚠️ **Code completion** - Autocomplete suggestions (experimental)

## Using LSP in Tools

The `lsp` tool exposes LSP features to the LLM:

```typescript
// Get document symbols
await lsp({
  action: "symbols",
  file: "src/index.ts"
})

// Go to definition
await lsp({
  action: "definition",
  file: "src/index.ts",
  position: { line: 10, character: 5 }
})

// Find references
await lsp({
  action: "references",
  file: "src/index.ts",
  position: { line: 10, character: 5 }
})
```

## Troubleshooting

### LSP not starting?

1. **Check server is installed**:
```bash
which typescript-language-server
which pyright-langserver
```

2. **Check configuration**:
```bash
# View current config
cat seycode.json | grep -A 10 lsp
```

3. **Check logs**:
```bash
# LSP logs appear in terminal running SeyCode
# Look for "LSP:" prefixed messages
```

### LSP slow or hanging?

1. **Disable unused servers**:
```json
{
  "lsp": {
    "typescript": { "disabled": true }
  }
}
```

2. **Limit file scanning**:
```json
{
  "lsp": {
    "typescript": {
      "excludePatterns": ["node_modules/**", "dist/**"]
    }
  }
}
```

### Wrong language server starting?

Check file extension mapping:
```json
{
  "lsp": {
    "typescript": {
      "extensions": ["ts", "tsx"]  // Remove "js" if using separate JS server
    }
  }
}
```

## Advanced Configuration

### Multiple servers for same language
```json
{
  "lsp": {
    "typescript-strict": {
      "command": ["tsserver", "--strict"],
      "extensions": ["ts"]
    },
    "javascript-loose": {
      "command": ["tsserver"],
      "extensions": ["js"]
    }
  }
}
```

### Custom initialization options
```json
{
  "lsp": {
    "python": {
      "command": ["pyright-langserver", "--stdio"],
      "initializationOptions": {
        "python": {
          "analysis": {
            "typeCheckingMode": "strict"
          }
        }
      }
    }
  }
}
```

## Popular Language Servers

| Language   | Server                          | Install                                |
| ---------- | ------------------------------- | -------------------------------------- |
| TypeScript | typescript-language-server      | `npm i -g typescript-language-server`  |
| Python     | pyright / pylsp                 | `pip install pyright`                  |
| Go         | gopls                           | `go install golang.org/x/tools/gopls`  |
| Rust       | rust-analyzer                   | `rustup component add rust-analyzer`   |
| C/C++      | clangd                          | `brew install llvm`                    |
| Java       | jdtls                           | Download from Eclipse                  |
| Ruby       | solargraph                      | `gem install solargraph`               |
| PHP        | intelephense                    | `npm i -g intelephense`                |

## Reference

- LSP implementation: `packages/seycode/src/lsp/`
- LSP tool: `packages/seycode/src/tool/builtin/lsp.ts`
- Server configs: `packages/seycode/src/lsp/server.ts`

$ARGUMENTS
