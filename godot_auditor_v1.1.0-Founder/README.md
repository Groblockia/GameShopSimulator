# ==============================================================================
# COPYRIGHT (C) 2026 ROUNDUP STUDIO. ALL RIGHTS RESERVED.
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL.
# UNAUTHORIZED COPYING, REVERSE ENGINEERING, OR DISTRIBUTION IS STRICTLY 
# PROHIBITED UNDER THE GODOT AUDITOR END USER LICENSE AGREEMENT (EULA).
# ==============================================================================

# Godot Auditor CLI

Complete Godot project analysis tool with 14 audit modes and live file monitoring.

**License key required on first run** (XXXX-XXXX-XXXX format).  
Validates once online via secure endpoint, then works fully offline (AES-256 protected cache).

## Quick Start

### From Command Line

```bash
python auditor.py

# Enter license key when prompted (XXXX-XXXX-XXXX)
# Select audit mode from menu (1-14)
# Results saved to workspace/audits/
```

## 14 Analysis Modes

**Interactive Menu Interface**
```
python auditor.py
```

**Direct Mode Selection (1-14)**

1. **Architecture Analysis** - Project structure and dependencies
2. **Function Index (Beast)** - List all functions across project  
3. **Single File Audit** - Deep dive into one .gd file
4. **Final Audit** - Pre-release checklist
5. **AI Context Export** - Generate AI ground-truth for Aider
6. **Signal Analysis** - Trace signal definitions and connections
7. **Duplicate Detection** - Locate duplicate code/files
8. **Scene Validation** - Validate .tscn file integrity
9. **Dead Code Detection** - Find unused functions and variables
10. **Complexity Analysis** - Analyze code complexity and coupling
11. **Delta Analysis** - Compare two audit snapshots
12. **Spaghetti Detection** - Find tangled dependencies
13. **Export Snapshot** - Export analysis snapshot
14. **Settings** - Configure workspace, exclusions, notifications

**Watcher Mode (0)**
- Live file monitoring with entropy scoring
- Real-time change detection
- Configurable alert levels

## License Validation

**First Run:**
1. Enter license key when prompted (XXXX-XXXX-XXXX format)
2. Key validated online via secure endpoint
3. Validated key cached locally with 30-day expiry
4. Subsequent runs use cached key (offline)

**Key Management:**
- Cached keys automatically validated
- Invalid/expired keys prompt for new entry
- 3 attempts allowed for manual entry
- Failed validation blocks CLI access

## Configuration

Create `auditor_config.json` in your workspace:

```json
{
  "exclude": [
    "*.bak",
    ".backups/",
    "addons/"
  ],
  "monolith_threshold": 500,
  "notifications": {
    "enabled": true,
    "alert_levels": {
      "info": true,
      "warn": true,
      "error": true,
      "suspicious": true
    }
  }
}
```

## Output

Results saved as markdown files in `workspace/audits/`:
- `ARCHITECTURE_YYYY-MM-DD_HHMM.md`
- `BEAST_INDEX_YYYY-MM-DD_HHMM.md`
- `SINGLE_FILE_filename_YYYY-MM-DD_HHMM.md`
- etc.

**File Analysis Features:**
- Status classification (SMALL/MEDIUM/LARGE/CORE/CRITICAL)
- Risk scoring based on LOC and complexity
- Function, signal, and export listings
- Dependency tracking
- VS Code integration with clickable links

## Requirements

- Python 3.8+
- Windows, macOS, or Linux
- Godot project (project.godot file)

## Usage Examples

### Basic Usage
```bash
# Start interactive CLI
python auditor.py

# Select mode 1: Architecture Analysis
1

# Select mode 3: Single File Audit
3
# Enter file path: Scripts/Player.gd
```

### Watcher Mode
```bash
# Start interactive CLI
python auditor.py

# Select mode 0: Watcher
0
# Configure monitoring settings
```

### Settings
```bash
# Start interactive CLI
python auditor.py

# Select mode 14: Settings
14
# Configure workspace, exclusions, notifications
```

## Project Structure

```
GodotAuditor/
├── auditor.py              # Main CLI entry point
├── godot_auditor/
│   ├── cli.py             # Interactive menu system
│   ├── license.py         # License validation (GATEWAY_SECRET)
│   ├── onboarding.py      # First-run setup
│   ├── config.py          # Configuration management
│   ├── modes/             # Analysis mode implementations
│   │   ├── architecture.py
│   │   ├── beast.py
│   │   ├── single_audit.py
│   │   ├── final_audit.py
│   │   ├── ai_context.py
│   │   ├── signals.py
│   │   ├── duplicates.py
│   │   ├── scene_validator.py
│   │   ├── deadcode.py
│   │   ├── complexity.py
│   │   ├── delta.py
│   │   ├── spaghetti.py
│   │   └── watcher.py
│   └── submenus.py        # Signal, duplicate, complexity submenus
└── README.md              # This file
```

## Workspace Structure

```
~/.godot_auditor_workspace    # Workspace pointer
~/.godotaudit/               # License cache
workspace/
├── config/
│   └── auditor_config.json
├── logs/
│   └── watcher.log
└── audits/
    ├── ARCHITECTURE_2026-03-16_1700.md
    ├── BEAST_INDEX_2026-03-16_1701.md
    └── ...
```

## Troubleshooting

**"Cannot find Godot project"**
- Run from your Godot project directory (where project.godot exists)

**"License validation failed"**
- Check key format (XXXX-XXXX-XXXX)
- Verify internet connection for first validation
- Check GATEWAY_SECRET is properly configured

**"No .gd files found"**
- Ensure project has .gd files in root or subdirectories
- Check workspace configuration

## Version

1.0.0-beta

## License

Copyright (c) 2026 RoundUP Studio

See [LICENSE](LICENSE) file for details.
