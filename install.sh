#!/usr/bin/env bash
# SeyCode Installer - One command installation
# Usage: curl -fsSL https://seycode.ai/install | bash

set -euo pipefail

# Check if terminal supports colors
if [ -t 1 ] && command -v tput >/dev/null 2>&1 && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
    # Colors
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    BLUE='\033[0;34m'
    BOLD='\033[1m'
    NC='\033[0m'
else
    # No colors
    GREEN=''
    YELLOW=''
    RED=''
    BLUE=''
    BOLD=''
    NC=''
fi

echo ""
echo "======================================"
echo "  Installing SeyCode"
echo "======================================"
echo ""

# Check for existing installation and conflicts
CONFLICTS_FOUND=0

if [ -d "$HOME/.seycode" ]; then
    printf "${YELLOW}⚠ Existing SeyCode installation found at ~/.seycode${NC}\n"
    CONFLICTS_FOUND=1
fi

if [ -f "$HOME/.local/bin/sey" ] || [ -f "$HOME/bin/sey" ]; then
    printf "${YELLOW}⚠ Existing 'sey' command found${NC}\n"
    CONFLICTS_FOUND=1
fi

if [ $CONFLICTS_FOUND -eq 1 ]; then
    printf "${YELLOW}  Automatically removing old installation...${NC}\n"

    # Remove old installation
    rm -rf "$HOME/.seycode" 2>/dev/null
    rm -f "$HOME/.local/bin/sey" 2>/dev/null
    rm -f "$HOME/bin/sey" 2>/dev/null
    rm -f "$HOME/.seycode/bin/sey" 2>/dev/null

    # Remove any cached data
    rm -rf "$HOME/.cache/seycode" 2>/dev/null

    printf "${GREEN}✓ Removed old installation${NC}\n"
    printf "${GREEN}  Starting fresh installation...${NC}\n"
    echo ""
fi

# Determine installation directory
if [ -n "${SEYCODE_INSTALL_DIR:-}" ]; then
    INSTALL_DIR="$SEYCODE_INSTALL_DIR"
elif [ -n "${XDG_BIN_DIR:-}" ]; then
    INSTALL_DIR="$XDG_BIN_DIR"
elif [ -d "$HOME/.local/bin" ] || mkdir -p "$HOME/.local/bin" 2>/dev/null; then
    INSTALL_DIR="$HOME/.local/bin"
elif [ -d "$HOME/bin" ] || mkdir -p "$HOME/bin" 2>/dev/null; then
    INSTALL_DIR="$HOME/bin"
else
    INSTALL_DIR="$HOME/.seycode/bin"
    mkdir -p "$INSTALL_DIR"
fi

printf "${BLUE}Installing to: $INSTALL_DIR${NC}\n"
echo ""

# Detect OS and architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
    Darwin*)
        OS_TYPE="darwin"
        ;;
    Linux*)
        OS_TYPE="linux"
        ;;
    *)
        printf "${RED}✗ Unsupported operating system: $OS${NC}\n"
        exit 1
        ;;
esac

case "$ARCH" in
    x86_64|amd64)
        ARCH_TYPE="x64"
        ;;
    arm64|aarch64)
        ARCH_TYPE="aarch64"
        ;;
    *)
        printf "${RED}✗ Unsupported architecture: $ARCH${NC}\n"
        exit 1
        ;;
esac

printf "${GREEN}✓ Detected: $OS_TYPE-$ARCH_TYPE${NC}\n"
echo ""

# Install Bun runtime (silently, as a dependency)
printf "${BLUE}Installing runtime...${NC}\n"
if ! command -v bun &> /dev/null; then
    if curl -fsSL https://bun.sh/install | bash > /dev/null 2>&1; then
        printf "${GREEN}✓ Runtime installed${NC}\n"
        export PATH="$HOME/.bun/bin:$PATH"
    else
        printf "${RED}✗ Failed to install runtime${NC}\n"
        exit 1
    fi
else
    printf "${GREEN}✓ Runtime available${NC}\n"
    export PATH="$HOME/.bun/bin:$PATH"
fi

echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    printf "${RED}✗ Git is not installed${NC}\n"
    echo ""
    echo "Please install git first:"
    echo "  Ubuntu/Debian: sudo apt-get install git"
    echo "  CentOS/RHEL:   sudo yum install git"
    echo "  macOS:         brew install git"
    exit 1
fi

# Clone SeyCode repository
printf "${BLUE}Downloading SeyCode...${NC}\n"
TEMP_DIR=$(mktemp -d)
if git clone --depth 1 --branch dev https://github.com/viseyyon/seycode.git "$TEMP_DIR" 2>/tmp/seycode-git-error.log; then
    printf "${GREEN}✓ Downloaded${NC}\n"
else
    printf "${RED}✗ Failed to download SeyCode${NC}\n"
    echo ""
    printf "${YELLOW}Error details:${NC}\n"
    cat /tmp/seycode-git-error.log 2>/dev/null || echo "No error log available"
    echo ""
    echo "Common issues:"
    echo "  - Network connectivity problems"
    echo "  - Firewall blocking GitHub"
    echo "  - Git not properly configured"
    echo ""
    echo "Repository URL: https://github.com/viseyyon/seycode"
    echo "Branch: dev"
    exit 1
fi

echo ""

# Install dependencies
printf "${BLUE}Installing dependencies (this may take 2-3 minutes)...${NC}\n"
printf "${YELLOW}This will download ~3800 packages. Please be patient...${NC}\n"
cd "$TEMP_DIR"

# Run bun install with live output
echo ""

# Show live output while saving log
set -o pipefail
if timeout 600 bun install 2>&1 | tee /tmp/seycode-install.log; then
    echo ""

    # Extract key info
    PACKAGE_COUNT=$(grep -o "[0-9]* packages installed" /tmp/seycode-install.log 2>/dev/null | tail -1)
    INSTALL_TIME=$(grep -o "\[[0-9.]*s\]" /tmp/seycode-install.log 2>/dev/null | tail -1)

    printf "${GREEN}✓ Dependencies installed successfully${NC}\n"
    if [ -n "$PACKAGE_COUNT" ]; then
        printf "${GREEN}  $PACKAGE_COUNT $INSTALL_TIME${NC}\n"
    fi

    # Show warnings if any
    WARNINGS=$(grep -c "^warn:" /tmp/seycode-install.log 2>/dev/null || echo "0")
    if [ "$WARNINGS" -gt 0 ]; then
        printf "${YELLOW}  ($WARNINGS warnings - check /tmp/seycode-install.log)${NC}\n"
    fi

    # Clean up log on success
    rm -f /tmp/seycode-install.log 2>/dev/null
else
    INSTALL_EXIT_CODE=$?
    echo ""
    echo ""

    # Check if it was a timeout
    if [ $INSTALL_EXIT_CODE -eq 124 ]; then
        printf "${RED}✗ Installation timed out after 10 minutes${NC}\n"
        echo ""
        printf "${YELLOW}This usually means:${NC}\n"
        echo "  - Very slow network connection"
        echo "  - npm registry issues"
        echo "  - Firewall blocking connections"
    else
        printf "${RED}✗ Failed to install dependencies (exit code: $INSTALL_EXIT_CODE)${NC}\n"
    fi

    echo ""
    printf "${YELLOW}Debug Information:${NC}\n"
    echo "  - Temp directory: $TEMP_DIR"
    echo "  - Bun version: $(bun --version 2>/dev/null || echo 'not found')"
    echo "  - Node modules: $(du -sh $TEMP_DIR/node_modules 2>/dev/null | cut -f1 || echo 'not created')"
    echo "  - Full log saved: /tmp/seycode-install.log"
    echo ""

    # Show last few lines of log
    printf "${YELLOW}Last 10 lines of installation log:${NC}\n"
    tail -10 /tmp/seycode-install.log 2>/dev/null || echo "Log not available"
    echo ""

    printf "${YELLOW}Troubleshooting:${NC}\n"
    echo "  1. Check network: curl -I https://registry.npmjs.org/"
    echo "  2. Check firewall/proxy settings"
    echo "  3. View full log: cat /tmp/seycode-install.log"
    echo "  4. Retry with: curl -fsSL https://raw.githubusercontent.com/viseyyon/seycode/dev/install.sh | bash"
    echo ""
    exit 1
fi

echo ""

# Install sey command
printf "${BLUE}Installing 'sey' command...${NC}\n"
if [ -f "$TEMP_DIR/sey" ]; then
    cp "$TEMP_DIR/sey" "$INSTALL_DIR/sey"
    chmod +x "$INSTALL_DIR/sey"
    printf "${GREEN}✓ Installed 'sey' command${NC}\n"
else
    printf "${RED}✗ sey command not found${NC}\n"
    exit 1
fi

echo ""

# Install SeyCode to ~/.seycode
SEYCODE_HOME="$HOME/.seycode"
printf "${BLUE}Installing SeyCode to $SEYCODE_HOME...${NC}\n"
rm -rf "$SEYCODE_HOME"
mv "$TEMP_DIR" "$SEYCODE_HOME"
printf "${GREEN}✓ SeyCode installed${NC}\n"

echo ""

# Configure PATH
printf "${BLUE}Configuring environment...${NC}\n"

# Detect shell
if [ -n "${BASH_VERSION:-}" ]; then
    SHELL_RC="$HOME/.bashrc"
elif [ -n "${ZSH_VERSION:-}" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ "$SHELL" = "/bin/zsh" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ "$SHELL" = "/bin/bash" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.profile"
fi

# Add to PATH if not already there
if ! grep -q "SEYCODE" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# SeyCode" >> "$SHELL_RC"
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_RC"
    printf "${GREEN}✓ Added to $SHELL_RC${NC}\n"
else
    printf "${GREEN}✓ Already configured in $SHELL_RC${NC}\n"
fi

echo ""
echo "======================================"
printf "${GREEN}✓ SeyCode Installed Successfully!${NC}\n"
echo "======================================"
echo ""
printf "${BOLD}Next Steps:${NC}\n"
echo ""
printf "  ${YELLOW}1.${NC} Restart your terminal or run:\n"
printf "     ${GREEN}source $SHELL_RC${NC}\n"
echo ""
printf "  ${YELLOW}2.${NC} Get an API key from Anthropic:\n"
printf "     ${BLUE}https://console.anthropic.com/${NC}\n"
echo ""
printf "  ${YELLOW}3.${NC} Set your API key:\n"
printf "     ${GREEN}export ANTHROPIC_API_KEY=\"sk-ant-your-key-here\"${NC}\n"
printf "     ${GREEN}echo 'export ANTHROPIC_API_KEY=\"sk-ant-...\"' >> $SHELL_RC${NC}\n"
echo ""
printf "  ${YELLOW}4.${NC} Start using SeyCode:\n"
printf "     ${GREEN}sey dev${NC}                    # Start in current directory\n"
printf "     ${GREEN}sey dev ~/myproject${NC}        # Start in specific project\n"
printf "     ${GREEN}sey --help${NC}                 # Show help\n"
echo ""
printf "${BOLD}Documentation:${NC}\n"
printf "  - Quick Start: ${BLUE}$SEYCODE_HOME/QUICKSTART.md${NC}\n"
printf "  - Full Guide:  ${BLUE}$SEYCODE_HOME/INSTALLATION.md${NC}\n"
echo ""
printf "For help, visit: ${BLUE}https://github.com/viseyyon/seycode${NC}\n"
echo ""
