#!/bin/bash

# Comprehensive OpenCode to SeyCode rebranding script
set -e

echo "🚀 Starting comprehensive OpenCode → SeyCode rebranding..."

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to replace in files
replace_in_files() {
    local pattern="$1"
    local replacement="$2"
    local description="$3"

    echo -e "${BLUE}📝 Replacing $description...${NC}"

    # Find all text files, excluding binary files, node_modules, .git, dist, build directories
    find . -type f \
        ! -path "*/node_modules/*" \
        ! -path "*/.git/*" \
        ! -path "*/dist/*" \
        ! -path "*/build/*" \
        ! -path "*/.turbo/*" \
        ! -path "*/target/*" \
        ! -path "*/.next/*" \
        ! -path "*/out/*" \
        ! -path "*/*.png" \
        ! -path "*/*.jpg" \
        ! -path "*/*.jpeg" \
        ! -path "*/*.gif" \
        ! -path "*/*.ico" \
        ! -path "*/*.woff*" \
        ! -path "*/*.ttf" \
        ! -path "*/*.eot" \
        ! -path "*/*.otf" \
        ! -path "*/*.mp4" \
        ! -path "*/*.webm" \
        ! -path "*/*.zip" \
        ! -path "*/bun.lockb" \
        ! -name "*.lock" \
        -exec grep -l "$pattern" {} \; 2>/dev/null | while read file; do
        sed -i.bak "s/$pattern/$replacement/g" "$file" && rm "${file}.bak"
        echo "  ✓ Updated: $file"
    done
}

# Phase 1: Replace content in files
echo -e "${GREEN}Phase 1: Replacing content in files${NC}"

replace_in_files "seycode" "seycode" "seycode → seycode (lowercase)"
replace_in_files "OpenCode" "SeyCode" "OpenCode → SeyCode (PascalCase)"
replace_in_files "OPENCODE" "SEYCODE" "OPENCODE → SEYCODE (UPPERCASE)"

# Special URL replacements
echo -e "${BLUE}📝 Replacing URLs...${NC}"
find . -type f \
    ! -path "*/node_modules/*" \
    ! -path "*/.git/*" \
    ! -path "*/dist/*" \
    ! -path "*/build/*" \
    ! -path "*/.turbo/*" \
    ! -path "*/target/*" \
    -exec grep -l "seycode\.ai" {} \; 2>/dev/null | while read file; do
    sed -i.bak "s/seycode\.ai/seycode.ai/g" "$file" && rm "${file}.bak"
    echo "  ✓ Updated URLs: $file"
done

# Special GitHub repo replacements
echo -e "${BLUE}📝 Replacing GitHub references...${NC}"
find . -type f \
    ! -path "*/node_modules/*" \
    ! -path "*/.git/*" \
    ! -path "*/dist/*" \
    -exec grep -l "anomalyco/seycode" {} \; 2>/dev/null | while read file; do
    sed -i.bak "s/anomalyco\/seycode/anomalyco\/seycode/g" "$file" && rm "${file}.bak"
    echo "  ✓ Updated GitHub refs: $file"
done

# Phase 2: Rename files (excluding directories for now)
echo -e "${GREEN}Phase 2: Renaming files${NC}"

# Rename files with seycode in their name
find . -type f -name "*seycode*" \
    ! -path "*/node_modules/*" \
    ! -path "*/.git/*" \
    ! -path "*/dist/*" \
    ! -path "*/build/*" \
    ! -path "*/target/*" | while read file; do
    dir=$(dirname "$file")
    base=$(basename "$file")
    new_base=$(echo "$base" | sed 's/seycode/seycode/g' | sed 's/OpenCode/SeyCode/g')
    if [ "$base" != "$new_base" ]; then
        mv "$file" "$dir/$new_base"
        echo -e "  ${YELLOW}✓ Renamed:${NC} $base → $new_base"
    fi
done

# Phase 3: Rename directories (deepest first to avoid conflicts)
echo -e "${GREEN}Phase 3: Renaming directories${NC}"

# Find all directories with seycode in name (sorted by depth, deepest first)
find . -type d -name "*seycode*" \
    ! -path "*/node_modules/*" \
    ! -path "*/.git/*" \
    ! -path "*/dist/*" \
    ! -path "*/build/*" \
    ! -path "*/target/*" \
    -print | awk '{ print length, $0 }' | sort -rn | cut -d" " -f2- | while read dir; do
    parent=$(dirname "$dir")
    base=$(basename "$dir")
    new_base=$(echo "$base" | sed 's/seycode/seycode/g' | sed 's/OpenCode/SeyCode/g')
    if [ "$base" != "$new_base" ] && [ -d "$dir" ]; then
        mv "$dir" "$parent/$new_base"
        echo -e "  ${YELLOW}✓ Renamed directory:${NC} $base → $new_base"
    fi
done

echo -e "${GREEN}✅ Rebranding complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review changes: git status"
echo "  2. Test build: cd packages/seycode && bun run build"
echo "  3. Run tests: bun test"
echo "  4. Commit changes: git add -A && git commit -m 'Complete rebranding from OpenCode to SeyCode'"
