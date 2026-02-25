#!/usr/bin/env bash
# SeyCode Installer - One command installation
# Usage: curl -fsSL https://seycode.ai/install | bash

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
echo "  Installing SeyCode"
echo "======================================${NC}"
echo ""

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

# Install Bun runtime (silently, as a dependency)
echo -e "${BLUE}Installing runtime...${NC}"
if ! command -v bun &> /dev/null; then
    if curl -fsSL https://bun.sh/install | bash > /dev/null 2>&1; then
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

# Clone SeyCode repository
echo -e "${BLUE}Downloading SeyCode...${NC}"
TEMP_DIR=$(mktemp -d)
if git clone --depth 1 --branch dev https://github.com/viseyyon/seycode.git "$TEMP_DIR" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Downloaded${NC}"
else
    echo -e "${RED}✗ Failed to download SeyCode${NC}"
    echo "Make sure you have access to: https://github.com/viseyyon/seycode"
    exit 1
fi

echo ""

# Install dependencies
echo -e "${BLUE}Installing dependencies...${NC}"
cd "$TEMP_DIR"
if bun install > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${RED}✗ Failed to install dependencies${NC}"
    exit 1
fi

echo ""

# Install sey command
echo -e "${BLUE}Installing 'sey' command...${NC}"
if [ -f "$TEMP_DIR/sey" ]; then
    cp "$TEMP_DIR/sey" "$INSTALL_DIR/sey"
    chmod +x "$INSTALL_DIR/sey"
    echo -e "${GREEN}✓ Installed 'sey' command${NC}"
else
    echo -e "${RED}✗ sey command not found${NC}"
    exit 1
fi

echo ""

# Install SeyCode to ~/.seycode
SEYCODE_HOME="$HOME/.seycode"
echo -e "${BLUE}Installing SeyCode to $SEYCODE_HOME...${NC}"
rm -rf "$SEYCODE_HOME"
mv "$TEMP_DIR" "$SEYCODE_HOME"
echo -e "${GREEN}✓ SeyCode installed${NC}"

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
if ! grep -q "SEYCODE" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# SeyCode" >> "$SHELL_RC"
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_RC"
    echo -e "${GREEN}✓ Added to $SHELL_RC${NC}"
else
    echo -e "${GREEN}✓ Already configured in $SHELL_RC${NC}"
fi

echo ""
echo -e "${BOLD}======================================"
echo -e "${GREEN}✓ SeyCode Installed Successfully!${NC}"
echo -e "${BOLD}======================================${NC}"
echo ""
echo -e "${BOLD}Next Steps:${NC}"
echo ""
echo "  ${YELLOW}1.${NC} Restart your terminal or run:"
echo "     ${GREEN}source $SHELL_RC${NC}"
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
echo -e "${BOLD}Documentation:${NC}"
echo "  - Quick Start: ${BLUE}$SEYCODE_HOME/QUICKSTART.md${NC}"
echo "  - Full Guide:  ${BLUE}$SEYCODE_HOME/INSTALLATION.md${NC}"
echo ""
echo "For help, visit: ${BLUE}https://github.com/viseyyon/seycode${NC}"
echo ""
