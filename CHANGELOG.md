# Changelog

All notable changes to SeyCode will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial public release of SeyCode
- 5 revolutionary automatic features:
  - Automatic prompt engineering for every prompt
  - Automatic memory management with checkpoints
  - Automatic agent routing to optimal agents
  - Automatic self-correction with learning
  - Automatic self-evolution creating new skills
- 16 production-ready skills (5 automatic, 11 manual)
- 13 custom specialized agents
- 3 built-in agents (build, plan, general)
- Complete documentation (5,000+ lines)
- Comprehensive testing infrastructure
- Multi-platform support (macOS, Linux, Windows)
- Multiple installation methods (curl, npm, Homebrew, etc.)
- TUI, Web UI, and Desktop app interfaces
- LSP integration for multiple languages
- MCP (Model Context Protocol) support
- Plugin system for extensibility
- 15+ LLM provider integrations
- Session management with persistence
- Project detection and context isolation
- Skill system with markdown-based definitions
- Agent permission system
- Tool registry with builtin and custom tools
- SQLite storage with Drizzle ORM
- Event-driven architecture
- Configuration system with precedence
- Internationalization (18 languages)

### Changed
- Complete rebranding from OpenCode to SeyCode
- All references updated throughout codebase
- Directory structure: `.opencode/` → `.seycode/`
- Package names: `opencode` → `seycode`
- Binary names: `opencode` → `seycode`
- URLs: `opencode.ai` → `seycode.ai`
- Environment variables: `OPENCODE_*` → `SEYCODE_*`

## [1.2.10] - 2026-02-24 (Pre-Rebrand)

### Added
- Initial OpenCode implementation
- Basic agent system
- Tool system
- Session management
- LLM integrations

### Notes
- This was the last version before rebranding to SeyCode
- All future releases will be under the SeyCode name

---

## Version Numbering

SeyCode follows [Semantic Versioning](https://semver.org/):

- **MAJOR** version: Incompatible API changes
- **MINOR** version: New functionality (backwards-compatible)
- **PATCH** version: Bug fixes (backwards-compatible)

## Release Process

1. Update CHANGELOG.md with new version and changes
2. Update version in all package.json files
3. Create git tag: `git tag v1.0.0`
4. Push tag: `git push origin v1.0.0`
5. GitHub Actions automatically builds and publishes release

## Support

- **Security Issues**: See [SECURITY.md](./SECURITY.md)
- **Bug Reports**: [GitHub Issues](https://github.com/viseyyon/seycode/issues)
- **Feature Requests**: [GitHub Discussions](https://github.com/viseyyon/seycode/discussions)
- **Community**: [Discord](https://discord.gg/seycode)

---

**Legend**:
- `Added` - New features
- `Changed` - Changes in existing functionality
- `Deprecated` - Soon-to-be removed features
- `Removed` - Removed features
- `Fixed` - Bug fixes
- `Security` - Security vulnerabilities fixed
