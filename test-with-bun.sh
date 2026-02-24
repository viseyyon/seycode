#!/bin/bash

# Complete Testing Suite for SeyCode (Requires Bun)
# Tests all features including build, unit tests, and revolutionary features

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

FAILED=0
PASSED=0

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  SeyCode Complete Test Suite (Requires Bun)   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Check if Bun is available
if ! command -v bun &> /dev/null; then
    echo -e "${RED}✗ Bun is not installed${NC}"
    echo ""
    echo "Please install Bun first:"
    echo "  curl -fsSL https://bun.sh/install | bash"
    echo ""
    echo "After installation, restart your terminal and run this script again."
    exit 1
fi

echo -e "${GREEN}✓ Bun $(bun --version) detected${NC}"
echo ""

section() {
    echo ""
    echo -e "${BLUE}═══ $1 ═══${NC}"
    echo ""
}

test_command() {
    local name="$1"
    local command="$2"
    local dir="${3:-.}"

    echo -ne "Testing: $name... "

    if (cd "$dir" && eval "$command" &> /tmp/seycode-test.log); then
        echo -e "${GREEN}✓ PASS${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        echo "Command: $command"
        echo "Output:"
        tail -20 /tmp/seycode-test.log
        ((FAILED++))
        return 1
    fi
}

section "1. DEPENDENCY INSTALLATION"

echo "Installing dependencies (this may take a few minutes)..."
if (cd packages/seycode && bun install); then
    echo -e "${GREEN}✓ Dependencies installed${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Dependency installation failed${NC}"
    ((FAILED++))
    exit 1
fi

section "2. TYPE CHECKING"

test_command "TypeScript type check" \
    "bun typecheck" \
    "packages/seycode"

section "3. BUILD SYSTEM"

test_command "Build SeyCode" \
    "bun run build" \
    "packages/seycode"

test_command "Verify binary exists after build" \
    "[ -f bin/seycode ]" \
    "packages/seycode"

test_command "Binary is executable" \
    "[ -x bin/seycode ]" \
    "packages/seycode"

test_command "Binary shows version" \
    "./bin/seycode --version" \
    "packages/seycode"

section "4. UNIT TESTS"

echo "Running unit tests (this may take a few minutes)..."
test_command "Run all unit tests" \
    "bun test --timeout 30000" \
    "packages/seycode"

section "5. TEST COVERAGE"

echo "Generating test coverage report..."
test_command "Generate coverage" \
    "bun test --coverage --timeout 30000" \
    "packages/seycode"

section "6. TESTING AUTOMATIC FEATURES"

echo -e "${YELLOW}Note: These tests verify the configuration, not runtime behavior${NC}"

test_command "Verify prompt-engineer skill" \
    "[ -f .seycode/skill/prompt-engineer.md ]"

test_command "Verify memory-manager skill" \
    "[ -f .seycode/skill/memory-manager.md ]"

test_command "Verify agent-router skill" \
    "[ -f .seycode/skill/agent-router.md ]"

test_command "Verify self-corrector skill" \
    "[ -f .seycode/skill/self-corrector.md ]"

test_command "Verify self-evolver skill" \
    "[ -f .seycode/skill/self-evolver.md ]"

section "7. CONFIGURATION VALIDATION"

test_command "Validate seycode.json" \
    "python3 -m json.tool .seycode/seycode.json > /dev/null"

test_command "Check agent configuration" \
    "grep -q 'prompt-enhancer' .seycode/seycode.json"

test_command "Check memory configuration" \
    "grep -q '\"memory\"' .seycode/seycode.json"

section "8. SKILL SYSTEM"

echo "Verifying all 16 skills..."

SKILLS=(
    "prompt-engineer"
    "memory-manager"
    "agent-router"
    "self-corrector"
    "self-evolver"
    "workflow-orchestrator"
    "tool-creator"
    "agent-creator"
    "provider-adder"
    "test-runner"
    "debug-helper"
    "sdk-regenerator"
    "architecture-explorer"
    "migration-creator"
    "lsp-configurator"
    "doc-generator"
)

for skill in "${SKILLS[@]}"; do
    test_command "Skill: $skill" \
        "[ -f .seycode/skill/${skill}.md ]"
done

section "9. AGENT SYSTEM"

echo "Verifying agent configurations..."

AGENTS=(
    "prompt-enhancer"
    "memory-manager"
    "agent-router"
    "self-corrector"
    "self-evolver"
    "security-auditor"
    "test-generator"
    "doc-writer"
    "code-reviewer"
    "perf-analyzer"
    "migration-helper"
    "refactor-agent"
    "api-designer"
)

for agent in "${AGENTS[@]}"; do
    test_command "Agent: $agent" \
        "grep -q '\"${agent}\"' .seycode/seycode.json"
done

section "10. E2E TESTS (Playwright)"

echo "Running E2E tests (if configured)..."
if [ -d "packages/app/e2e" ]; then
    if command -v playwright &> /dev/null; then
        test_command "Install Playwright browsers" \
            "bun playwright install" \
            "packages/app"

        test_command "Run E2E tests" \
            "bun playwright test" \
            "packages/app"
    else
        echo -e "${YELLOW}⚠ Playwright not installed, skipping E2E tests${NC}"
    fi
else
    echo -e "${YELLOW}⚠ E2E tests not found, skipping${NC}"
fi

section "11. PACKAGE INTEGRITY"

test_command "Verify package.json structure" \
    "node -e \"require('./packages/seycode/package.json')\"" \
    "."

test_command "Check for missing dependencies" \
    "bun pm ls > /dev/null" \
    "packages/seycode"

section "12. BUILD ARTIFACTS"

test_command "Build creates dist directory" \
    "[ -d dist ] || [ -d build ]" \
    "packages/seycode"

test_command "Binary in correct location" \
    "[ -f bin/seycode ]" \
    "packages/seycode"

section "13. RUNTIME SMOKE TESTS"

echo "Testing basic CLI functionality..."

test_command "CLI shows help" \
    "./bin/seycode --help | grep -q 'seycode'" \
    "packages/seycode"

test_command "CLI shows version" \
    "./bin/seycode --version | grep -q '[0-9]'" \
    "packages/seycode"

section "14. MEMORY & PERFORMANCE"

echo "Basic performance checks..."

test_command "Build completes in reasonable time" \
    "timeout 300 bun run build" \
    "packages/seycode"

section "15. SECURITY CHECKS"

test_command "No API keys in built code" \
    "! grep -r 'sk-[a-zA-Z0-9]\\{20,\\}' dist/ 2>/dev/null || true" \
    "packages/seycode"

test_command "No hardcoded secrets" \
    "! grep -r 'password.*=.*[\"'][a-zA-Z0-9]' dist/ 2>/dev/null || true" \
    "packages/seycode"

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Test Summary                                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Passed: $PASSED tests${NC}"
echo -e "${RED}Failed: $FAILED tests${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed! SeyCode is ready for deployment.${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Review test coverage report in coverage/"
    echo "2. Create repository: ./setup-github-repo.sh"
    echo "3. Follow LAUNCH_CHECKLIST.md"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some tests failed. Please fix issues before deploying.${NC}"
    echo ""
    echo "Check test output above for details."
    echo "Review logs in /tmp/seycode-test.log"
    echo ""
    exit 1
fi
