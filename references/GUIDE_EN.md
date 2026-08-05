# Ketupa Antenna Designer Skill 1.0.0 - Installation and Usage

## Scope

The black-box Windows engine synthesizes verified rectangular microstrip patch starting models from Chinese or English requirements. It generates VBS, native AEDT COM Python, and PyAEDT backends, analyzes Touchstone/HFSS CSV data, and creates resonance-corrected iterations.

Generated geometry uses HFSS Local Variables with agent-computed defaults. Every backend treats an empty excitation list as a hard failure and automatically exports S11, realized gain, radiation patterns, and `S11.s1p` after a successful full solve.

Only rectangular patches with probe, inset, or edge feed have a verified synthesis engine. Generated geometry is not proof of HFSS convergence or manufacturability.

## Direct offline use

```powershell
.\bin\windows\ketupa-antenna.exe --version
.\bin\windows\ketupa-antenna.exe design `
  --prompt "Compact 2.4 GHz rectangular patch, er=3, h=1 mm, probe feed" `
  --output "C:\AntennaWork\wifi_2p4"
```

Python is not required for synthesis, generation, S-parameter analysis, or the HTTP API. AEDT and a valid license are required only when executing a generated HFSS backend.

## Codex

Official locations:

- User: `~/.agents/skills/ketupa-antenna-designer/SKILL.md`
- Project: `<repo>/.agents/skills/ketupa-antenna-designer/SKILL.md`

```powershell
.\scripts\install.ps1 -Target CodexUser
.\scripts\install.ps1 -Target CodexProject -ProjectRoot "D:\YourRepo"
```

Start a new task and request:

```text
Use $ketupa-antenna-designer to create a compact 2.4 GHz rectangular HFSS patch, er=3, h=1 mm, probe feed.
```

Official documentation: <https://learn.chatgpt.com/docs/customization/overview#skills>

## Claude Code

Official locations:

- User: `~/.claude/skills/ketupa-antenna-designer/SKILL.md`
- Project: `<repo>/.claude/skills/ketupa-antenna-designer/SKILL.md`

```powershell
.\scripts\install.ps1 -Target ClaudeUser
.\scripts\install.ps1 -Target ClaudeProject -ProjectRoot "D:\YourRepo"
```

Start a new session and invoke:

```text
/ketupa-antenna-designer Design a 5.8 GHz rectangular patch, er=3.48, h=0.8 mm, inset feed
```

Official documentation: <https://code.claude.com/docs/en/skills>

## HTTP API

```powershell
.\bin\windows\ketupa-antenna.exe serve --host 127.0.0.1 --port 8765 --output-root "C:\AntennaWork\api"
```

```bash
curl http://127.0.0.1:8765/v1/design \
  -H 'Content-Type: application/json' \
  -d '{"prompt":"2.4 GHz rectangular patch, er=3, h=1 mm, probe feed","output_name":"wifi"}'
```

Do not expose the unauthenticated HTTP service directly to the public Internet. See `API.md`.

## Validation

Version 1.0.0 passed 8/8 unit tests and 1,000,000/1,000,000 deterministic analytical/parser/backend regression cases. In addition, real Windows AEDT 2026.1 checks passed for VBS probe/inset, AEDT COM Python probe/inset, and PyAEDT probe/edge. See `validation_summary_1000000.json` and `hfss_validation_20260805.json`; the million-case analytical suite is not a million HFSS solves.

Author: hongbo.li  
Email: asenjoaupa@gmail.com  
       3405802009@qq.com
