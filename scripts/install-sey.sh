#!/usr/bin/env bash
# Install the 'sey' command globally

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "Installing SeyCode CLI wrapper..."
echo ""

# Determine installation directory
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

echo -e "${YELLOW}Installation directory: $INSTALL_DIR${NC}"
echo ""

# Copy sey script
cp "$(dirname "$0")/../sey" "$INSTALL_DIR/sey"
chmod +x "$INSTALL_DIR/sey"

echo -e "${GREEN}✓ Installed 'sey' command to $INSTALL_DIR/sey${NC}"
echo ""

# Check if directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "${YELLOW}⚠ Warning: $INSTALL_DIR is not in your PATH${NC}"
    echo ""
    echo "Add it to your PATH by adding this to your shell profile:"
    echo ""

    # Detect shell
    if [ -n "${BASH_VERSION:-}" ]; then
        SHELL_RC="~/.bashrc"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        SHELL_RC="~/.zshrc"
    else
        SHELL_RC="~/.profile"
    fi

    echo -e "${GREEN}export PATH=\"$INSTALL_DIR:\$PATH\"${NC}"
    echo ""
    echo "Add it to $SHELL_RC:"
    echo -e "${GREEN}echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> $SHELL_RC${NC}"
    echo -e "${GREEN}source $SHELL_RC${NC}"
else
    echo -e "${GREEN}✓ $INSTALL_DIR is already in your PATH${NC}"
fi

echo ""
echo "Installation complete! Try:"
echo -e "${GREEN}sey --help${NC}"
echo ""
