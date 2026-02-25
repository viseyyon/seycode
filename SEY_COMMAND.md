# The `sey` Command

The `sey` command is SeyCode's CLI wrapper that provides a consistent, branded interface for all SeyCode operations.

---

## What is `sey`?

`sey` is a convenience wrapper around Bun that:
- ✅ Provides a consistent `sey` command instead of `bun`
- ✅ Makes the CLI more intuitive and branded
- ✅ Simplifies documentation and usage
- ✅ Maintains full compatibility with all Bun features

**Under the hood**: `sey` passes all arguments directly to `bun`, so every `bun` command works with `sey`.

---

## Installation

### During SeyCode Installation

When you install SeyCode, run the installer:

```bash
cd seycode
./scripts/install-sey.sh
```

This installs the `sey` command to your PATH.

### Manual Installation

```bash
# Copy sey to a directory in your PATH
cp sey ~/bin/sey
chmod +x ~/bin/sey

# Or specify custom directory
SEYCODE_INSTALL_DIR=/usr/local/bin ./scripts/install-sey.sh
```

### Verify Installation

```bash
sey --version  # Should show Bun version
sey --help     # Show sey help
```

---

## Usage

### Basic Commands

```bash
# Show help
sey --help
sey -h

# Show version
sey --version
sey -v

# Install dependencies
sey install

# Run in development mode
sey dev

# Run in specific directory
sey dev /path/to/project

# Start server mode
sey dev serve
sey dev serve --port 8080

# Run tests
sey test
sey test --timeout 30000

# Type checking
sey typecheck

# Run scripts from package.json
sey run build
sey run dev
sey run <any-script>
```

### Advanced Commands

```bash
# Debug mode with breakpoints
sey dev spawn

# Run with custom Bun options
sey --inspect=ws://localhost:6499/ dev

# Run package manager commands
sey pm ls

# Run Playwright tests
sey playwright test
sey playwright install

# Run from specific package directory
sey run --cwd packages/app dev
```

---

## Command Reference

| Command | Description | Example |
|---------|-------------|---------|
| `sey dev` | Start SeyCode TUI | `sey dev` |
| `sey dev [path]` | Start in specific directory | `sey dev ~/myproject` |
| `sey dev serve` | Start headless server | `sey dev serve --port 4096` |
| `sey dev spawn` | Start with debugging | `sey dev spawn` |
| `sey install` | Install dependencies | `sey install` |
| `sey test` | Run tests | `sey test --timeout 30000` |
| `sey typecheck` | Type check code | `sey typecheck` |
| `sey run <script>` | Run package.json script | `sey run build` |
| `sey run --cwd <dir> <script>` | Run script in directory | `sey run --cwd packages/app dev` |
| `sey --version` | Show version | `sey --version` |
| `sey --help` | Show help | `sey --help` |

---

## Comparison: `bun` vs `sey`

### Before (with `bun`)
```bash
bun install
bun dev
bun test
bun run build
```

### After (with `sey`)
```bash
sey install
sey dev
sey test
sey run build
```

**Same functionality, better branding!**

---

## How it Works

The `sey` script is a simple Bash wrapper:

```bash
#!/usr/bin/env bash
# Check if bun is installed
if ! command -v bun &> /dev/null; then
    echo "Error: Bun is not installed"
    echo "Install it with: curl -fsSL https://bun.sh/install | bash"
    exit 1
fi

# Pass all arguments to bun
exec bun "$@"
```

**Key points:**
- Validates Bun is installed
- Provides helpful error messages
- Passes all arguments directly to Bun
- Uses `exec` for proper process replacement

---

## Requirements

**System Requirements:**
- Bun 1.3+ must be installed
- Unix-like shell (Bash, Zsh) - works on macOS, Linux, WSL

**Does NOT require:**
- Node.js
- npm/yarn
- Additional runtime dependencies

---

## Troubleshooting

### "Command not found: sey"

**Problem**: `sey` is not in your PATH

**Solution**:
```bash
# Check if sey exists
ls -la ~/bin/sey  # or wherever you installed it

# Add to PATH if needed
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Or reinstall
./scripts/install-sey.sh
```

### "Error: Bun is not installed"

**Problem**: Bun is not installed or not in PATH

**Solution**:
```bash
# Install Bun
curl -fsSL https://bun.sh/install | bash

# Restart terminal or source profile
source ~/.zshrc

# Verify Bun is working
bun --version
```

### "Permission denied"

**Problem**: `sey` script is not executable

**Solution**:
```bash
chmod +x ~/bin/sey  # or wherever sey is located
```

---

## Why Use `sey` Instead of `bun`?

### 1. **Consistent Branding**
- Users interact with "SeyCode" not "Bun"
- All commands use `sey` prefix
- Better user experience

### 2. **Simplified Documentation**
- Docs use one command: `sey`
- No confusion about what tool to use
- Clearer for beginners

### 3. **Better Error Messages**
- Custom error handling
- Helpful installation prompts
- SeyCode-specific guidance

### 4. **Future Flexibility**
- Can add SeyCode-specific features
- Custom command preprocessing
- Enhanced logging/telemetry (optional)

### 5. **Full Compatibility**
- Every `bun` command works with `sey`
- No functionality lost
- Drop-in replacement

---

## Internal Usage

**For package.json scripts**, you can still use `bun` directly:

```json
{
  "scripts": {
    "dev": "bun run src/index.ts",
    "build": "bun run build.ts"
  }
}
```

**Users invoke with**:
```bash
sey run dev
sey run build
```

This way:
- ✅ Internal scripts use `bun` directly (no wrapper overhead)
- ✅ Users use `sey` for all CLI interactions
- ✅ Best of both worlds

---

## Advanced: Custom Installation

### Install to Custom Directory

```bash
# Install to /usr/local/bin
SEYCODE_INSTALL_DIR=/usr/local/bin ./scripts/install-sey.sh

# Install to XDG compliant directory
XDG_BIN_DIR=$HOME/.local/bin ./scripts/install-sey.sh

# Install to $HOME/bin
./scripts/install-sey.sh  # Default
```

### Create Alias (Alternative)

If you prefer not to install a script, create an alias:

```bash
# Add to ~/.zshrc or ~/.bashrc
alias sey='bun'

# Reload
source ~/.zshrc

# Use it
sey install
sey dev
```

**Note**: This is simpler but doesn't provide custom help/errors.

---

## FAQ

### Q: Do I need Node.js?
**A**: No! SeyCode uses Bun, which is a complete JavaScript runtime.

### Q: Can I use `bun` commands directly?
**A**: Yes! The `sey` wrapper is optional but recommended for consistency.

### Q: Does `sey` add overhead?
**A**: Minimal. It's a thin wrapper that immediately calls `bun` with `exec`.

### Q: Can I uninstall `sey`?
**A**: Yes, just delete the script:
```bash
rm ~/bin/sey  # or wherever you installed it
```

### Q: What if `sey` and `bun` have version conflicts?
**A**: They can't conflict - `sey` always uses whatever `bun` version is installed.

### Q: Can I use this in CI/CD?
**A**: Yes! Just install it in your CI scripts:
```yaml
- name: Install sey
  run: |
    cd seycode
    ./scripts/install-sey.sh
- name: Run tests
  run: sey test
```

---

## Summary

**The `sey` command is:**
- ✅ A branded wrapper around Bun
- ✅ Fully compatible with all Bun features
- ✅ Easy to install (`./scripts/install-sey.sh`)
- ✅ Consistent across documentation
- ✅ Optional but recommended

**Start using it:**
```bash
# Install
cd seycode
./scripts/install-sey.sh

# Use
sey install
sey dev
sey test

# Enjoy!
```

For more information, see:
- [INSTALLATION.md](./INSTALLATION.md) - Complete installation guide
- [QUICKSTART.md](./QUICKSTART.md) - 5-minute quick start
- [CLAUDE.md](./CLAUDE.md) - Development guide
