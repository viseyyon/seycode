#!/usr/bin/env bash
# Test the installation in a clean environment

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "Testing SeyCode Installation..."
echo ""

# Create temp directory
TEMP_DIR=$(mktemp -d)
echo "Test directory: $TEMP_DIR"
cd "$TEMP_DIR"

# Test remote install
echo ""
echo -e "${YELLOW}Testing remote installation...${NC}"
if curl -fsSL https://raw.githubusercontent.com/viseyyon/seycode/dev/install.sh | bash; then
    echo -e "${GREEN}✓ Remote installation succeeded${NC}"
else
    echo -e "${RED}✗ Remote installation failed${NC}"
    exit 1
fi

# Cleanup
cd -
rm -rf "$TEMP_DIR"

echo ""
echo -e "${GREEN}✓ All installation tests passed!${NC}"
echo ""
