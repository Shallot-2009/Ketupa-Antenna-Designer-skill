# Ketupa Antenna Designer Skill 1.0.0 — English Guide

Ketupa Antenna Designer is an offline-first Skill for interpreting Chinese, English, or mixed antenna requirements and generating auditable Ansys HFSS starting models.

Author: hongbo.li  
Email: asenjoaupa@gmail.com  
       3405802009@qq.com

## Contents

1. [Capabilities and validation boundary](#1-capabilities-and-validation-boundary)
2. [Package layout](#2-package-layout)
3. [Direct Windows use](#3-direct-windows-use)
4. [Install for Codex](#4-install-for-codex)
5. [Install for Claude Code](#5-install-for-claude-code)
6. [Fully offline use](#6-fully-offline-use)
7. [Run HFSS and review results](#7-run-hfss-and-review-results)
8. [Local HTTP API](#8-local-http-api)
9. [Compatibility](#9-compatibility)
10. [Upgrade, verify, and uninstall](#10-upgrade-verify-and-uninstall)
11. [Troubleshooting](#11-troubleshooting)

## 1. Capabilities and validation boundary

The offline catalog contains 38 stable family/variant keys covering rectangular, square, circular, and elliptical patches; dipoles; monopoles; horns; waveguides; helices; spirals; sinuous antennas; Vivaldi; log-periodic; PIFA; bowtie; bicone/discone; and slot antennas.

Support is divided into three tiers:

- `verified`: rectangular microstrip patch with probe, inset, or edge feed. Generates VBS, native AEDT COM Python, and PyAEDT packages with port checks, S11, realized gain, radiation plots, and Touchstone export.
- `legacy_synthesized`: preserves the exact legacy HFSS VBS geometry contract and adds analytical or wavelength-scaled starting dimensions.
- `template_parameterized`: preserves a complex VBS argument contract with auditable prompt, explicit, and default values.

Only the rectangular microstrip patch is fully synthesis-and-solve verified. Every other family is a parameterized engineering starting model and requires HFSS review of geometry, ports, materials, mesh, convergence, S11, efficiency, gain, and radiation pattern.

The engine rejects ambiguous requests instead of silently replacing them with a rectangular patch. For example, `elliptical` alone is ambiguous; `5.8 GHz elliptical patch antenna` maps to `elliptical_patch`.

## 2. Package layout

```text
Ketupa-Antenna-Designer-skill/
├─ SKILL.md                         Agent workflow
├─ README.md                       Documentation entry point
├─ README_CN.md                    Chinese guide
├─ README_EN.md                    English guide
├─ agents/openai.yaml              Codex UI metadata
├─ bin/windows/ketupa-antenna.exe  Windows black-box engine
├─ bin/linux/README.md             Linux compatibility note
├─ scripts/                        Install, uninstall, and launch wrappers
└─ references/                     API, catalog, engineering, and validation records
```

The distributable contains no implementation source and does not execute or ship the legacy `HFSS_ADK.exe`.

## 3. Direct Windows use

No installation is required:

```powershell
$SkillRoot = "G:\FF_AI_Agent\SIExpert\Ketupa\IDE\Ketupa_skills\Ketupa-Antenna-Designer-skill"

& "$SkillRoot\bin\windows\ketupa-antenna.exe" --version
& "$SkillRoot\bin\windows\ketupa-antenna.exe" families
```

You may also use the wrapper:

```powershell
& "$SkillRoot\scripts\ketupa-antenna.ps1" families
```

The expected version is:

```text
ketupa-antenna 1.0.0
```

The `families` response must report `count: 38`.

## 4. Install for Codex

### 4.1 User-level installation

```powershell
$SkillRoot = "G:\FF_AI_Agent\SIExpert\Ketupa\IDE\Ketupa_skills\Ketupa-Antenna-Designer-skill"
& "$SkillRoot\scripts\install.ps1" -Target CodexUser -Force
```

Verify the installed copy:

```powershell
$InstalledSkill = "$env:USERPROFILE\.codex\skills\ketupa-antenna-designer"

& "$InstalledSkill\bin\windows\ketupa-antenna.exe" --version
& "$InstalledSkill\bin\windows\ketupa-antenna.exe" families
```

The preferred installation location is:

```text
%CODEX_HOME%\skills\ketupa-antenna-designer
```

If `CODEX_HOME` is not set, the location is:

```text
%USERPROFILE%\.codex\skills\ketupa-antenna-designer
```

### 4.2 Project-level installation

```powershell
& "$SkillRoot\scripts\install.ps1" `
  -Target CodexProject `
  -ProjectRoot "D:\MyProject"
```

The project-level location is:

```text
D:\MyProject\.agents\skills\ketupa-antenna-designer
```

Open a new Codex task after installation. Example invocation:

```text
Use $ketupa-antenna-designer to interpret this request offline first,
then generate the exact family without falling back to a rectangle:
Generate a 5.8 GHz elliptical patch antenna with relative permittivity 3.2,
substrate thickness 0.8 mm, and coaxial probe feed.
```

Codex should run `interpret`, inspect `ready_for_design`, and only then run `design`.

## 5. Install for Claude Code

### 5.1 User-level installation

```powershell
& "$SkillRoot\scripts\install.ps1" -Target ClaudeUser -Force
```

Installation location:

```text
%USERPROFILE%\.claude\skills\ketupa-antenna-designer
```

Install both the Codex and Claude Code user copies:

```powershell
& "$SkillRoot\scripts\install.ps1" -Target AllUser -Force
```

### 5.2 Project-level installation

```powershell
& "$SkillRoot\scripts\install.ps1" `
  -Target ClaudeProject `
  -ProjectRoot "D:\MyProject"
```

The project-level location is:

```text
D:\MyProject\.claude\skills\ketupa-antenna-designer
```

Open a new Claude Code session and explicitly request the `ketupa-antenna-designer` Skill. Require it to interpret the exact family and parameters before generation, and never skip `ready_for_design`, `conflicts`, or `missing_parameters`.

## 6. Fully offline use

The following commands use only the local black-box engine. They need no Python, network connection, API key, or language model.

### 6.1 Interpret without generating

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" interpret `
  --prompt "Design a right-handed 2.4 GHz axial-mode helix, 5 turns, helix diameter 40 mm"
```

Inspect `antenna_type`, `variant`, `synthesis_tier`, `parameters`, `parameter_sources`, `evidence`, `conflicts`, `missing_parameters`, and `ready_for_design`. Generate only when `ready_for_design` is true.

### 6.2 Elliptical patch

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" design `
  --prompt "Design a 5.8 GHz elliptical patch, er=3.2, h=0.8 mm, probe fed" `
  --output "C:\AntennaWork\elliptical_patch_5p8"
```

This request maps to `elliptical_patch` and generates `CreateEllipse` geometry. It does not fall back to a rectangular patch.

### 6.3 Axial-mode helix

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" design `
  --prompt "Design a right-handed 2.4 GHz axial-mode helix, 5 turns, helix diameter 40 mm" `
  --output "C:\AntennaWork\helix_2p4"
```

### 6.4 Verified rectangular patch

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" design `
  --prompt "2.4 GHz WiFi rectangular patch, er=3, h=1 mm, inset feed" `
  --output "C:\AntennaWork\verified_patch_2p4"
```

### 6.5 Explicit family and parameters

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" design `
  --antenna-type axial_helix `
  --frequency-ghz 2.4 `
  --parameter N=6 `
  --parameter helixD=38 `
  --parameter direction=Left `
  --output "C:\AntennaWork\explicit_helix"
```

`--parameter` is repeatable. Every override is recorded as `explicit` in `parameter_sources`.

### 6.6 Output layout

Verified rectangular patch:

```text
design.json
summary.md
vbs/build_model.vbs
aedt_com/build_model_aedt.py
pyaedt/build_model_pyaedt.py
```

Other catalog families:

```text
design.json
model_contract.json
summary.md
legacy_vbs/build_model.vbs
legacy_vbs/run_model.cmd
legacy_vbs/run_model.ps1
hfss_project/
results/
```

`model_contract.json` records the exact `args(0)...args(n)` order, value, and source.

## 7. Run HFSS and review results

Verified rectangular patch:

```powershell
Set-Location "C:\AntennaWork\verified_patch_2p4\vbs"
.\run_model.ps1
```

Other catalog families:

```powershell
Set-Location "C:\AntennaWork\elliptical_patch_5p8\legacy_vbs"
.\run_model.cmd
```

Ansys Electronics Desktop and a valid license are required. Generated VBS checks the AEDT excitation list and writes `model_failed.txt` when no port exists or project saving fails.

After a full verified-patch solve, require an AEDT project, `S11.s1p`, S11 data/image, realized-gain image, radiation-pattern data/image, and a non-empty port list.

Analyze Touchstone output:

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" analyze-sparams `
  "C:\AntennaWork\verified_patch_2p4\results\S11.s1p" `
  --target-frequency-ghz 2.4
```

## 8. Local HTTP API

Start on a Windows node:

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" serve `
  --host 127.0.0.1 `
  --port 8765 `
  --output-root "C:\AntennaWork\api"
```

Routes:

```text
GET  /health
GET  /v1/capabilities
POST /v1/interpret
POST /v1/design
POST /v1/analyze
POST /v1/learn
```

Local example:

```powershell
$body = @{prompt='Design a 10 GHz pyramidal horn antenna'} | ConvertTo-Json
Invoke-RestMethod "http://127.0.0.1:8765/v1/interpret" `
  -Method Post `
  -ContentType "application/json; charset=utf-8" `
  -Body $body
```

The built-in server has no TLS or authentication. Bind it to `127.0.0.1`; do not expose it directly to the public Internet.

## 9. Compatibility

### Windows

- Architecture: x64
- API baseline: Windows 10 / Windows Server 2016 or newer
- Shell: Windows PowerShell 5.1 or PowerShell 7
- Target Python: not required
- CLI/file JSON: ASCII-safe Unicode escapes for PowerShell 5.1 compatibility
- HTTP JSON: UTF-8

This is a compatibility baseline, not proof of real AEDT execution on every Windows/AEDT/license combination. Accept the package on each target engineering host.

### Linux/macOS

This distribution has no native Linux/macOS black-box engine. Install the Skill metadata and call the HTTP API hosted on a Windows node. Generated PyAEDT scripts may be reviewed on a compatible Linux AEDT/PyAEDT host. Do not rename the Windows `.exe` and present it as a native Linux binary.

## 10. Upgrade, verify, and uninstall

When a destination already exists, `-Force` preserves it as a timestamped backup before installing the new copy:

```powershell
& "$SkillRoot\scripts\install.ps1" -Target CodexUser -Force
```

Verify the engine:

```powershell
Get-FileHash "$SkillRoot\bin\windows\ketupa-antenna.exe" -Algorithm SHA256
& "$SkillRoot\bin\windows\ketupa-antenna.exe" families
```

Engine SHA256 for this release:

```text
5D213315196B705B80DDAF661D9C82B0108492EA742057626C4389204E77EF38
```

Uninstall the Codex user-level copy:

```powershell
& "$SkillRoot\scripts\uninstall.ps1" -Target CodexUser
```

Uninstall the Claude Code user-level copy:

```powershell
& "$SkillRoot\scripts\uninstall.ps1" -Target ClaudeUser
```

The uninstaller removes only the selected installed copy. It does not remove the original Skill folder or timestamped backups.

## 11. Troubleshooting

### Elliptical input produces a rectangle

Run `families`. If the command is unavailable or `count` is not `38`, an older engine is being used. Reinstall with `install.ps1 -Force`, then open a new Codex or Claude Code session.

### `elliptical` alone is rejected

This is intentional. The phrase could mean an elliptical patch or an elliptical horn. Specify the complete family, for example `5.8 GHz elliptical patch antenna` or `10 GHz elliptical horn antenna`. The engine does not silently substitute a rectangle.

### `ready_for_design=false`

Read `missing_parameters` and `conflicts`, supply the missing family/frequency, or resolve mutually exclusive parameters, then run `interpret` again.

### HFSS does not save a project

Check AEDT installation, licensing, script permissions, and `results/model_failed.txt`. A missing port or failed project save is a hard failure.

Additional references:

- `references/ANTENNA_CATALOG.md`
- `references/PROMPT_INTERPRETER.md`
- `references/API.md`
- `references/ENGINEERING.md`
