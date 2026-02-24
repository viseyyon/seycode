#!/bin/bash

# GitHub Repository Setup Script for SeyCode
# This script helps create and configure the private repository under viseyyon org

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  SeyCode GitHub Repository Setup Script      ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}✗ GitHub CLI (gh) is not installed${NC}"
    echo ""
    echo "Please install GitHub CLI first:"
    echo "  macOS:   brew install gh"
    echo "  Linux:   See https://github.com/cli/cli#installation"
    echo "  Windows: scoop install gh"
    echo ""
    echo "After installation, run: gh auth login"
    exit 1
fi

echo -e "${GREEN}✓ GitHub CLI is installed${NC}"

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}! Not authenticated with GitHub${NC}"
    echo ""
    echo "Running: gh auth login"
    gh auth login
fi

echo -e "${GREEN}✓ Authenticated with GitHub${NC}"
echo ""

# Confirm details
echo -e "${BLUE}Repository Details:${NC}"
echo "  Organization: viseyyon"
echo "  Repository:   seycode"
echo "  Visibility:   private"
echo "  Description:  The world's first truly intelligent AI coding agent with revolutionary automatic features"
echo ""

read -p "Continue with these settings? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted"
    exit 1
fi

# Create repository
echo ""
echo -e "${BLUE}Creating repository...${NC}"

if gh repo create viseyyon/seycode \
    --private \
    --description "The world's first truly intelligent AI coding agent with revolutionary automatic features" \
    --homepage "https://seycode.ai"; then
    echo -e "${GREEN}✓ Repository created successfully${NC}"
else
    echo -e "${RED}✗ Failed to create repository${NC}"
    echo "Repository may already exist or you may not have permission"
    echo "Please check: https://github.com/viseyyon/seycode"
    exit 1
fi

# Update git remote
echo ""
echo -e "${BLUE}Updating git remote...${NC}"

# Check if remote exists
if git remote get-url origin &> /dev/null; then
    echo "  Updating existing remote 'origin'"
    git remote set-url origin https://github.com/viseyyon/seycode.git
else
    echo "  Adding remote 'origin'"
    git remote add origin https://github.com/viseyyon/seycode.git
fi

echo -e "${GREEN}✓ Remote updated${NC}"

# Push code
echo ""
echo -e "${BLUE}Pushing code to GitHub...${NC}"

# Ensure we're on dev branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "dev" ]; then
    echo "  Switching to dev branch"
    git checkout dev
fi

echo "  Pushing dev branch..."
if git push -u origin dev; then
    echo -e "${GREEN}✓ Pushed dev branch${NC}"
else
    echo -e "${RED}✗ Failed to push dev branch${NC}"
    exit 1
fi

# Create and push main branch
echo ""
echo -e "${BLUE}Creating main branch...${NC}"

if git show-ref --verify --quiet refs/heads/main; then
    echo "  main branch already exists locally"
else
    echo "  Creating main branch from dev"
    git checkout -b main dev
fi

echo "  Pushing main branch..."
if git push -u origin main; then
    echo -e "${GREEN}✓ Pushed main branch${NC}"
else
    echo -e "${RED}✗ Failed to push main branch${NC}"
fi

# Switch back to dev
git checkout dev

echo ""
echo -e "${GREEN}✓ Code pushed successfully${NC}"

# Configure repository settings
echo ""
echo -e "${BLUE}Configuring repository settings...${NC}"

# Set default branch to dev
echo "  Setting default branch to 'dev'..."
if gh repo edit viseyyon/seycode --default-branch dev; then
    echo -e "${GREEN}✓ Default branch set to 'dev'${NC}"
else
    echo -e "${YELLOW}! Could not set default branch (may need to do manually)${NC}"
fi

# Enable features
echo "  Enabling repository features..."
gh repo edit viseyyon/seycode \
    --enable-issues \
    --enable-discussions \
    --enable-wiki=false \
    &> /dev/null || echo -e "${YELLOW}! Some features could not be enabled (check manually)${NC}"

# Add topics
echo "  Adding topics..."
gh repo edit viseyyon/seycode \
    --add-topic "ai" \
    --add-topic "coding-agent" \
    --add-topic "typescript" \
    --add-topic "llm" \
    --add-topic "automation" \
    --add-topic "prompt-engineering" \
    --add-topic "ai-assistant" \
    --add-topic "developer-tools" \
    &> /dev/null || echo -e "${YELLOW}! Could not add topics (add manually)${NC}"

echo -e "${GREEN}✓ Repository configured${NC}"

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Repository Setup Complete!                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Repository URL:${NC} https://github.com/viseyyon/seycode"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo ""
echo "1. Configure branch protection:"
echo "   https://github.com/viseyyon/seycode/settings/branches"
echo ""
echo "2. Add repository secrets (for CI/CD):"
echo "   https://github.com/viseyyon/seycode/settings/secrets/actions"
echo "   - ANTHROPIC_API_KEY (for testing)"
echo "   - NPM_TOKEN (for publishing)"
echo ""
echo "3. Enable security features:"
echo "   https://github.com/viseyyon/seycode/settings/security_analysis"
echo "   - Dependabot alerts"
echo "   - Secret scanning"
echo ""
echo "4. Review and complete setup checklist:"
echo "   See REPOSITORY_SETUP.md for detailed steps"
echo ""
echo "5. Verify GitHub Actions:"
echo "   https://github.com/viseyyon/seycode/actions"
echo ""
echo "6. Invite collaborators (if needed):"
echo "   https://github.com/viseyyon/seycode/settings/access"
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo "  - GETTING_STARTED.md  - User onboarding"
echo "  - TESTING.md          - Testing guide"
echo "  - REPOSITORY_SETUP.md - Full setup guide"
echo "  - DOCUMENTATION_INDEX.md - All documentation"
echo ""
echo -e "${GREEN}✓ Setup complete! Your repository is ready.${NC}"
echo ""
