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

# Check for existing installation
if [ -d "$HOME/.seycode" ]; then
    printf "${YELLOW}⚠ Existing SeyCode installation found${NC}\n"
    printf "${YELLOW}  Removing old installation...${NC}\n"
    rm -rf "$HOME/.seycode"
    rm -f "$HOME/.local/bin/sey" "$HOME/bin/sey" 2>/dev/null
    printf "${GREEN}✓ Removed old installation${NC}\n"
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

# Clone SeyCode repository
printf "${BLUE}Downloading SeyCode...${NC}\n"
TEMP_DIR=$(mktemp -d)
if git clone --depth 1 --branch dev https://github.com/viseyyon/seycode.git "$TEMP_DIR" > /dev/null 2>&1; then
    printf "${GREEN}✓ Downloaded${NC}\n"
else
    printf "${RED}✗ Failed to download SeyCode${NC}\n"
    echo "Make sure you have access to: https://github.com/viseyyon/seycode"
    exit 1
fi

echo ""

# Install dependencies
printf "${BLUE}Installing dependencies (this may take a minute)...${NC}\n"
cd "$TEMP_DIR"

# Run bun install with visible output
echo ""
if bun install; then
    echo ""
    printf "${GREEN}✓ Dependencies installed${NC}\n"
else
    echo ""
    printf "${RED}✗ Failed to install dependencies${NC}\n"
    echo ""
    echo "This might be due to:"
    echo "  - Network issues"
    echo "  - Workspace dependency conflicts"
    echo ""
    echo "Debug info:"
    echo "  - Temp directory: $TEMP_DIR"
    echo "  - Bun version: $(bun --version 2>/dev/null || echo 'not found')"
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
