# ==============================================================================
# COPYRIGHT (C) 2026 ROUNDUP STUDIO. ALL RIGHTS RESERVED.
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL.
# UNAUTHORIZED COPYING, REVERSE ENGINEERING, OR DISTRIBUTION IS STRICTLY 
# PROHIBITED UNDER THE GODOT AUDITOR END USER LICENSE AGREEMENT (EULA).
# ==============================================================================

# Watcher System Documentation

From source code inspection: `watcher_core.py` + `modes/watcher.py`

---

## Overview

The watcher system detects structural changes in GDScript files (`.gd`) and scene files (`.tscn`) during runtime. It runs as a subprocess spawned by `submenus.py`:

```python
"python", "-m", "godot_auditor.modes.watcher"
```

Runs in background, logs to `watcher.log` (rotated), writes status to `watcher_status.json` (appended).

---

## Architecture

### 1. Core Classes (watcher_core.py)

#### FileMonitor
- **Purpose**: Debounces file change events
- **Key Method**: `is_new_change(path, hash)` — returns True only if hash differs from recorded hash AND debounce window passed
- **Debounce Window**: Configurable (default 800ms from config)
- **File Hashes**: Stored in dictionary keyed by path

#### VelocityTracker
- **Purpose**: Detects rapid multi-file changes (indicator of AI/bulk editing)
- **Window**: Configurable duration in seconds (default 8 seconds)
- **Threshold**: Configurable number of file changes (default 4 changes)
- **Method**: `is_suspicious()` — returns True if threshold exceeded in time window
- **Use**: Triggers "HARAKIRI" alert when velocity exceeds threshold

#### EntropyScorer
- **Purpose**: Assigns integer score to structural changes
- **Scoring System**:
  - Signal removed: +3 points
  - Connection removed: +3 points
  - Exports removed: +2 points
  - Functions removed: +2 points
  - Extends changed (inheritance): +3 points
  - Hash changed (modified): +1 point
  - Signal added + connection removed: +5 points (combined pattern)
  - Autoload added: +1 point
- **Output**: `(int score, list[str] reasons)` — score and list of reason strings

### 2. Snapshot Extraction

**GDScript snapshots** (`.gd` files):
- Signals (regex: `^signal (\w+)`)
- Functions (regex: `^func (\w+)`)
- Exports (regex: `@export var (\w+)`)
- OnReady nodes (regex: `@onready var \w+ = \$(\S+)`)
- Connections (regex: `(\w+)\.connect\(`)
- Emits (regex: `emit_signal\("(\w+)"` or `(\w+)\.emit\(`)
- Extends (regex: `^extends (\w+)`)
- Class name (regex: `^class_name (\w+)`)

**Scene snapshots** (`.tscn` files):
- Nodes (regex: `\[node name="([^"]+)"`)
- Scripts (regex: `path="(res://[^"]+\.gd)"`)
- Scenes (regex: `path="(res://[^"]+\.tscn)"`)
- Connections (extracted as tuples: signal → method)

---

## Alert Levels

The watcher maps integer scores to alert levels:

| Score | Level | Status Severity | Meaning |
|-------|-------|-----------------|---------|
| ≥ 6 | suspicious | HARAKIRI | Threshold of structural collapse |
| 2-5 | error | STRUCTURAL_SHIFT | Breaking changes detected |
| 1 | warn | ANOMALY | Minor change detected |
| 0 | info | RUNNING | No issues |

---

## File Handler Flow (GodotFileHandler)

### On File Modified:

1. **Read file** as UTF-8 (ignore errors)
2. **Extract snapshot** (signals, functions, exports, etc.)
3. **Hash file** (using FileMonitor)
4. **Check debounce** — if duplicate hash within debounce window, ignore
5. **Record change** — update file hash and velocity tracker
6. **Calculate score** — measure structural deltas (old snapshot vs. new)
7. **Determine alert level** using score thresholds
8. **Build readable diff** (e.g., "function_name() removed", "extends Actor → Node3D")
9. **Update status file** — append JSON object with detection details
10. **Log detection** — write to watcher.log
11. **Send notification** — if score ≥ 6 or velocity suspicious, send alert

### Status File Output (watcher_status.json)

Each update appends a JSON object:

```json
{
  "running": true,
  "severity": "RUNNING",
  "events": 4,
  "info": 1,
  "warn": 2,
  "error": 1,
  "suspicious": 0,
  "last_update": "2026-03-13T12:45:30.123456+00:00",
  "file": "[path/to/file.gd](file:///absolute/path/file.gd)",
  "change": "function_name() removed; signal removed",
  "score": 5,
  "reason": "Removed function",
  "timestamp": "2026-03-13T12:45:30.123456+00:00"
}
```

Status values are **cumulative counters** (incremented on each event).

---

## Snapshot Comparison Logic

For each change detected, watcher compares old and new snapshots:

- **Removed signals**: `old_signals - new_signals`
- **Added signals**: `new_signals - old_signals`
- **Removed functions**: `old_funcs - new_funcs`
- **Added functions**: `new_funcs - old_funcs`
- **Extends changed**: `old_extends != new_extends`
- **Removed connections**: `old_connects - new_connects`
- **Removed exports**: `old_exports - new_exports`

Example readable diff output:
```
"extends Player → Node3D; signal my_signal removed; func_name() removed"
```

---

## Velocity Detection (AI Pattern)

**VelocityTracker** flags rapid multi-file changes:

- Window: 8 seconds (default)
- Threshold: 4 changes (default)
- Trigger: When 4+ files modified within 8-second window
- Alert: "HARAKIRI" (most severe)
- Reason: Pattern matches bulk AI generation or automated refactoring

Example flow:
1. File A modified → velocity = 1
2. File B modified → velocity = 2
3. File C modified → velocity = 3
4. File D modified (within 8 sec) → velocity = 4
5. `is_suspicious()` returns true → send HARAKIRI alert
6. 8 seconds pass → velocity window resets

---

## Configuration (config.json)

Watcher reads from `config.json` in workspace:

```json
{
  "debounce_ms": 800,
  "velocity_window_seconds": 8,
  "velocity_threshold": 4
}
```

- `debounce_ms`: Ignore duplicate-hash events within this window (prevents rapid re-triggers from IDE autosave)
- `velocity_window_seconds`: Time window for tracking multi-file changes
- `velocity_threshold`: Number of file changes to trigger velocity alert

---

## Subprocess Lifecycle

### Startup

1. **Main** called with arguments:
   - `--workspace` (project root path)
   - `--log` (path to watcher.log)
   - `--status-file` (path to watcher_status.json)

2. **PID file** written to `watcher_pid` (contains static "9999" for identification)

3. **Observer** started (watchdog library) — monitors workspace recursively

4. **Status** initialized as RUNNING

### During Runtime

- Watches all `.gd` and `.tscn` files
- Ignores files matching ignore patterns (from config)
- On change: score → alert → log → status update → notification

### Shutdown

1. **Signal handler** (SIGTERM/SIGINT) catches termination
2. Observer stops
3. **Status** written with `running: false`, `severity: OFFLINE`
4. **PID file** deleted
5. **Process exits**

---

## Logging

**watcher.log**:
- Format: `TIMESTAMP - watcher_sub - LEVEL - message`
- Levels: INFO, ERROR, WARNING
- Example:
  ```
  2026-03-13 12:45:30,123 - watcher_sub - INFO - [SUSPICIOUS] player.gd  score=6 — Signal removed; Extends changed; Function removed
  2026-03-13 12:45:30,456 - watcher_sub - ERROR - Cannot read /path/to/file.gd: Permission denied
  ```

**Log rotation**: On startup, existing `watcher.log` renamed to `watcher.log.prev` (one backup only)

---

## Notifications

**Notification manager** (`get_notification_manager()` from config):

- **Suspicious notifications**: Sent when score ≥ 6 or velocity exceeds threshold
  - Message: "Wholesale pattern in {filename}"
  - Details: "Score: {score} — {reasons}"

- **Error notifications**: Sent when score > 0 but < 6
  - Message: "Breaking changes in {filename}: {reasons}"
  - Details: File path included

Notification delivery configurable via config (can write to file, Discord webhook, etc.)

---

## Scoring Example

**Scenario**: File `player.gd` modified

Old snapshot:
```
signals: {jump, land, death}
funcs: {_ready, _process, on_jump, on_land}
extends: CharacterBody3D
```

New snapshot:
```
signals: {jump}
funcs: {_ready, _process}
extends: Node3D
```

**Deltas**:
- Signals removed: 2 (land, death) → +3 per signal = +6 points
- Functions removed: 2 (on_jump, on_land) → +2 per function = +4 points
- Extends changed (CharacterBody3D → Node3D) → +3 points
- Hash changed → +1 point

**Total score**: 6 + 4 + 3 + 1 = 14

**Alert**: SUSPICIOUS (≥ 6)

**Readable diff**: "land() removed; death() removed; on_jump() removed; on_land() removed; extends CharacterBody3D → Node3D"

---

## Key Files

| File | Purpose |
|------|---------|
| `godot_auditor/watcher_core.py` | FileMonitor, VelocityTracker, EntropyScorer classes |
| `godot_auditor/modes/watcher.py` | Main subprocess, GodotFileHandler, snapshot extraction |
| `godot_auditor/config.py` | Load config.json (debounce, velocity settings) |
| `godot_auditor/notifications.py` | Notification manager interface |
| `watcher.log` | Runtime log (rotated on restart) |
| `watcher_status.json` | Status updates (appended JSON objects) |

---

## Known Behavior

- **Hash-based debounce**: Prevents duplicate alerts from IDE autosave (same content saved repeatedly)
- **Velocity reset**: Counter resets after time window elapses, not per event
- **Snapshot persistence**: Stored in GodotFileHandler memory during process lifetime
- **On-restart**: Snapshots cleared, baseline re-established from first file change
- **PID static 9999**: ID doesn't reflect actual OS process ID (used for internal identification)
- **Regex patterns**: Extracts signals/funcs from first column (requires proper indentation or `signal`/`func` at line start for GDScript)
