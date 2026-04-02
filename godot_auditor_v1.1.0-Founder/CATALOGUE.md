# ==============================================================================
# COPYRIGHT (C) 2026 ROUNDUP STUDIO. ALL RIGHTS RESERVED.
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL.
# UNAUTHORIZED COPYING, REVERSE ENGINEERING, OR DISTRIBUTION IS STRICTLY 
# PROHIBITED UNDER THE GODOT AUDITOR END USER LICENSE AGREEMENT (EULA).
# ==============================================================================

# Godot Auditor CLI — Feature Catalogue

**Version:** 1.0.0-beta  
**Last Updated:** March 13, 2026

---

## CLI Modes Overview (0-14)

Complete reference for all analysis modes and their capabilities.

---

### **MODE 0: Live File Watcher**
**File:** `godot_auditor/modes/watcher.py`  
**What it does:** Monitors your project in real-time. Watches `.gd` and `.tscn` files for changes and displays live status (🟢 RUNNING, 🟡 WARNING, 🟠 ERROR, 🔴 CRITICAL)

**Use case:** Long-running background monitoring during development. Spot breaking changes instantly.

**Output:** 
- Real-time status emoji (color coded severity)
- Event count (changes detected)
- Suspicious pattern count
- Last update timestamp

**Submenu options (W hotkey):**
- Start watcher
- Stop watcher
- View status
- Clear events

---

### **MODE 1: Architecture Overview**
**File:** `godot_auditor/modes/architecture.py`  
**What it does:** Maps entire project structure — scenes, scripts, dependencies, signals, all relationships.

**Use case:** Understand project at a glance. Find coupling hotspots. Identify architecture weaknesses.

**Output:**
- Dependency graph
- Signal definitions and connections
- Orphaned signals (defined but never emitted)
- Circular dependencies
- High-coupling code clusters

---

### **MODE 2: Beast Index (All Functions)**
**File:** `godot_auditor/modes/beast.py`  
**What it does:** Indexes EVERY function across entire codebase. Complete inventory. No function escapes.

**Use case:** Answer "where is function X?" instantly. Build baseline for tracking.

**Output:**
- Location (file:line)
- Function signature
- Reference count (how many places call it)
- Is it static/override/signal?

---

### **MODE 3: Single File Audit**
**File:** `godot_auditor/modes/single_audit.py`  
**What it does:** Deep dive into ONE `.gd` file. Full forensic analysis.

**Use case:** Debug a specific script. Verify correctness before shipping.

**Output:**
- All exports
- All dependencies (what this file imports)
- All functions (with line numbers)
- Dead code in this file
- Scene references
- Hardcoded paths

---

### **MODE 4: Final Ship Checklist**
**File:** `godot_auditor/modes/final_audit.py`  
**What it does:** Pre-release validation. Checks 50+ criteria for shipping readiness.

**Use case:** Before go-live. Catch last-minute issues.

**Output:**
- ❌ Critical blockers (must fix)
- ⚠️ Warnings (should fix)
- ✅ Passed checks
- Estimated risk score

---

### **MODE 5: AI Context Export**
**File:** `godot_auditor/modes/ai_context.py`  
**What it does:** Generate project context snapshot (Markdown + JSON). Feed to LLM for analysis.

**Use case:** "Use AI to do signal map." Export once, feed to your LLM of choice.

**Output:**
- `AI_CONTEXT.md` — Full text representation
- `AI_CONTEXT.json` — Structured data (optional)
- Ready to paste into Claude/ChatGPT/Ollama

---

### **MODE 6: Signal Map (Orphans & Typos)**
**File:** `godot_auditor/modes/signals.py`  
**What it does:** Find signal problems: orphaned signals, typos, mismatched names, duplicate definitions.

**Use case:** Debug signal architecture. Find why connection isn't firing.

**Output:**
- Orphaned signals (defined but never emitted)
- Duplicate definitions (signal defined twice)
- Typos (signal name never matches callers)
- Emission locations
- Connection listeners

---

### **MODE 7: Duplicate Names**
**File:** `godot_auditor/modes/duplicates.py`  
**What it does:** Find duplicate functions, classes, scene names, script names. Naming conflicts.

**Use case:** Prevent namespace collisions. Enforce unique identifiers.

**Output:**
- Duplicate function names (with locations)
- Duplicate scene names
- Duplicate export names
- Severity: How many duplicates impact?

---

### **MODE 8: Scene Validation**
**File:** `godot_auditor/modes/scene_validator.py`  
**What it does:** Validate `.tscn` file integrity. Check node references, exported properties, scene dependencies.

**Use case:** Catch corrupted scenes before shipping. Verify scene graph integrity.

**Output:**
- Broken node references
- Missing exported properties
- Circular scene dependencies
- Invalid node types

---

### **MODE 9: Dead Scripts & Zombies**
**File:** `godot_auditor/modes/deadcode.py`  
**What it does:** Find dead code — unused functions, unreferenced scripts, zombie nodes.

**Use case:** Clean before shipping. Remove dead weight. Reduce binary size.

**Output:**
- Unused functions (no callers)
- Orphaned scripts (never instantiated)
- Zombie nodes (in scenes but unused)
- Estimated lines of dead code

---

### **MODE 10: Complexity Analysis**
**File:** `godot_auditor/modes/complexity.py`  
**What it does:** Measure code complexity — cyclomatic complexity, coupling, god objects, refactoring candidates.

**Use case:** Find refactoring hotspots. Identify overly complex functions.

**Output:**
- Cyclomatic complexity (CC) per function
- Coupling metrics (fanin/fanout)
- God objects (high-responsibility classes)
- Refactoring priority ranking

---

### **MODE 11: Compare Snapshots**
**File:** `godot_auditor/modes/delta.py`  
**What it does:** Diff two audit snapshots. Show what changed between two points in time.

**Use case:** "Did this refactor break anything?" Compare before/after.

**Output:**
- Functions added/removed
- Complexity delta (increased/decreased)
- Dependencies changed
- Signal modifications

---

### **MODE 12: Execution Tracer**
**File:** `godot_auditor/modes/spaghetti.py`  
**What it does:** Trace function call chains. Map how execution flows. Detect dependency cycles.

**Use case:** Understand call graph. Find circular dependencies. Debug mysterious execution flow.

**Output:**
- Call chain: `A → B → C → D`
- Cycle detection
- Deepest call chain (complexity measurement)
- All entry points

---

### **MODE 13: Export Analysis Snapshot**
**File:** `godot_auditor/modes/ai_context.py`  
**What it does:** Save all analysis results to JSON/Markdown file. For archival or sharing.

**Use case:** Build audit trail. Share results with team. Export for reporting.

**Output:**
- `.json` file (structured data)
- `.md` file (human readable)
- Timestamp
- All mode results combined

---

### **MODE 14: Settings**
**File:** `godot_auditor/submenus.py`  
**What it does:** Configure CLI behavior. Manage workspace, exclusions, notifications, watcher settings.

**Submenu options:**
- **1. Change workspace path** — Update where config/logs/audits live
- **2. Manage exclusions** — Add/remove paths to ignore during analysis
- **3. Toggle notifications** — Enable/disable desktop alerts
- **4. Watcher settings** — Debounce ms, severity threshold, alert level
- **5. View current config** — Display active settings
- **E. Back** — Return to main menu

---

## Special Hotkeys

| Key | Action |
|-----|--------|
| **W** | Jump directly to Watcher submenu |
| **E** | Exit CLI (or Ctrl+C) |

---

## External Launchers

Three standalone launchers available outside the CLI:

### 1. **KickStart.py**
- Ollama Aider Executor v2
- Pre-loads project context into aider
- Auto-creates venv, installs dependencies
- Interactive model selection menu

### 2. **ollama_aider_executor.py**
- Similar to KickStart
- Direct aider integration with model tiers
- Venv auto-setup

### 3. **RunBridge/watcher.py**
- File system watcher
- Triggers audits on `.gd` / `.tscn` changes
- Standalone file monitor (outside CLI)

---

## Output Format

**By default:** JSON (structured, parseable)  
**Interactive mode:** Pretty-printed (human readable)  
**Export:** Markdown + JSON options

---

## Workflow Examples

### "Find dead code before shipping"
```
Menu → 9 (Dead scripts) → Review results → 4 (Final checklist) → Ship
```

### "Understand signal architecture"
```
Menu → 6 (Signal map) → Review orphans/typos → 1 (Architecture) → Fix issues
```

### "Feed to AI for analysis"
```
Menu → 5 (AI context export) → Copy output to Claude/ChatGPT → Paste LLM response back
```

### "Compare before/after refactor"
```
Menu → 13 (Export snapshot) [before] → Refactor → 13 (Export snapshot) [after] → 11 (Compare) → Review delta
```

---

## Configuration File

**Location:** `{workspace}/config/auditor_config.json`

**Keys:**
- `watcher` — Live monitoring settings
- `notifications` — Alert configuration
- `exclude` — Paths to ignore
- `monolith_threshold` — Size limit for god object detection

**User Editable:** Yes (via Settings menu option 1-5)

---

## Exit Codes

| Code | Meaning |
|------|---------|
| **0** | Success |
| **1** | Error (onboarding failure, setup issue) |
| **Ctrl+C** | Manual exit |

---

**Questions?** See README.md for installation and quick start.
