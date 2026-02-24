# Repository Setup Guide

This guide walks through creating the private SeyCode repository on GitHub under the Viseyyon organization.

## Pre-Launch Checklist

Before creating the repository, verify all steps are complete:

### ✅ Documentation Complete

- [x] GETTING_STARTED.md - User onboarding guide
- [x] TESTING.md - Comprehensive testing guide
- [x] CHANGELOG.md - Version history
- [x] README.md - Updated with hero section (needs final review)
- [x] CLAUDE.md - Developer guide (1,163 lines)
- [x] ARCHITECTURE.md - Architecture documentation (542 lines)
- [x] SEYCODE.md - Marketing overview (338 lines)
- [x] CONTRIBUTING.md - Contribution guidelines
- [x] SECURITY.md - Security policies
- [x] AGENTS.md - Style guide
- [x] All 16 skill docs in `.seycode/skill/`
- [x] REVOLUTION_COMPLETE.md - Feature summary
- [x] REBRANDING_COMPLETE.md - Rebranding record

### ⏳ Documentation To Complete (Optional for Initial Release)

- [ ] USER_GUIDE.md - Comprehensive user manual (800 lines) - Can be added post-launch
- [ ] API.md - API documentation (600 lines) - Can be added post-launch
- [ ] DEVELOPMENT.md - Development setup guide (700 lines) - Can use CLAUDE.md for now
- [ ] PLUGINS.md - Plugin development guide (500 lines) - Can be added post-launch
- [ ] SKILLS.md - Skill authoring guide (600 lines) - Can be added post-launch
- [ ] TROUBLESHOOTING.md - Comprehensive troubleshooting (400 lines) - Basic version in GETTING_STARTED.md
- [ ] ROADMAP.md - Project roadmap (300 lines) - Can be added post-launch
- [ ] DEPLOYMENT.md - Production deployment (500 lines) - Can be added post-launch
- [ ] CODE_OF_CONDUCT.md - Community standards (150 lines) - Can use standard template
- [ ] GOVERNANCE.md - Project governance (200 lines) - Can be added post-launch

### ✅ Rebranding Complete

- [x] All directories renamed (`.opencode/` → `.seycode/`)
- [x] All files renamed (42+ files)
- [x] All package names updated
- [x] All content replaced (662+ files)
- [x] All URLs updated (`opencode.ai` → `seycode.ai`)
- [x] All environment variables updated
- [x] Zero remaining "opencode" references verified

### ⏳ Testing To Complete

**Critical Tests (Must Complete Before Launch):**
- [ ] Basic installation test (macOS, Linux, Windows)
- [ ] CLI starts successfully (`seycode --version`)
- [ ] Server starts successfully (`seycode serve`)
- [ ] Session creation works
- [ ] Basic prompt/response works
- [ ] At least one automatic feature verified (prompt engineering)
- [ ] No critical errors in startup

**Full Test Suite (Can Complete Post-Initial Commit):**
- [ ] All unit tests passing (`cd packages/seycode && bun test`)
- [ ] All E2E tests passing (`cd packages/app && bun playwright test`)
- [ ] All 5 revolutionary features tested
- [ ] All 16 skills tested
- [ ] Platform compatibility verified
- [ ] Performance benchmarks established
- [ ] Security audit completed

---

## Step 1: Run Basic Tests

Before creating the repository, run basic smoke tests:

```bash
# Check if it builds
cd packages/seycode
bun install
bun run build

# Verify binary works
./bin/seycode --version

# Check for any critical errors
bun typecheck
```

**Expected output:**
```
seycode 1.2.10
```

If tests fail, fix issues before proceeding.

---

## Step 2: Create GitHub Repository

### 2.1 Manual Creation (Recommended)

1. **Go to Viseyyon Organization**:
   - Navigate to: https://github.com/orgs/viseyyon/repositories
   - Click "New repository"

2. **Repository Settings**:
   ```
   Owner: viseyyon
   Repository name: seycode
   Description: The world's first truly intelligent AI coding agent with revolutionary automatic features
   Visibility: Private (initially)
   ```

3. **Initialize Repository**:
   - [x] Add README (we have one)
   - [ ] Add .gitignore (we have one)
   - [ ] Choose a license (we have MIT)
   - Click "Create repository"

### 2.2 Using GitHub CLI (Alternative)

```bash
# Create private repository in viseyyon org
gh repo create viseyyon/seycode \
  --private \
  --description "The world's first truly intelligent AI coding agent with revolutionary automatic features" \
  --homepage "https://seycode.ai"
```

---

## Step 3: Configure Repository

### 3.1 Repository Settings

Navigate to: `https://github.com/viseyyon/seycode/settings`

**General Settings:**
- [ ] Enable Issues
- [ ] Enable Discussions
- [ ] Disable Wiki (or enable if wanted)
- [ ] Disable Projects (or enable if wanted)
- [ ] Set default branch to `dev`

**Topics/Tags:**
Add these topics:
```
ai, coding-agent, typescript, llm, automation, prompt-engineering,
ai-assistant, developer-tools, claude, anthropic, bun
```

**Social Links:**
- Website: `https://seycode.ai`
- Documentation: `https://docs.seycode.ai`
- Discord: `https://discord.gg/seycode`

### 3.2 Branch Protection

Navigate to: `Settings` → `Branches` → `Add branch protection rule`

**For `main` branch:**
```
Branch name pattern: main
☑ Require a pull request before merging
  ☑ Require approvals: 1
  ☑ Dismiss stale pull request approvals when new commits are pushed
☑ Require status checks to pass before merging
  ☑ Require branches to be up to date before merging
  Status checks: tests, typecheck
☑ Require conversation resolution before merging
☑ Do not allow bypassing the above settings
☑ Restrict who can push to matching branches (optional)
```

**For `dev` branch:**
```
Branch name pattern: dev
☑ Require a pull request before merging
  ☑ Require approvals: 1 (can be lower for dev)
☑ Require status checks to pass before merging
☑ Do not allow bypassing the above settings
```

### 3.3 Security Settings

Navigate to: `Settings` → `Security` → `Code security and analysis`

Enable:
- [ ] Dependabot alerts
- [ ] Dependabot security updates
- [ ] Secret scanning
- [ ] Push protection

---

## Step 4: Push Codebase

### 4.1 Update Git Remote

```bash
# Check current remote
git remote -v

# If remote exists (old OpenCode), update it
git remote set-url origin https://github.com/viseyyon/seycode.git

# If no remote exists, add it
git remote add origin https://github.com/viseyyon/seycode.git
```

### 4.2 Push Code

```bash
# Verify you're on dev branch
git branch --show-current

# If not on dev, switch to it
git checkout dev

# Push dev branch
git push -u origin dev

# Create main branch from dev (if needed)
git checkout -b main
git push -u origin main

# Switch back to dev
git checkout dev
```

### 4.3 Verify Push

Check on GitHub that both branches are present:
- `https://github.com/viseyyon/seycode/tree/dev`
- `https://github.com/viseyyon/seycode/tree/main`

---

## Step 5: Configure GitHub Actions

### 5.1 Verify Workflow Files

Check that these workflow files exist and are configured:
- `.github/workflows/publish.yml` - Build and publish
- `.github/workflows/review.yml` - PR reviews
- `.github/workflows/sign-cli.yml` - Binary signing
- `.github/workflows/docs-locale-sync.yml` - Documentation sync

### 5.2 Add Secrets

Navigate to: `Settings` → `Secrets and variables` → `Actions`

Add these secrets (as needed):
```
ANTHROPIC_API_KEY - For testing
OPENAI_API_KEY - For testing (optional)
NPM_TOKEN - For publishing to npm
HOMEBREW_TAP_TOKEN - For Homebrew formula updates
```

### 5.3 Trigger First Workflow

Make a small commit to trigger workflows:
```bash
echo "Initial setup complete" >> .github/SETUP_COMPLETE.md
git add .github/SETUP_COMPLETE.md
git commit -m "Trigger initial CI/CD workflow"
git push
```

Check: `https://github.com/viseyyon/seycode/actions`

---

## Step 6: Post-Setup Configuration

### 6.1 Enable Discussions

Navigate to: `Settings` → `Features` → Enable Discussions

Create initial discussion categories:
- General
- Ideas / Feature Requests
- Q&A
- Show and Tell
- Announcements

### 6.2 Configure Issue Templates

Verify these templates exist in `.github/ISSUE_TEMPLATE/`:
- `bug_report.yml` - Bug reports
- `feature_request.yml` - Feature requests
- `question.yml` - Questions
- `config.yml` - Template config

### 6.3 Add Repository Description

Edit repository description to include:
```
🚀 The world's first truly intelligent AI coding agent with 5 revolutionary automatic features: prompt engineering, memory management, agent routing, self-correction, and self-evolution. Built with TypeScript, powered by Claude/GPT, featuring 16 production-ready skills.
```

### 6.4 Create Initial Release (Draft)

Navigate to: `Releases` → `Draft a new release`

```
Tag version: v1.0.0-beta.1
Release title: SeyCode v1.0.0 Beta 1 - Initial Release
Target: dev

Description:
# 🚀 SeyCode v1.0.0 Beta 1

**The world's first truly intelligent AI coding agent is here!**

## 🌟 5 Revolutionary Features

1. ⚡ **Automatic Prompt Engineering** - Every prompt optimized automatically
2. 💾 **Automatic Memory Management** - Every action checkpointed automatically
3. 🎯 **Automatic Agent Routing** - Optimal agents selected automatically
4. 🔧 **Automatic Self-Correction** - Errors fixed and learned automatically
5. 🧠 **Automatic Self-Evolution** - Gets smarter every day automatically

## 📦 Installation

[Installation instructions from GETTING_STARTED.md]

## 📚 Documentation

- [Getting Started](./GETTING_STARTED.md)
- [User Guide](./CLAUDE.md)
- [Architecture](./ARCHITECTURE.md)
- [Testing](./TESTING.md)

## 🐛 Known Issues

[List any known issues]

## 💬 Community

- Discord: https://discord.gg/seycode
- GitHub: https://github.com/viseyyon/seycode
- Docs: https://docs.seycode.ai

---

**Note**: This is a beta release. Some features may be unstable.

☑ This is a pre-release
☐ Set as the latest release (keep unchecked for beta)
```

**Save as draft** - Don't publish until ready.

---

## Step 7: Verification Checklist

Before making repository public (if/when desired):

### Repository Configuration
- [ ] Description is clear and compelling
- [ ] Topics/tags added
- [ ] Default branch set to `dev`
- [ ] Branch protection enabled
- [ ] Issues enabled
- [ ] Discussions enabled (optional)
- [ ] Wiki disabled (or configured)

### Documentation
- [ ] README.md looks good on GitHub
- [ ] All documentation links work
- [ ] No broken internal links
- [ ] Images/screenshots load correctly
- [ ] Code examples are correct

### Code Quality
- [ ] All tests passing (or most)
- [ ] No critical bugs
- [ ] Build succeeds
- [ ] TypeScript compiles
- [ ] Linter passes

### Security
- [ ] No secrets in code
- [ ] No API keys committed
- [ ] Security scanning enabled
- [ ] Vulnerability alerts enabled

### CI/CD
- [ ] GitHub Actions configured
- [ ] Workflows running successfully
- [ ] Required secrets added

### Community
- [ ] Issue templates working
- [ ] PR template working
- [ ] Contributing guidelines clear
- [ ] Code of conduct present (optional)

---

## Step 8: Invite Collaborators (Optional)

If you want to add team members:

Navigate to: `Settings` → `Collaborators and teams`

Add collaborators with appropriate permissions:
- **Admin**: Full access
- **Write**: Can push code
- **Read**: Can view only (for private repos)

---

## Step 9: Making Repository Public (Future)

When ready to make the repository public:

1. **Final Review**:
   - [ ] All sensitive information removed
   - [ ] Documentation complete
   - [ ] Tests passing
   - [ ] Ready for public scrutiny

2. **Change Visibility**:
   - Navigate to: `Settings` → `Danger Zone`
   - Click "Change repository visibility"
   - Select "Public"
   - Confirm change

3. **Announce**:
   - Publish GitHub release
   - Announce on Discord
   - Post on social media
   - Submit to relevant communities

---

## Troubleshooting

### Issue: "Permission denied" when pushing

**Solution**: Check SSH keys or HTTPS credentials:
```bash
# Test SSH connection
ssh -T git@github.com

# Or use HTTPS with token
git remote set-url origin https://<TOKEN>@github.com/viseyyon/seycode.git
```

### Issue: Workflows not running

**Solution**: Check workflow permissions:
- Go to: `Settings` → `Actions` → `General`
- Ensure "Allow all actions and reusable workflows" is selected
- Ensure "Read and write permissions" is enabled

### Issue: Branch protection blocking pushes

**Solution**: Temporarily disable or adjust branch protection:
- Go to: `Settings` → `Branches`
- Edit protection rule
- Uncheck "Include administrators" if you need to push directly

---

## Quick Commands Summary

```bash
# Clone your new repo
git clone https://github.com/viseyyon/seycode.git
cd seycode

# Or update existing local repo
git remote set-url origin https://github.com/viseyyon/seycode.git

# Push to new remote
git push -u origin dev
git push -u origin main

# Create initial tag
git tag v1.0.0-beta.1
git push origin v1.0.0-beta.1

# Verify setup
git remote -v
git branch -a
git log --oneline -5
```

---

## Next Steps After Repository Setup

1. **Complete remaining documentation** (post-launch priority):
   - USER_GUIDE.md
   - API.md
   - DEVELOPMENT.md
   - TROUBLESHOOTING.md

2. **Run full test suite**:
   - Fix any failing tests
   - Add missing tests
   - Achieve 80%+ coverage

3. **Set up additional infrastructure**:
   - Documentation site (docs.seycode.ai)
   - Landing page (seycode.ai)
   - Discord server
   - Social media accounts

4. **Plan first release**:
   - Set release date
   - Prepare announcement
   - Create marketing materials
   - Plan community engagement

5. **Monitor and iterate**:
   - Watch for issues
   - Respond to community
   - Fix critical bugs
   - Plan next features

---

## Support

If you encounter issues during setup:

1. Check GitHub documentation: https://docs.github.com
2. Check Viseyyon organization settings
3. Contact organization admin
4. Review GitHub Actions logs for CI/CD issues

---

**Repository setup complete! Your SeyCode repository is ready for development and collaboration.** 🎉
