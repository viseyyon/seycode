---
name: sdk-regenerator
description: Regenerate SDK and type definitions after API changes
subtask: true
---

# SDK Regenerator

Regenerate SDKs after making changes to SeyCode server API.

## When to Regenerate

Run `./script/generate.ts` after:
- ✅ Changes to `packages/seycode/src/server/server.ts`
- ✅ Adding/modifying server routes
- ✅ Adding/modifying tools
- ✅ Changes to API schemas
- ✅ Changes to Drizzle database schema

## Commands

### Regenerate All
```bash
./script/generate.ts
```

This regenerates:
- TypeScript SDK (`packages/sdk/js/`)
- OpenAPI specifications
- Type definitions
- Tool schemas

### Regenerate Only JavaScript SDK
```bash
./packages/sdk/js/script/build.ts
```

### Regenerate After Database Changes
```bash
cd packages/seycode
sey run db generate  # Generate Drizzle schema
cd ../..
./script/generate.ts  # Regenerate SDK
```

## Verification

After regeneration, check:

1. **SDK builds successfully**:
```bash
cd packages/sdk/js
sey run build
```

2. **Types are correct**:
```bash
sey typecheck
```

3. **No errors in generated files**:
```bash
git diff packages/sdk/
```

## What Gets Generated

**JavaScript SDK** (`packages/sdk/js/src/`):
- Client classes for API routes
- Type definitions
- Request/response types
- Tool parameter types

**OpenAPI Specs**:
- Route definitions
- Schema validation
- API documentation

**Type Definitions**:
- Shared types across packages
- Tool input/output types
- Session/message types

## Common Issues

**Generation fails?**
- Check server.ts has no syntax errors
- Ensure Hono routes are properly typed
- Verify Zod schemas are valid

**Types don't match?**
- Run `sey typecheck` to find mismatches
- Check if tool parameters changed
- Verify API route signatures

**Old types still exist?**
- Clear generated files: `rm -rf packages/sdk/js/src/generated`
- Regenerate: `./script/generate.ts`

## Integration with Workflow

Typical workflow:
1. Make changes to server code
2. Run `./script/generate.ts`
3. Run `sey typecheck` to verify
4. Test with `sey dev`
5. Run tests: `cd packages/seycode && sey test`

$ARGUMENTS
