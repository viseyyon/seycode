---
name: migration-creator
description: Create database migrations for SeyCode's SQLite schema
---

# Migration Creator

Create and apply database migrations for SeyCode using Drizzle.

## Creating a Migration

### 1. Modify the schema
Edit schema in `packages/seycode/src/storage/db.ts`:

```typescript
import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core"

export const yourTable = sqliteTable("your_table", {
  id: text().primaryKey(),
  created_at: integer().notNull(),
  your_field: text().notNull(),
})
```

**Style note**: Use snake_case for field names (no need to specify column names).

### 2. Generate migration
```bash
cd packages/seycode
bun run db generate
```

This creates a migration file in `migration/` directory.

### 3. Review the migration
```bash
cat migration/0001_your_migration.sql
```

Check that:
- Table/column names are correct
- Indexes are created if needed
- No breaking changes without migration path

### 4. Apply migration
Migrations apply automatically on next SeyCode start, or manually:
```bash
cd packages/seycode
bun run db push
```

## Migration Commands

```bash
cd packages/seycode

# Generate migration from schema changes
bun run db generate

# Push schema directly to database (dev only)
bun run db push

# Open Drizzle Studio (database GUI)
bun run db studio
```

## Common Migration Patterns

### Adding a column
```typescript
// Before
export const table = sqliteTable("table", {
  id: text().primaryKey(),
})

// After
export const table = sqliteTable("table", {
  id: text().primaryKey(),
  new_field: text(),  // nullable by default
})
```

### Adding a required column
```typescript
// Must provide default or migration will fail
new_field: text().notNull().default("default_value")

// Or handle in migration SQL
```

### Adding an index
```typescript
export const table = sqliteTable("table", {
  id: text().primaryKey(),
  user_id: text().notNull(),
}, (table) => ({
  userIdIdx: index("user_id_idx").on(table.user_id),
}))
```

### Adding a relation
```typescript
export const message = sqliteTable("message", {
  id: text().primaryKey(),
  session_id: text().notNull().references(() => session.id),
})
```

## Migration Best Practices

1. **Test migrations on dev database first**
2. **Never edit applied migrations** - Create a new one
3. **Use snake_case** - Matches SQL conventions
4. **Make migrations reversible** when possible
5. **Test with actual data** - Don't just check schema

## Database Location

- Development: `$OPENCODE_DATA/seycode.db`
- Default: `~/.seycode/data/seycode.db`
- Override: Set `OPENCODE_DATA` env var

## Inspecting Database

### Using Drizzle Studio
```bash
cd packages/seycode
bun run db studio
# Opens web interface at http://localhost:4983
```

### Using SQLite CLI
```bash
sqlite3 ~/.seycode/data/seycode.db

# Useful commands
.tables              # List all tables
.schema table_name   # Show table schema
SELECT * FROM sessions LIMIT 10;
```

### Using Bun REPL
```bash
cd packages/seycode
bun repl

# Then:
const { db } = await import("./src/storage/db.ts")
await db.select().from(sessions).limit(10)
```

## Common Issues

**Migration fails with "table already exists"?**
- Delete `migration/` folder
- Drop the database (dev only)
- Regenerate migrations

**Column name mismatch?**
- Use snake_case in schema
- Don't specify column names explicitly

**Foreign key constraint fails?**
- Ensure referenced table exists
- Check that referenced IDs are valid
- Enable foreign keys: `PRAGMA foreign_keys = ON`

## Current Schema

Main tables:
- `sessions` - Session metadata
- `messages` - Conversation messages
- `parts` - Message parts (text, tool calls, reasoning)
- `projects` - Project information

$ARGUMENTS
