#!/usr/bin/env bash
# SeyCode One-Step Installer
# This script installs everything needed to run SeyCode

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "======================================"
echo "  SeyCode Installation"
echo "======================================"
echo ""

# Step 1: Check/Install Bun
echo -e "${BLUE}Step 1: Checking Bun runtime...${NC}"
if command -v bun &> /dev/null; then
    BUN_VERSION=$(bun --version)
    echo -e "${GREEN}✓ Bun $BUN_VERSION is already installed${NC}"
else
    echo -e "${YELLOW}Installing Bun runtime...${NC}"
    if curl -fsSL https://bun.sh/install | bash; then
        echo -e "${GREEN}✓ Bun installed successfully${NC}"

        # Add Bun to current session
        export PATH="$HOME/.bun/bin:$PATH"

        echo ""
        echo -e "${YELLOW}Note: Restart your terminal after installation or run:${NC}"
        echo -e "${GREEN}source ~/.zshrc${NC}"
    else
        echo -e "${RED}✗ Failed to install Bun${NC}"
        exit 1
    fi
fi

echo ""

# Step 2: Determine installation directory
echo -e "${BLUE}Step 2: Determining installation directory...${NC}"
if [ -n "${SEYCODE_INSTALL_DIR:-}" ]; then
    INSTALL_DIR="$SEYCODE_INSTALL_DIR"
elif [ -n "${XDG_BIN_DIR:-}" ]; then
    INSTALL_DIR="$XDG_BIN_DIR"
elif [ -d "$HOME/bin" ] || mkdir -p "$HOME/bin" 2>/dev/null; then
    INSTALL_DIR="$HOME/bin"
else
    INSTALL_DIR="$HOME/.seycode/bin"
    mkdir -p "$INSTALL_DIR"
fi

echo -e "${GREEN}✓ Installation directory: $INSTALL_DIR${NC}"
echo ""

# Step 3: Install sey command
echo -e "${BLUE}Step 3: Installing 'sey' command...${NC}"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

if [ -f "$REPO_ROOT/sey" ]; then
    cp "$REPO_ROOT/sey" "$INSTALL_DIR/sey"
    chmod +x "$INSTALL_DIR/sey"
    echo -e "${GREEN}✓ Installed 'sey' to $INSTALL_DIR/sey${NC}"
else
    echo -e "${RED}✗ sey script not found at $REPO_ROOT/sey${NC}"
    exit 1
fi

echo ""

# Step 4: Install dependencies
echo -e "${BLUE}Step 4: Installing SeyCode dependencies...${NC}"
cd "$REPO_ROOT"

# Add Bun to PATH for this session
export PATH="$HOME/.bun/bin:$PATH"

if command -v bun &> /dev/null; then
    if bun install; then
        echo -e "${GREEN}✓ Dependencies installed${NC}"
    else
        echo -e "${RED}✗ Failed to install dependencies${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Bun not available${NC}"
    echo "Please restart your terminal and run this script again"
    exit 1
fi

echo ""

# Step 5: Check PATH
echo -e "${BLUE}Step 5: Checking PATH configuration...${NC}"
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "${YELLOW}⚠ $INSTALL_DIR is not in your PATH${NC}"
    echo ""

    # Detect shell
    if [ -n "${BASH_VERSION:-}" ]; then
        SHELL_RC="$HOME/.bashrc"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        SHELL_RC="$HOME/.zshrc"
    else
        SHELL_RC="$HOME/.profile"
    fi

    echo "Adding to PATH in $SHELL_RC..."
    echo "" >> "$SHELL_RC"
    echo "# SeyCode" >> "$SHELL_RC"
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_RC"

    echo -e "${GREEN}✓ Added to $SHELL_RC${NC}"
    echo ""
    echo -e "${YELLOW}Please run: source $SHELL_RC${NC}"
else
    echo -e "${GREEN}✓ $INSTALL_DIR is already in your PATH${NC}"
fi

echo ""
echo "======================================"
echo -e "${GREEN}✓ SeyCode Installation Complete!${NC}"
echo "======================================"
echo ""
echo "Next steps:"
echo ""
echo "  1. Restart your terminal (or run: source ~/.zshrc)"
echo "  2. Set up your API key:"
echo "     ${GREEN}export ANTHROPIC_API_KEY=\"sk-ant-your-key-here\"${NC}"
echo "     Add to ~/.zshrc for persistence"
echo ""
echo "  3. Start using SeyCode:"
echo "     ${GREEN}sey dev${NC}                    # Start in current directory"
echo "     ${GREEN}sey dev /path/to/project${NC}  # Start in specific project"
echo ""
echo "Get API key from: https://console.anthropic.com/"
echo ""
echo "Documentation:"
echo "  - Quick Start: $REPO_ROOT/QUICKSTART.md"
echo "  - Full Guide:  $REPO_ROOT/INSTALLATION.md"
echo "  - Sey Command: $REPO_ROOT/SEY_COMMAND.md"
echo ""
