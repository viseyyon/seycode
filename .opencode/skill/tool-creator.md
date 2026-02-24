---
name: tool-creator
description: Create a new tool for SeyCode with proper structure, registration, and SDK generation
---

# Tool Creator

Create a new tool for SeyCode following the established patterns.

## Steps

1. **Understand the requirement**: What should this tool do? What parameters does it need?

2. **Create the tool file** in `packages/opencode/src/tool/builtin/your-tool.ts`:
   ```typescript
   import { z } from "zod"
   import type { Tool } from "../tool"

   export const YourTool: Tool = {
     id: "your-tool",
     parameters: z.object({
       // Define parameters with Zod schema
       input: z.string().describe("Description of the parameter"),
       optional: z.number().optional().describe("Optional parameter"),
     }),
     description: "Clear description of what this tool does for the LLM",

     init: (ctx) => {
       // Initialize with context (project, session, etc.)
       return {
         // Return any context needed for execution
       }
     },

     execute: async (input, ctx) => {
       // Implement the tool logic
       // Return output that will be sent back to the LLM
       return {
         output: "Tool execution result"
       }
     }
   }
   ```

3. **Register the tool** in `packages/opencode/src/tool/registry.ts`:
   - Import your tool
   - Add to the `builtin` array

4. **Generate SDK**: Run `./script/generate.ts` to update the SDK and type definitions

5. **Test the tool**:
   ```bash
   cd packages/opencode
   bun test test/tool/your-tool.test.ts
   ```

6. **Document the tool**: If it's a major tool, add usage notes to CLAUDE.md

## Key Patterns

- **Streaming output**: Use `output.write()` for large/progressive output
- **Error handling**: Throw descriptive errors that help the LLM understand what went wrong
- **Permissions**: Check if tool respects agent permissions (read-only for plan agent)
- **Context usage**: Use `ctx.project`, `ctx.session` for project/session specific logic

## Example Tools to Reference

- `packages/opencode/src/tool/builtin/read.ts` - File reading
- `packages/opencode/src/tool/builtin/bash.ts` - Command execution
- `packages/opencode/src/tool/builtin/glob.ts` - Pattern matching

$ARGUMENTS
