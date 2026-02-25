#!/usr/bin/env bash
# Replace 'bun' commands with 'sey' in documentation and user-facing files

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Replacing 'bun' with 'sey' in documentation..."
echo ""

# Files to update (user-facing documentation and scripts)
FILES=(
    "INSTALLATION.md"
    "QUICKSTART.md"
    "README.md"
    "CLAUDE.md"
    "MODEL_REGISTRY.md"
    "GETTING_STARTED.md"
    "QUICK_START_MODELS.md"
    "TESTING.md"
    "LAUNCH_CHECKLIST.md"
    "CONTRIBUTING.md"
    ".seycode/skill/test-runner.md"
    ".seycode/skill/sdk-regenerator.md"
    ".seycode/skill/agent-creator.md"
    ".seycode/skill/migration-creator.md"
    ".seycode/skill/debug-helper.md"
    ".seycode/skill/tool-creator.md"
    ".seycode/skill/architecture-explorer.md"
    ".seycode/skill/provider-adder.md"
    ".seycode/skill/lsp-configurator.md"
    "packages/seycode/README.md"
    "packages/app/README.md"
    "github/README.md"
)

count=0

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${YELLOW}Processing: $file${NC}"

        # Create backup
        cp "$file" "$file.bak"

        # Apply replacements in order (most specific first)
        sed -i.tmp \
            -e 's/`bun /`sey /g' \
            -e 's/bun run build/sey run build/g' \
            -e 's/bun run dev/sey run dev/g' \
            -e 's/bun run --cwd/sey run --cwd/g' \
            -e 's/bun run db/sey run db/g' \
            -e 's/bun install/sey install/g' \
            -e 's/bun dev/sey dev/g' \
            -e 's/bun test/sey test/g' \
            -e 's/bun typecheck/sey typecheck/g' \
            -e 's/bun pm ls/sey pm ls/g' \
            -e 's/bun playwright/sey playwright/g' \
            -e 's/bun turbo/sey turbo/g' \
            -e 's/bun --version/sey --version/g' \
            -e 's/bun --inspect/sey --inspect/g' \
            -e 's/# bun/# sey/g' \
            "$file"
        rm -f "$file.tmp"

        # Remove backup if file changed
        if ! diff -q "$file" "$file.bak" > /dev/null 2>&1; then
            rm "$file.bak"
            ((count++))
        else
            # Restore from backup if no changes
            mv "$file.bak" "$file"
        fi
    fi
done

echo ""
echo -e "${GREEN}✓ Updated $count files${NC}"
echo ""
echo "Note: The following are intentionally NOT changed:"
echo "  - Internal package.json scripts (use bun directly)"
echo "  - TypeScript/JavaScript source code"
echo "  - References to 'Bun' as the runtime/tool name"
echo ""
