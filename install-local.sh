#!/usr/bin/env bash
# SeyCode Local Installer - For testing and local installation
# Usage: ./install-local.sh

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
echo "  Installing SeyCode (Local)"
echo "======================================"
echo ""

# Get current directory
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# Install/Check Bun runtime
printf "${BLUE}Checking runtime...${NC}\n"
if ! command -v bun &> /dev/null; then
    printf "${YELLOW}Installing runtime (Bun)...${NC}\n"
    if curl -fsSL https://bun.sh/install | bash; then
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

# Check if git is installed (needed for some dependencies)
if ! command -v git &> /dev/null; then
    printf "${YELLOW}⚠ Git not found - some dependencies may need it${NC}\n"
fi

# Install dependencies
printf "${BLUE}Installing dependencies (this may take 2-3 minutes)...${NC}\n"
printf "${YELLOW}Downloading ~3800 packages. Please wait...${NC}\n"
cd "$REPO_ROOT"

echo ""

# Run with timeout and show live output
if timeout 600 bun install 2>&1 | tee /tmp/seycode-install-local.log; then
    echo ""

    # Extract summary
    PACKAGE_COUNT=$(grep -o "[0-9]* packages installed" /tmp/seycode-install-local.log 2>/dev/null | tail -1)
    INSTALL_TIME=$(grep -o "\[[0-9.]*s\]" /tmp/seycode-install-local.log 2>/dev/null | tail -1)

    printf "${GREEN}✓ Dependencies installed successfully${NC}\n"
    if [ -n "$PACKAGE_COUNT" ]; then
        printf "${GREEN}  $PACKAGE_COUNT $INSTALL_TIME${NC}\n"
    fi

    # Show warnings count
    WARNINGS=$(grep -c "^warn:" /tmp/seycode-install-local.log 2>/dev/null || echo "0")
    if [ "$WARNINGS" -gt 0 ]; then
        printf "${YELLOW}  ($WARNINGS warnings - check /tmp/seycode-install-local.log)${NC}\n"
    fi

    rm -f /tmp/seycode-install-local.log 2>/dev/null
else
    INSTALL_EXIT_CODE=$?
    echo ""
    echo ""

    if [ $INSTALL_EXIT_CODE -eq 124 ]; then
        printf "${RED}✗ Installation timed out after 10 minutes${NC}\n"
    else
        printf "${RED}✗ Failed to install dependencies (exit code: $INSTALL_EXIT_CODE)${NC}\n"
    fi

    echo ""
    printf "${YELLOW}Debug Information:${NC}\n"
    echo "  - Repository: $REPO_ROOT"
    echo "  - Bun version: $(bun --version 2>/dev/null || echo 'not found')"
    echo "  - Node modules: $(du -sh $REPO_ROOT/node_modules 2>/dev/null | cut -f1 || echo 'not created')"
    echo "  - Log: /tmp/seycode-install-local.log"
    echo ""

    printf "${YELLOW}Last 10 lines:${NC}\n"
    tail -10 /tmp/seycode-install-local.log 2>/dev/null || echo "Log not available"
    echo ""
    exit 1
fi

echo ""

# Install sey command
printf "${BLUE}Installing 'sey' command...${NC}\n"
if [ -f "$REPO_ROOT/sey" ]; then
    cp "$REPO_ROOT/sey" "$INSTALL_DIR/sey"
    chmod +x "$INSTALL_DIR/sey"
    printf "${GREEN}✓ Installed 'sey' command to $INSTALL_DIR/sey${NC}\n"
else
    printf "${RED}✗ sey command not found${NC}\n"
    exit 1
fi

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
PATH_EXPORT="export PATH=\"$INSTALL_DIR:\$PATH\""
if ! grep -q "$PATH_EXPORT" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# SeyCode" >> "$SHELL_RC"
    echo "$PATH_EXPORT" >> "$SHELL_RC"
    printf "${GREEN}✓ Added to $SHELL_RC${NC}\n"
else
    printf "${GREEN}✓ Already configured in $SHELL_RC${NC}\n"
fi

# Export for current session
export PATH="$INSTALL_DIR:$PATH"

echo ""
echo "======================================"
printf "${GREEN}✓ SeyCode Installed Successfully!${NC}\n"
echo "======================================"
echo ""
printf "${BOLD}Next Steps:${NC}\n"
echo ""
printf "  ${YELLOW}1.${NC} Reload your shell:\n"
printf "     ${GREEN}source $SHELL_RC${NC}\n"
printf "     ${GREEN}# or restart your terminal${NC}\n"
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
printf "${BOLD}Test it now:${NC}\n"
printf "  ${GREEN}$INSTALL_DIR/sey --version${NC}\n"
echo ""
printf "${BOLD}Documentation:${NC}\n"
printf "  - Quick Start: ${BLUE}$REPO_ROOT/QUICKSTART.md${NC}\n"
printf "  - Full Guide:  ${BLUE}$REPO_ROOT/INSTALLATION.md${NC}\n"
echo ""
