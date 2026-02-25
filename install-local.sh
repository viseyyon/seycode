#!/usr/bin/env bash
# SeyCode Local Installer - For testing and local installation
# Usage: ./install-local.sh

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}======================================"
echo "  Installing SeyCode (Local)"
echo "======================================${NC}"
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

echo -e "${BLUE}Installing to: $INSTALL_DIR${NC}"
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
        echo -e "${RED}✗ Unsupported operating system: $OS${NC}"
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
        echo -e "${RED}✗ Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}✓ Detected: $OS_TYPE-$ARCH_TYPE${NC}"
echo ""

# Install/Check Bun runtime
echo -e "${BLUE}Checking runtime...${NC}"
if ! command -v bun &> /dev/null; then
    echo -e "${YELLOW}Installing runtime (Bun)...${NC}"
    if curl -fsSL https://bun.sh/install | bash; then
        echo -e "${GREEN}✓ Runtime installed${NC}"
        export PATH="$HOME/.bun/bin:$PATH"
    else
        echo -e "${RED}✗ Failed to install runtime${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Runtime available${NC}"
    export PATH="$HOME/.bun/bin:$PATH"
fi

echo ""

# Install dependencies
echo -e "${BLUE}Installing dependencies...${NC}"
cd "$REPO_ROOT"

if bun install; then
    echo -e "${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${RED}✗ Failed to install dependencies${NC}"
    exit 1
fi

echo ""

# Install sey command
echo -e "${BLUE}Installing 'sey' command...${NC}"
if [ -f "$REPO_ROOT/sey" ]; then
    cp "$REPO_ROOT/sey" "$INSTALL_DIR/sey"
    chmod +x "$INSTALL_DIR/sey"
    echo -e "${GREEN}✓ Installed 'sey' command to $INSTALL_DIR/sey${NC}"
else
    echo -e "${RED}✗ sey command not found${NC}"
    exit 1
fi

echo ""

# Configure PATH
echo -e "${BLUE}Configuring environment...${NC}"

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
    echo -e "${GREEN}✓ Added to $SHELL_RC${NC}"
else
    echo -e "${GREEN}✓ Already configured in $SHELL_RC${NC}"
fi

# Export for current session
export PATH="$INSTALL_DIR:$PATH"

echo ""
echo -e "${BOLD}======================================"
echo -e "${GREEN}✓ SeyCode Installed Successfully!${NC}"
echo -e "${BOLD}======================================${NC}"
echo ""
echo -e "${BOLD}Next Steps:${NC}"
echo ""
echo "  ${YELLOW}1.${NC} Reload your shell:"
echo "     ${GREEN}source $SHELL_RC${NC}"
echo "     ${GREEN}# or restart your terminal${NC}"
echo ""
echo "  ${YELLOW}2.${NC} Get an API key from Anthropic:"
echo "     ${BLUE}https://console.anthropic.com/${NC}"
echo ""
echo "  ${YELLOW}3.${NC} Set your API key:"
echo "     ${GREEN}export ANTHROPIC_API_KEY=\"sk-ant-your-key-here\"${NC}"
echo "     ${GREEN}echo 'export ANTHROPIC_API_KEY=\"sk-ant-...\"' >> $SHELL_RC${NC}"
echo ""
echo "  ${YELLOW}4.${NC} Start using SeyCode:"
echo "     ${GREEN}sey dev${NC}                    # Start in current directory"
echo "     ${GREEN}sey dev ~/myproject${NC}        # Start in specific project"
echo "     ${GREEN}sey --help${NC}                 # Show help"
echo ""
echo -e "${BOLD}Test it now:${NC}"
echo "  ${GREEN}$INSTALL_DIR/sey --version${NC}"
echo ""
echo -e "${BOLD}Documentation:${NC}"
echo "  - Quick Start: ${BLUE}$REPO_ROOT/QUICKSTART.md${NC}"
echo "  - Full Guide:  ${BLUE}$REPO_ROOT/INSTALLATION.md${NC}"
echo ""
