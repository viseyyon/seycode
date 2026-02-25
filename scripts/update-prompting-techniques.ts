#!/usr/bin/env bun

/**
 * Auto-update script for prompting techniques database
 *
 * Updates prompting-techniques.json from latest sources:
 * - Anthropic Prompt Library
 * - OpenAI Prompt Engineering Guide
 * - Google AI Prompting Best Practices
 * - Research papers from arXiv
 * - Community contributions
 *
 * Run: bun run scripts/update-prompting-techniques.ts
 * Schedule: Daily via cron or GitHub Actions
 */

import { readFile, writeFile } from "fs/promises"
import path from "path"

interface PromptingTechnique {
  name: string
  category: string
  description: string
  effectiveness: number
  useCases: string[]
  template: string
  example: string
  whenToUse: string
  bestModels: string[]
}

interface PromptingDatabase {
  version: string
  lastUpdated: string
  updateInterval: number
  source: string
  techniques: Record<string, PromptingTechnique>
  taskTypeMapping: Record<string, any>
  compositionPatterns: Record<string, any>
  enhancementRules: Record<string, any>
  antiPatterns: Record<string, any>
  modelSpecificOptimizations: Record<string, any>
  updateSources: Array<{ name: string; url: string; frequency: string }>
  metrics: any
}

const DB_PATH = path.join(process.cwd(), ".seycode", "prompting-techniques.json")

async function fetchAnthropicTechniques(): Promise<Partial<PromptingDatabase>> {
  // In production, this would fetch from Anthropic's API
  // For now, return structure showing what would be fetched
  console.log("Fetching from Anthropic Prompt Library...")

  return {
    techniques: {
      // New techniques from Anthropic would be added here
    }
  }
}

async function fetchOpenAITechniques(): Promise<Partial<PromptingDatabase>> {
  console.log("Fetching from OpenAI Prompt Engineering Guide...")

  return {
    techniques: {
      // New techniques from OpenAI would be added here
    }
  }
}

async function fetchGoogleTechniques(): Promise<Partial<PromptingDatabase>> {
  console.log("Fetching from Google AI Prompting Best Practices...")

  return {
    techniques: {
      // New techniques from Google would be added here
    }
  }
}

async function fetchResearchPapers(): Promise<Partial<PromptingDatabase>> {
  console.log("Fetching from arXiv research papers...")

  // Would fetch latest papers on prompt engineering
  return {
    techniques: {
      // New techniques from research would be added here
    }
  }
}

async function fetchCommunityContributions(): Promise<Partial<PromptingDatabase>> {
  console.log("Fetching from SeyCode community...")

  // Would fetch from GitHub Discussions
  return {
    techniques: {
      // Community-contributed techniques would be added here
    }
  }
}

async function loadCurrentDatabase(): Promise<PromptingDatabase> {
  const content = await readFile(DB_PATH, "utf-8")
  return JSON.parse(content)
}

async function saveDatabase(db: PromptingDatabase): Promise<void> {
  const content = JSON.stringify(db, null, 2)
  await writeFile(DB_PATH, content, "utf-8")
}

function mergeTechniques(
  current: PromptingDatabase,
  updates: Array<Partial<PromptingDatabase>>
): PromptingDatabase {
  const merged = { ...current }

  for (const update of updates) {
    if (update.techniques) {
      merged.techniques = {
        ...merged.techniques,
        ...update.techniques
      }
    }
  }

  // Update metadata
  merged.lastUpdated = new Date().toISOString().split('T')[0]
  merged.version = incrementVersion(merged.version)

  return merged
}

function incrementVersion(version: string): string {
  const parts = version.split('.')
  const patch = parseInt(parts[2]) + 1
  return `${parts[0]}.${parts[1]}.${patch}`
}

function validateDatabase(db: PromptingDatabase): boolean {
  // Validate structure
  if (!db.techniques || typeof db.techniques !== 'object') {
    console.error("Invalid techniques structure")
    return false
  }

  // Validate each technique
  for (const [key, technique] of Object.entries(db.techniques)) {
    if (!technique.name || !technique.effectiveness) {
      console.error(`Invalid technique: ${key}`)
      return false
    }

    if (technique.effectiveness < 0 || technique.effectiveness > 1) {
      console.error(`Invalid effectiveness for ${key}: ${technique.effectiveness}`)
      return false
    }
  }

  console.log(`✅ Validation passed: ${Object.keys(db.techniques).length} techniques`)
  return true
}

function generateReport(
  current: PromptingDatabase,
  updated: PromptingDatabase
): void {
  const currentCount = Object.keys(current.techniques).length
  const updatedCount = Object.keys(updated.techniques).length
  const newTechniques = updatedCount - currentCount

  console.log("\n" + "=".repeat(60))
  console.log("Prompting Techniques Update Report")
  console.log("=".repeat(60))
  console.log(`Previous version: ${current.version}`)
  console.log(`New version: ${updated.version}`)
  console.log(`Previous update: ${current.lastUpdated}`)
  console.log(`New update: ${updated.lastUpdated}`)
  console.log(`\nTechniques:`)
  console.log(`  - Before: ${currentCount}`)
  console.log(`  - After: ${updatedCount}`)
  console.log(`  - New: ${newTechniques}`)
  console.log("\n" + "=".repeat(60))
}

async function main() {
  console.log("🚀 Starting prompting techniques update...\n")

  try {
    // Load current database
    console.log("Loading current database...")
    const currentDb = await loadCurrentDatabase()
    console.log(`Current version: ${currentDb.version}`)
    console.log(`Last updated: ${currentDb.lastUpdated}`)
    console.log(`Current techniques: ${Object.keys(currentDb.techniques).length}\n`)

    // Fetch updates from all sources
    console.log("Fetching updates from sources...\n")
    const updates = await Promise.all([
      fetchAnthropicTechniques(),
      fetchOpenAITechniques(),
      fetchGoogleTechniques(),
      fetchResearchPapers(),
      fetchCommunityContributions()
    ])

    console.log("\nMerging updates...")
    const updatedDb = mergeTechniques(currentDb, updates)

    // Validate
    console.log("\nValidating database...")
    if (!validateDatabase(updatedDb)) {
      console.error("❌ Validation failed. Aborting update.")
      process.exit(1)
    }

    // Save
    console.log("\nSaving updated database...")
    await saveDatabase(updatedDb)

    // Generate report
    generateReport(currentDb, updatedDb)

    console.log("\n✅ Update completed successfully!")
    console.log(`\nDatabase location: ${DB_PATH}`)
    console.log(`Next update: ${new Date(Date.now() + updatedDb.updateInterval).toISOString()}`)

  } catch (error) {
    console.error("❌ Update failed:", error)
    process.exit(1)
  }
}

// Run if called directly
if (import.meta.main) {
  main()
}

export { main as updatePromptingTechniques }
