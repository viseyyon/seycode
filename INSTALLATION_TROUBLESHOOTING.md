# SeyCode Installation Troubleshooting Guide

## Issue: "Failed to download SeyCode"

If you see this error during installation:

```
Downloading SeyCode...
✗ Failed to download SeyCode
Make sure you have access to: https://github.com/viseyyon/seycode
```

---

## Quick Fix - Try This First

Run the updated installer with better error messages:

```bash
curl -fsSL https://raw.githubusercontent.com/viseyyon/seycode/dev/install.sh | bash
```

The new version will show you exactly what went wrong.

---

## Common Causes

### 1. Git Not Installed ❌

**Check:**
```bash
git --version
```

**Fix:**
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install git

# CentOS/RHEL/Rocky Linux
sudo yum install git

# macOS
brew install git
```

### 2. Network/Firewall Issues 🔥

**Test connectivity:**
```bash
# Test GitHub access
curl -I https://github.com

# Test repository access
curl -I https://github.com/viseyyon/seycode
```

**Expected output:**
```
HTTP/2 200
```

**If blocked by firewall:**
- Ask your network admin to allow access to `github.com`
- Or try using a VPN
- Or download manually (see below)

### 3. Git Configuration Issues ⚙️

**Check git config:**
```bash
git config --global --list
```

**Set basic config if missing:**
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### 4. Branch Doesn't Exist 🌿

The installer uses the `dev` branch. Verify it exists:

```bash
# Check available branches
git ls-remote --heads https://github.com/viseyyon/seycode.git
```

You should see `refs/heads/dev` in the output.

---

## Manual Installation (If Automatic Fails)

### Option 1: Download ZIP

```bash
# Download repository as ZIP
cd ~
curl -L https://github.com/viseyyon/seycode/archive/refs/heads/dev.zip -o seycode.zip

# Extract
unzip seycode.zip

# Rename to .seycode
rm -rf ~/.seycode
mv seycode-dev ~/.seycode

# Run local installer
cd ~/.seycode
./install-local.sh
```

### Option 2: Clone with Verbose Output

```bash
# Clone with detailed error messages
git clone --verbose --branch dev https://github.com/viseyyon/seycode.git ~/.seycode

# If it works, run local installer
cd ~/.seycode
./install-local.sh
```

### Option 3: Clone via SSH (if you have SSH keys)

```bash
# Clone using SSH
git clone --depth 1 --branch dev git@github.com:viseyyon/seycode.git ~/.seycode

# Run local installer
cd ~/.seycode
./install-local.sh
```

---

## Debug Information

### Get Detailed Error Log

With the updated installer, errors are logged to `/tmp/seycode-git-error.log`:

```bash
# Run installer
curl -fsSL https://raw.githubusercontent.com/viseyyon/seycode/dev/install.sh | bash

# If it fails, check the log
cat /tmp/seycode-git-error.log
```

### Common Error Messages

#### "fatal: could not read Username"
**Cause**: Git is trying to use credentials but none provided
**Fix**: Repository is public, should not require auth. Try:
```bash
git config --global credential.helper store
```

#### "fatal: unable to access 'https://github.com/...': Could not resolve host"
**Cause**: DNS or network issue
**Fix**: Check internet connection and DNS:
```bash
ping github.com
nslookup github.com
```

#### "fatal: Remote branch dev not found"
**Cause**: Branch name incorrect or doesn't exist
**Fix**: Verify branch exists (it does, as of this writing)

#### "gnutls_handshake() failed: The TLS connection was non-properly terminated"
**Cause**: SSL/TLS issue with older git versions
**Fix**: Update git:
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install --only-upgrade git

# Or try HTTP instead (less secure):
git clone --depth 1 --branch dev http://github.com/viseyyon/seycode.git ~/.seycode
```

---

## Verify Repository Access

### From Your Server

```bash
# Test 1: Can you reach GitHub?
curl -I https://github.com
# Should return: HTTP/2 200

# Test 2: Can you access the repository?
curl -I https://github.com/viseyyon/seycode
# Should return: HTTP/2 200

# Test 3: Can you download raw file?
curl -fsSL https://raw.githubusercontent.com/viseyyon/seycode/dev/README.md | head -5
# Should show first 5 lines of README

# Test 4: Can git clone work?
cd /tmp
git clone --depth 1 --branch dev https://github.com/viseyyon/seycode.git test-clone
cd test-clone
ls -la
# Should show repository files
cd ..
rm -rf test-clone
```

If all tests pass, the automatic installer should work.

---

## Still Having Issues?

### Collect Debug Information

```bash
# System info
uname -a
git --version
curl --version

# Network tests
curl -I https://github.com
curl -I https://github.com/viseyyon/seycode

# Git test
git ls-remote https://github.com/viseyyon/seycode.git HEAD

# DNS test
nslookup github.com
```

### Check Repository Status

The repository is **PUBLIC** and should be accessible without authentication:
- Repository: https://github.com/viseyyon/seycode
- Branch: `dev`
- Visibility: Public
- No authentication required

### Try Alternative Installation

If git clone consistently fails, use the manual ZIP download method above.

---

## After Successful Installation

### Verify Installation

```bash
# Check installation
sey --version

# Check location
which sey

# Check SeyCode directory
ls -la ~/.seycode/

# Verify PATH
echo $PATH | grep -o '.local/bin\|.seycode/bin'
```

### First Run

```bash
# Reload shell
source ~/.bashrc  # or ~/.zshrc

# Set API key
export ANTHROPIC_API_KEY="sk-ant-your-key-here"
echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.bashrc

# Start SeyCode
sey dev
```

---

## Summary

Most installation failures are due to:
1. ✅ Git not installed → Install git
2. ✅ Network/firewall blocking GitHub → Allow access or use VPN
3. ✅ Git configuration issues → Set basic config
4. ✅ Outdated git version → Update git

**The updated installer (commit `90c8ff030`) now provides detailed error messages to help diagnose the exact issue.**

---

## Quick Reference

```bash
# Check prerequisites
git --version
curl --version

# Test GitHub access
curl -I https://github.com/viseyyon/seycode

# Install SeyCode (automatic)
curl -fsSL https://raw.githubusercontent.com/viseyyon/seycode/dev/install.sh | bash

# Or install manually (if automatic fails)
curl -L https://github.com/viseyyon/seycode/archive/refs/heads/dev.zip -o seycode.zip
unzip seycode.zip
mv seycode-dev ~/.seycode
cd ~/.seycode
./install-local.sh
```

---

**Updated**: 2026-02-25
**Installer Version**: Latest (with diagnostics)
**Status**: Repository is public and accessible
