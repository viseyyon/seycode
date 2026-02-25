# SeyCode Installation - User Guide

**For end users**: Just run one command and you're done!

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/viseyyon/seycode/dev/install.sh | bash
```

That's it! This installs everything automatically.

## What Gets Installed

The installer handles:
- ✅ Runtime environment (Bun - installed automatically)
- ✅ SeyCode application
- ✅ The `sey` command
- ✅ All dependencies

## After Installation

1. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

2. **Get API key** from Anthropic:
   - Visit: https://console.anthropic.com/
   - Create an API key
   - Copy it (starts with `sk-ant-`)

3. **Set API key**:
   ```bash
   export ANTHROPIC_API_KEY="sk-ant-your-key-here"
   echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.zshrc
   ```

4. **Start using SeyCode**:
   ```bash
   sey dev                    # Start in current directory
   sey dev ~/myproject        # Start in specific project
   sey --help                 # Show help
   ```

## Manual Installation

If you prefer to clone first:

```bash
# Clone repository
git clone https://github.com/viseyyon/seycode.git
cd seycode

# Run installer
./install.sh
```

## What is Bun?

Bun is the JavaScript runtime that SeyCode uses internally. You don't need to know about it or install it separately - the `sey` installer handles it automatically.

## Commands

Once installed, use the `sey` command:

```bash
sey dev                # Start SeyCode
sey dev /path          # Start in specific directory
sey test               # Run tests
sey --help             # Show help
sey --version          # Show version
```

## Troubleshooting

### "Command not found: sey"

```bash
# Check if installed
ls -la ~/.local/bin/sey

# If not there, reinstall
curl -fsSL https://raw.githubusercontent.com/viseyyon/seycode/dev/install.sh | bash
```

### "Runtime not available"

```bash
# Reinstall (includes runtime)
curl -fsSL https://raw.githubusercontent.com/viseyyon/seycode/dev/install.sh | bash
```

## Uninstall

```bash
# Remove sey command
rm ~/.local/bin/sey  # or ~/bin/sey

# Remove SeyCode installation
rm -rf ~/.seycode

# Remove runtime (optional)
rm -rf ~/.bun
```

## Support

- Documentation: `~/.seycode/QUICKSTART.md`
- Full Guide: `~/.seycode/INSTALLATION.md`
- GitHub: https://github.com/viseyyon/seycode

---

**Note**: Users should never need to interact with or know about Bun. Everything is handled by the `sey` command.
