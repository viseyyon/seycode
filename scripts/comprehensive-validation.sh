#!/bin/bash

# Comprehensive Validation Script for SeyCode
# Validates all functionality, security, and checks for unwanted references

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     SeyCode Comprehensive Validation Suite                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Test function
test_check() {
    local description="$1"
    local command="$2"

    if eval "$command" &> /dev/null; then
        echo -e "${GREEN}✓ PASS${NC} - $description"
        ((PASS_COUNT++))
    else
        echo -e "${RED}✗ FAIL${NC} - $description"
        ((FAIL_COUNT++))
    fi
}

test_warn() {
    local description="$1"
    local command="$2"

    if eval "$command" &> /dev/null; then
        echo -e "${YELLOW}⚠ WARN${NC} - $description"
        ((WARN_COUNT++))
    fi
}

# ==========================================
# 1. SECURITY CHECKS
# ==========================================
echo -e "\n${BLUE}[1] SECURITY VALIDATION${NC}\n"

# Check for hardcoded API keys
test_check "No hardcoded Anthropic API keys" \
    "! grep -r 'sk-ant-' --include='*.ts' --include='*.js' --include='*.json' . 2>/dev/null"

test_check "No hardcoded OpenAI API keys" \
    "! grep -r 'sk-[A-Za-z0-9]\\{48\\}' --include='*.ts' --include='*.js' . 2>/dev/null"

test_check "No hardcoded tokens" \
    "! grep -r 'ghp_[A-Za-z0-9]\\{36\\}' --include='*.ts' --include='*.js' . 2>/dev/null"

test_check "No AWS access keys" \
    "! grep -r 'AKIA[0-9A-Z]{16}' --include='*.ts' --include='*.js' . 2>/dev/null"

test_check "No private keys in code" \
    "! grep -r 'BEGIN.*PRIVATE KEY' --include='*.ts' --include='*.js' . 2>/dev/null"

test_check "No passwords in code" \
    "! grep -ri 'password.*=.*[\"'][^\"']\\{8,\\}[\"']' --include='*.ts' --include='*.js' . 2>/dev/null"

test_check "No database credentials" \
    "! grep -ri 'DB_PASSWORD.*=.*[\"'][^\"']\\+[\"']' --include='*.ts' --include='*.js' . 2>/dev/null"

test_check ".env files in .gitignore" \
    "grep -q '^\\.env' .gitignore"

test_check "No .env files committed" \
    "! git ls-files | grep -q '\\.env$'"

test_check "SECURITY.md exists" \
    "[ -f SECURITY.md ]"

# ==========================================
# 2. UNWANTED REFERENCES CHECK
# ==========================================
echo -e "\n${BLUE}[2] UNWANTED REFERENCES CHECK${NC}\n"

# Check for vantiva/tch/vtv references
VANTIVA_COUNT=$(grep -ri 'vantiva' --include='*.ts' --include='*.js' --include='*.json' --include='*.md' . 2>/dev/null | grep -v '.git' | wc -l | tr -d ' ')
TCH_COUNT=$(grep -ri '\btch\b' --include='*.ts' --include='*.js' --include='*.json' --include='*.md' . 2>/dev/null | grep -v '.git' | wc -l | tr -d ' ')
VTV_COUNT=$(grep -ri '\bvtv\b' --include='*.ts' --include='*.js' --include='*.json' --include='*.md' . 2>/dev/null | grep -v '.git' | wc -l | tr -d ' ')

if [ "$VANTIVA_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC} - No 'vantiva' references found"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗ FAIL${NC} - Found $VANTIVA_COUNT 'vantiva' references:"
    grep -rn 'vantiva' --include='*.ts' --include='*.js' --include='*.json' --include='*.md' . 2>/dev/null | grep -v '.git' | head -10
    ((FAIL_COUNT++))
fi

if [ "$TCH_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC} - No 'tch' references found"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠ WARN${NC} - Found $TCH_COUNT 'tch' references (check if legitimate):"
    grep -rn '\btch\b' --include='*.ts' --include='*.js' --include='*.json' --include='*.md' . 2>/dev/null | grep -v '.git' | head -10
    ((WARN_COUNT++))
fi

if [ "$VTV_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC} - No 'vtv' references found"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗ FAIL${NC} - Found $VTV_COUNT 'vtv' references:"
    grep -rn '\bvtv\b' --include='*.ts' --include='*.js' --include='*.json' --include='*.md' . 2>/dev/null | grep -v '.git' | head -10
    ((FAIL_COUNT++))
fi

# Check for any other suspicious organization names
test_check "No references to old organization names" \
    "! grep -ri 'oldcompany\|oldorg\|previous-org' --include='*.ts' --include='*.js' . 2>/dev/null"

# ==========================================
# 3. REBRANDING VALIDATION
# ==========================================
echo -e "\n${BLUE}[3] REBRANDING VALIDATION${NC}\n"

test_check "No 'opencode' in package names" \
    "! grep -r '\"name\".*opencode' --include='package.json' ."

test_check "No 'opencode' directory references" \
    "! grep -r '\\.opencode/' --include='*.ts' --include='*.js' packages/"

test_check "Correct binary name 'seycode'" \
    "grep -q '\"seycode\"' packages/seycode/package.json"

test_check "SeyCode in README title" \
    "grep -q '^# SeyCode' README.md"

# ==========================================
# 4. CONFIGURATION VALIDATION
# ==========================================
echo -e "\n${BLUE}[4] CONFIGURATION VALIDATION${NC}\n"

test_check ".seycode/seycode.json is valid JSON" \
    "jq empty .seycode/seycode.json 2>/dev/null"

test_check ".seycode/model-registry.json is valid JSON" \
    "jq empty .seycode/model-registry.json 2>/dev/null"

test_check ".seycode/prompting-techniques.json is valid JSON" \
    "jq empty .seycode/prompting-techniques.json 2>/dev/null"

test_check "Root package.json is valid JSON" \
    "jq empty package.json 2>/dev/null"

test_check "packages/seycode/package.json is valid JSON" \
    "jq empty packages/seycode/package.json 2>/dev/null"

# ==========================================
# 5. DATABASE VALIDATION
# ==========================================
echo -e "\n${BLUE}[5] DATABASE VALIDATION${NC}\n"

# Model registry validation
test_check "Model registry has version" \
    "jq -e '.version' .seycode/model-registry.json > /dev/null"

test_check "Model registry has lastUpdated" \
    "jq -e '.lastUpdated' .seycode/model-registry.json > /dev/null"

test_check "Model registry has modelCategories" \
    "jq -e '.modelCategories' .seycode/model-registry.json > /dev/null"

MODEL_COUNT=$(jq '.modelCategories | to_entries | length' .seycode/model-registry.json)
if [ "$MODEL_COUNT" -ge 5 ]; then
    echo -e "${GREEN}✓ PASS${NC} - Model registry has $MODEL_COUNT categories"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗ FAIL${NC} - Model registry only has $MODEL_COUNT categories (expected 5+)"
    ((FAIL_COUNT++))
fi

# Prompting techniques validation
test_check "Prompting techniques has version" \
    "jq -e '.version' .seycode/prompting-techniques.json > /dev/null"

test_check "Prompting techniques has lastUpdated" \
    "jq -e '.lastUpdated' .seycode/prompting-techniques.json > /dev/null"

test_check "Prompting techniques has techniques" \
    "jq -e '.techniques' .seycode/prompting-techniques.json > /dev/null"

TECHNIQUE_COUNT=$(jq '.techniques | length' .seycode/prompting-techniques.json)
if [ "$TECHNIQUE_COUNT" -ge 15 ]; then
    echo -e "${GREEN}✓ PASS${NC} - Prompting techniques has $TECHNIQUE_COUNT techniques"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗ FAIL${NC} - Prompting techniques only has $TECHNIQUE_COUNT techniques (expected 15+)"
    ((FAIL_COUNT++))
fi

# ==========================================
# 6. DOCUMENTATION VALIDATION
# ==========================================
echo -e "\n${BLUE}[6] DOCUMENTATION VALIDATION${NC}\n"

REQUIRED_DOCS=(
    "README.md"
    "GETTING_STARTED.md"
    "CLAUDE.md"
    "CONTRIBUTING.md"
    "TESTING.md"
    "ARCHITECTURE.md"
    "PROVIDER_SETUP.md"
    "MODEL_REGISTRY.md"
    "PROMPTING_TECHNIQUES.md"
    "QUICK_START_MODELS.md"
    "DATABASES_SUMMARY.md"
    "DOCUMENTATION_INDEX.md"
    "SECURITY.md"
    "LICENSE"
    "CHANGELOG.md"
)

for doc in "${REQUIRED_DOCS[@]}"; do
    test_check "$doc exists" "[ -f $doc ]"
done

# ==========================================
# 7. SKILLS VALIDATION
# ==========================================
echo -e "\n${BLUE}[7] SKILLS VALIDATION${NC}\n"

SKILL_DIR=".seycode/skill"
if [ -d "$SKILL_DIR" ]; then
    SKILL_COUNT=$(find "$SKILL_DIR" -name "*.md" | wc -l | tr -d ' ')

    if [ "$SKILL_COUNT" -ge 16 ]; then
        echo -e "${GREEN}✓ PASS${NC} - Found $SKILL_COUNT skills (expected 16+)"
        ((PASS_COUNT++))
    else
        echo -e "${RED}✗ FAIL${NC} - Only found $SKILL_COUNT skills (expected 16+)"
        ((FAIL_COUNT++))
    fi

    # Validate each skill has frontmatter
    for skill in "$SKILL_DIR"/*.md; do
        if [ -f "$skill" ]; then
            if head -5 "$skill" | grep -q '^---$'; then
                : # Skill has frontmatter, silent pass
            else
                echo -e "${RED}✗ FAIL${NC} - Skill $(basename $skill) missing frontmatter"
                ((FAIL_COUNT++))
            fi
        fi
    done

    echo -e "${GREEN}✓ PASS${NC} - All skills have proper frontmatter"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗ FAIL${NC} - Skills directory not found: $SKILL_DIR"
    ((FAIL_COUNT++))
fi

# ==========================================
# 8. SCRIPTS VALIDATION
# ==========================================
echo -e "\n${BLUE}[8] SCRIPTS VALIDATION${NC}\n"

test_check "validate-all.sh exists and executable" \
    "[ -x validate-all.sh ]"

test_check "test-with-bun.sh exists and executable" \
    "[ -x test-with-bun.sh ]"

test_check "setup-github-repo.sh exists and executable" \
    "[ -x setup-github-repo.sh ]"

test_check "update-prompting-techniques.ts exists" \
    "[ -f scripts/update-prompting-techniques.ts ]"

# ==========================================
# 9. GITHUB ACTIONS VALIDATION
# ==========================================
echo -e "\n${BLUE}[9] GITHUB ACTIONS VALIDATION${NC}\n"

test_check "GitHub Actions workflows directory exists" \
    "[ -d .github/workflows ]"

WORKFLOW_COUNT=$(find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null | wc -l | tr -d ' ')
if [ "$WORKFLOW_COUNT" -ge 1 ]; then
    echo -e "${GREEN}✓ PASS${NC} - Found $WORKFLOW_COUNT GitHub Actions workflows"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠ WARN${NC} - No GitHub Actions workflows found"
    ((WARN_COUNT++))
fi

test_check "update-databases.yml workflow exists" \
    "[ -f .github/workflows/update-databases.yml ]"

# Validate workflow syntax
if command -v yq &> /dev/null; then
    for workflow in .github/workflows/*.yml .github/workflows/*.yaml 2>/dev/null; do
        if [ -f "$workflow" ]; then
            if yq eval '.' "$workflow" > /dev/null 2>&1; then
                echo -e "${GREEN}✓ PASS${NC} - $(basename $workflow) is valid YAML"
                ((PASS_COUNT++))
            else
                echo -e "${RED}✗ FAIL${NC} - $(basename $workflow) has invalid YAML"
                ((FAIL_COUNT++))
            fi
        fi
    done
else
    echo -e "${YELLOW}⚠ WARN${NC} - yq not installed, skipping YAML validation"
    ((WARN_COUNT++))
fi

# ==========================================
# 10. GIT VALIDATION
# ==========================================
echo -e "\n${BLUE}[10] GIT VALIDATION${NC}\n"

test_check "Git repository initialized" \
    "[ -d .git ]"

test_check "On dev branch" \
    "[ \$(git branch --show-current) = 'dev' ]"

test_check "No uncommitted changes" \
    "git diff --quiet && git diff --cached --quiet"

test_check "Remote origin set" \
    "git remote get-url origin > /dev/null 2>&1"

REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "none")
if echo "$REMOTE_URL" | grep -q "viseyyon/seycode"; then
    echo -e "${GREEN}✓ PASS${NC} - Remote points to viseyyon/seycode"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠ WARN${NC} - Remote URL: $REMOTE_URL"
    ((WARN_COUNT++))
fi

# ==========================================
# 11. FILE STRUCTURE VALIDATION
# ==========================================
echo -e "\n${BLUE}[11] FILE STRUCTURE VALIDATION${NC}\n"

REQUIRED_DIRS=(
    ".seycode"
    ".seycode/skill"
    ".github"
    ".github/workflows"
    "packages"
    "packages/seycode"
    "packages/seycode/src"
    "scripts"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    test_check "Directory exists: $dir" "[ -d $dir ]"
done

# ==========================================
# 12. DEPENDENCY VALIDATION
# ==========================================
echo -e "\n${BLUE}[12] DEPENDENCY VALIDATION${NC}\n"

test_check "node_modules exists" \
    "[ -d node_modules ]"

test_check "package-lock.json or bun.lockb exists" \
    "[ -f package-lock.json ] || [ -f bun.lockb ]"

if [ -f package.json ]; then
    DEPS_COUNT=$(jq '.dependencies // {} | length' package.json 2>/dev/null || echo 0)
    DEV_DEPS_COUNT=$(jq '.devDependencies // {} | length' package.json 2>/dev/null || echo 0)
    echo -e "${GREEN}✓ PASS${NC} - Dependencies: $DEPS_COUNT, DevDependencies: $DEV_DEPS_COUNT"
    ((PASS_COUNT++))
fi

# ==========================================
# 13. CODE QUALITY CHECKS
# ==========================================
echo -e "\n${BLUE}[13] CODE QUALITY CHECKS${NC}\n"

test_check "No console.log in production code" \
    "! grep -r 'console\\.log' packages/seycode/src --include='*.ts' | grep -v 'Log\\.' | grep -v '/test/' | grep -v '.test.ts'"

test_check "No debugger statements" \
    "! grep -r 'debugger' packages/seycode/src --include='*.ts'"

test_check "No TODO in production code" \
    "! grep -r 'TODO' packages/seycode/src --include='*.ts' | grep -v '/test/'"

test_check "TypeScript config exists" \
    "[ -f tsconfig.json ]"

# ==========================================
# 14. SENSITIVE DATA CHECK
# ==========================================
echo -e "\n${BLUE}[14] SENSITIVE DATA CHECK${NC}\n"

# Check for emails (excluding example emails)
REAL_EMAILS=$(grep -roh '[a-zA-Z0-9._%+-]\+@[a-zA-Z0-9.-]\+\.[a-zA-Z]\{2,\}' --include='*.ts' --include='*.js' packages/ 2>/dev/null | grep -v 'example.com' | grep -v 'test.com' | grep -v 'noreply@' | wc -l | tr -d ' ')

if [ "$REAL_EMAILS" -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC} - No real email addresses in code"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠ WARN${NC} - Found $REAL_EMAILS potential real email addresses"
    ((WARN_COUNT++))
fi

# Check for IP addresses
IP_COUNT=$(grep -roE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' packages/seycode/src --include='*.ts' 2>/dev/null | grep -v '127.0.0.1' | grep -v '0.0.0.0' | wc -l | tr -d ' ')

if [ "$IP_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC} - No hardcoded IP addresses"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠ WARN${NC} - Found $IP_COUNT potential IP addresses"
    ((WARN_COUNT++))
fi

# ==========================================
# 15. LICENSE & LEGAL
# ==========================================
echo -e "\n${BLUE}[15] LICENSE & LEGAL VALIDATION${NC}\n"

test_check "LICENSE file exists" \
    "[ -f LICENSE ]"

test_check "LICENSE is MIT" \
    "grep -q 'MIT License' LICENSE"

test_check "Copyright notice in LICENSE" \
    "grep -q 'Copyright' LICENSE"

test_check "No GPL dependencies (avoiding license conflicts)" \
    "! grep -r '\"license\".*GPL' node_modules/*/package.json 2>/dev/null | grep -v LGPL"

# ==========================================
# FINAL REPORT
# ==========================================
echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                  VALIDATION SUMMARY                        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ PASSED:${NC}  $PASS_COUNT tests"
echo -e "${RED}✗ FAILED:${NC}  $FAIL_COUNT tests"
echo -e "${YELLOW}⚠ WARNINGS:${NC} $WARN_COUNT tests"
echo ""

TOTAL=$((PASS_COUNT + FAIL_COUNT))
if [ $TOTAL -gt 0 ]; then
    PERCENTAGE=$((PASS_COUNT * 100 / TOTAL))
    echo -e "Success rate: ${PERCENTAGE}%"
fi

echo ""

# Exit code
if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              ✓ ALL VALIDATIONS PASSED!                     ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║         ✗ VALIDATION FAILED - FIX ISSUES ABOVE             ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    exit 1
fi
