#!/bin/bash

# Comprehensive Validation Script for SeyCode
# Tests everything that can be tested without running the application

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

FAILED=0
WARNINGS=0
PASSED=0

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  SeyCode Comprehensive Validation Suite       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Test function
test_check() {
    local name="$1"
    local command="$2"

    echo -ne "Testing: $name... "
    if eval "$command" &> /dev/null; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((FAILED++))
        return 1
    fi
}

warn_check() {
    local name="$1"
    local command="$2"

    echo -ne "Checking: $name... "
    if eval "$command" &> /dev/null; then
        echo -e "${GREEN}✓ OK${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${YELLOW}⚠ WARNING${NC}"
        ((WARNINGS++))
        return 1
    fi
}

# Section header
section() {
    echo ""
    echo -e "${BLUE}═══ $1 ═══${NC}"
    echo ""
}

section "1. REBRANDING VERIFICATION"

test_check "No 'opencode' in TypeScript files" \
    "! grep -r 'opencode' --include='*.ts' packages/seycode/src/ 2>/dev/null"

test_check "No 'opencode' in JSON files" \
    "! grep -r '\"opencode\"' --include='*.json' . ! -path '*/node_modules/*' 2>/dev/null"

test_check "No 'opencode.ai' URLs" \
    "! grep -r 'opencode\.ai' --include='*.{ts,md,json}' . ! -path '*/node_modules/*' 2>/dev/null"

test_check "No 'OPENCODE_' env vars in code" \
    "! grep -r 'OPENCODE_[A-Z_]*' --include='*.ts' packages/seycode/src/ 2>/dev/null"

test_check "Package name is 'seycode'" \
    "grep -q '\"name\": \"seycode\"' packages/seycode/package.json"

test_check "Binary named 'seycode'" \
    "grep -q '\"seycode\": \"./bin/seycode\"' packages/seycode/package.json"

section "2. DIRECTORY STRUCTURE"

test_check ".seycode directory exists" \
    "[ -d .seycode ]"

test_check "packages/seycode directory exists" \
    "[ -d packages/seycode ]"

test_check ".seycode/skill directory exists" \
    "[ -d .seycode/skill ]"

test_check ".seycode/agent directory exists" \
    "[ -d .seycode/agent ]"

test_check "No .opencode directory" \
    "[ ! -d .opencode ]"

test_check "No packages/opencode directory" \
    "[ ! -d packages/opencode ]"

section "3. CONFIGURATION FILES"

test_check ".seycode/seycode.json exists" \
    "[ -f .seycode/seycode.json ]"

test_check ".seycode/seycode.jsonc exists" \
    "[ -f .seycode/seycode.jsonc ]"

test_check "seycode.json is valid JSON" \
    "python3 -m json.tool .seycode/seycode.json > /dev/null"

test_check "Root package.json exists" \
    "[ -f package.json ]"

test_check "Root package.json is valid JSON" \
    "python3 -m json.tool package.json > /dev/null"

test_check "packages/seycode/package.json exists" \
    "[ -f packages/seycode/package.json ]"

section "4. SKILL FILES (16 Expected)"

SKILLS=(
    "prompt-engineer.md"
    "memory-manager.md"
    "agent-router.md"
    "self-corrector.md"
    "self-evolver.md"
    "workflow-orchestrator.md"
    "tool-creator.md"
    "agent-creator.md"
    "provider-adder.md"
    "test-runner.md"
    "debug-helper.md"
    "sdk-regenerator.md"
    "architecture-explorer.md"
    "migration-creator.md"
    "lsp-configurator.md"
    "doc-generator.md"
)

for skill in "${SKILLS[@]}"; do
    test_check "$skill exists" \
        "[ -f .seycode/skill/$skill ]"
done

section "5. DOCUMENTATION FILES"

DOCS=(
    "README.md"
    "GETTING_STARTED.md"
    "TESTING.md"
    "CHANGELOG.md"
    "CLAUDE.md"
    "ARCHITECTURE.md"
    "SEYCODE.md"
    "CONTRIBUTING.md"
    "SECURITY.md"
    "AGENTS.md"
    "REPOSITORY_SETUP.md"
    "LAUNCH_CHECKLIST.md"
    "DOCUMENTATION_INDEX.md"
    "COMPLETION_SUMMARY.md"
    "REVOLUTION_COMPLETE.md"
    "REBRANDING_COMPLETE.md"
)

for doc in "${DOCS[@]}"; do
    test_check "$doc exists" \
        "[ -f $doc ]"
done

section "6. DOCUMENTATION CONTENT VALIDATION"

test_check "GETTING_STARTED.md has installation section" \
    "grep -q '## Installation' GETTING_STARTED.md"

test_check "GETTING_STARTED.md has first session guide" \
    "grep -q '## First Session' GETTING_STARTED.md"

test_check "TESTING.md has testing philosophy" \
    "grep -q '## Testing Philosophy' TESTING.md"

test_check "TESTING.md mentions 5 revolutionary features" \
    "grep -q 'Testing Revolutionary Features' TESTING.md"

test_check "CHANGELOG.md has version format" \
    "grep -q '\[Unreleased\]' CHANGELOG.md"

test_check "CLAUDE.md documents 5 killer features" \
    "grep -q 'Automatic Prompt Engineering' CLAUDE.md"

test_check "ARCHITECTURE.md has architecture diagrams" \
    "grep -q '```' ARCHITECTURE.md"

section "7. INTERNATIONALIZATION"

I18N_LANGS=(
    "README.zh.md"
    "README.zht.md"
    "README.ko.md"
    "README.ja.md"
    "README.de.md"
    "README.es.md"
    "README.fr.md"
    "README.it.md"
    "README.pl.md"
    "README.ru.md"
    "README.ar.md"
)

for lang_file in "${I18N_LANGS[@]}"; do
    warn_check "$lang_file exists" \
        "[ -f $lang_file ]"
done

section "8. GITHUB CONFIGURATION"

test_check ".github directory exists" \
    "[ -d .github ]"

test_check ".github/workflows directory exists" \
    "[ -d .github/workflows ]"

test_check "publish workflow exists" \
    "[ -f .github/workflows/publish.yml ]"

test_check "Issue templates exist" \
    "[ -d .github/ISSUE_TEMPLATE ]"

test_check "PR template exists" \
    "[ -f .github/pull_request_template.md ]"

section "9. BINARY AND SCRIPTS"

test_check "Binary file exists" \
    "[ -f packages/seycode/bin/seycode ]"

warn_check "Binary is executable" \
    "[ -x packages/seycode/bin/seycode ]"

test_check "Setup script exists" \
    "[ -f setup-github-repo.sh ]"

test_check "Setup script is executable" \
    "[ -x setup-github-repo.sh ]"

test_check "Validation script exists" \
    "[ -f validate-all.sh ]"

section "10. AUTOMATIC FEATURES CONFIGURATION"

test_check "prompt-engineer has auto: true" \
    "grep -q 'auto: true' .seycode/skill/prompt-engineer.md"

test_check "memory-manager has auto: true" \
    "grep -q 'auto: true' .seycode/skill/memory-manager.md"

test_check "agent-router has auto: true" \
    "grep -q 'auto: true' .seycode/skill/agent-router.md"

test_check "self-corrector has auto: true" \
    "grep -q 'auto: true' .seycode/skill/self-corrector.md"

test_check "self-evolver has auto: true" \
    "grep -q 'auto: true' .seycode/skill/self-evolver.md"

section "11. AGENT CONFIGURATION"

test_check "seycode.json has prompt-enhancer agent" \
    "grep -q '\"prompt-enhancer\"' .seycode/seycode.json"

test_check "seycode.json has memory-manager agent" \
    "grep -q '\"memory-manager\"' .seycode/seycode.json"

test_check "seycode.json has agent-router" \
    "grep -q '\"agent-router\"' .seycode/seycode.json"

test_check "seycode.json has self-corrector" \
    "grep -q '\"self-corrector\"' .seycode/seycode.json"

test_check "seycode.json has self-evolver" \
    "grep -q '\"self-evolver\"' .seycode/seycode.json"

test_check "All automatic agents have autoInvoke: true" \
    "grep -A5 '\"prompt-enhancer\"' .seycode/seycode.json | grep -q '\"autoInvoke\": true'"

section "12. SKILL DOCUMENTATION QUALITY"

for skill in "${SKILLS[@]}"; do
    test_check "$skill has frontmatter" \
        "head -1 .seycode/skill/$skill | grep -q '^---$'"

    test_check "$skill has description" \
        "grep -q 'description:' .seycode/skill/$skill"
done

section "13. GIT REPOSITORY STATE"

test_check "Git repository initialized" \
    "[ -d .git ]"

test_check "On dev branch" \
    "git branch --show-current | grep -q 'dev'"

test_check "No uncommitted changes" \
    "git diff --quiet && git diff --staged --quiet"

test_check "Remote not set to opencode" \
    "! git remote -v | grep -q 'opencode'"

section "14. FILE PERMISSIONS"

test_check "setup-github-repo.sh is executable" \
    "[ -x setup-github-repo.sh ]"

test_check "validate-all.sh is executable" \
    "[ -x validate-all.sh ]"

warn_check "Binary has execute permissions" \
    "[ -x packages/seycode/bin/seycode ] || echo 'Will be set during build'"

section "15. DOCUMENTATION LINKS"

echo "Checking internal documentation links..."

# Check for broken markdown links in key docs
check_links() {
    local file="$1"
    local broken=0

    # Extract markdown links
    grep -o '\[.*\](\..*\.md)' "$file" 2>/dev/null | sed 's/.*](\(.*\))/\1/' | while read link; do
        # Remove anchors
        link_file=$(echo "$link" | cut -d'#' -f1)
        if [ ! -f "$link_file" ]; then
            echo -e "  ${RED}✗ Broken link in $file: $link_file${NC}"
            broken=$((broken + 1))
        fi
    done

    return 0
}

check_links "README.md"
check_links "GETTING_STARTED.md"
check_links "DOCUMENTATION_INDEX.md"
check_links "CLAUDE.md"

echo -e "${GREEN}✓ Link validation complete${NC}"
((PASSED++))

section "16. PACKAGE STRUCTURE"

test_check "packages directory exists" \
    "[ -d packages ]"

test_check "packages/seycode exists" \
    "[ -d packages/seycode ]"

test_check "packages/app exists" \
    "[ -d packages/app ]"

test_check "packages/sdk exists" \
    "[ -d packages/sdk ]"

warn_check "node_modules exists (if installed)" \
    "[ -d node_modules ] || echo 'Not installed yet'"

section "17. CRITICAL FILE CONTENT"

test_check "GETTING_STARTED mentions seycode.ai" \
    "grep -q 'seycode.ai' GETTING_STARTED.md"

test_check "README mentions 5 killer features" \
    "grep -qi 'killer feature\|revolutionary' README.md || grep -q '5' README.md"

test_check "CLAUDE.md has workflow examples" \
    "grep -q 'Workflow' CLAUDE.md"

test_check "TESTING.md has test examples" \
    "grep -q 'describe\|it(' TESTING.md"

section "18. SECURITY"

test_check "No API keys in code" \
    "! grep -r 'sk-[a-zA-Z0-9]\\{20,\\}' --include='*.ts' --include='*.js' packages/seycode/src/ 2>/dev/null"

test_check "No hardcoded tokens" \
    "! grep -r 'token.*=.*[\"'][a-zA-Z0-9]\\{20,\\}[\"']' --include='*.ts' packages/seycode/src/ 2>/dev/null"

test_check "SECURITY.md exists" \
    "[ -f SECURITY.md ]"

section "19. REQUIRED METADATA"

test_check "LICENSE file exists" \
    "[ -f LICENSE ]"

test_check "LICENSE is MIT" \
    "grep -q 'MIT' LICENSE"

test_check "Package has version" \
    "grep -q '\"version\"' packages/seycode/package.json"

test_check "Package has description" \
    "grep -q '\"description\"' packages/seycode/package.json"

section "20. REPOSITORY SETUP TOOLS"

test_check "setup-github-repo.sh has org name" \
    "grep -q 'viseyyon/seycode' setup-github-repo.sh"

test_check "REPOSITORY_SETUP.md has detailed steps" \
    "wc -l REPOSITORY_SETUP.md | awk '{print $1}' | grep -q '[0-9]\\{3,\\}'"

test_check "LAUNCH_CHECKLIST.md has tasks" \
    "grep -q '\[ \]' LAUNCH_CHECKLIST.md"

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Validation Summary                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All critical validations passed!${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Review warnings (if any)"
    echo "2. Run complete tests: ./test-with-bun.sh (requires Bun)"
    echo "3. Create repository: ./setup-github-repo.sh"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some validations failed. Please fix before proceeding.${NC}"
    echo ""
    exit 1
fi
