---
name: ketupa-antenna-designer
description: Design, validate, generate, solve, analyze, and iteratively refine parameterized Ansys HFSS rectangular microstrip patch antennas from Chinese or English natural-language requirements. Use for WiFi patch dimensions, dielectric/substrate selection, probe/inset/edge feeds, HFSS VBS, native AEDT COM Python, PyAEDT, strict port validation, automatic S11/gain/radiation plots, Touchstone export, resonance correction, offline synthesis, or the local antenna-design HTTP API. The deterministic rectangular-patch engine is verified; do not claim verified synthesis for other antenna families.
---

# Ketupa Antenna Designer 1.0.0

Use the packaged deterministic engine for all dimensions. A language model may clarify or normalize requirements, but must not invent geometry or replace HFSS convergence review.

## Runtime

Resolve `SKILL_ROOT` as the directory containing this `SKILL.md`.

- Windows local engine: `SKILL_ROOT/bin/windows/ketupa-antenna.exe`
- Windows wrapper: `SKILL_ROOT/scripts/ketupa-antenna.ps1`
- Linux/macOS: this package installs the Skill metadata, but the 1.0.0 black-box engine is Windows-native. Use the HTTP API hosted by a Windows machine, or obtain a Linux-native build made on Linux.

Do not search for Python source. The distributable intentionally contains no implementation source.

## Standard workflow

1. Confirm target frequency, relative permittivity, substrate height, feed type and size preference. State assumptions when any item is absent.
2. Run `design` and write to a new output directory.
3. Report the generated dimensions, HFSS Local Variables, and the three backend files. Agent values are defaults; the geometry is parameterized.
4. If the user asks to solve in HFSS, select one backend only after checking AEDT version, license and execution environment:
   - `vbs/build_model.vbs`: Windows AEDT/VBS route.
   - `aedt_com/build_model_aedt.py`: Windows AEDT COM route.
   - `pyaedt/build_model_pyaedt.py`: PyAEDT route on a compatible Windows/Linux AEDT host.
5. Require a non-empty AEDT excitation list before saving or solving. Treat a missing port as a hard failure.
6. After a full solve, require `S11.s1p`, S11 data/image, realized-gain image, and radiation-pattern data/image. Missing output means the automation failed.
7. Run `analyze-sparams` on the exported `.s1p` or CSV.
8. If resonance is shifted, run `refine` into a new directory. Keep the original result for traceability.
9. Use `learn` only for converged, physically credible HFSS results.

## Core commands

```powershell
& "$SKILL_ROOT\bin\windows\ketupa-antenna.exe" --version

& "$SKILL_ROOT\bin\windows\ketupa-antenna.exe" design `
  --prompt "生成一个 2.4 GHz WiFi 矩形贴片天线，介电常数 3，基板厚度 1 mm，同轴探针馈电，尺寸紧凑" `
  --output "C:\AntennaWork\wifi_2p4"

& "$SKILL_ROOT\bin\windows\ketupa-antenna.exe" analyze-sparams `
  "C:\AntennaWork\wifi_2p4\results\S11.s1p" `
  --target-frequency-ghz 2.4

& "$SKILL_ROOT\bin\windows\ketupa-antenna.exe" refine `
  --design-file "C:\AntennaWork\wifi_2p4\design.json" `
  --result-file "C:\AntennaWork\wifi_2p4\results\S11.s1p" `
  --output "C:\AntennaWork\wifi_2p4_r2"

& "$SKILL_ROOT\bin\windows\ketupa-antenna.exe" serve `
  --host 127.0.0.1 --port 8765 `
  --output-root "C:\AntennaWork\api_output"
```

## Engineering limits

- Verified synthesis family: rectangular microstrip patch only.
- Supported feeds: probe, inset and edge.
- Generated geometry is an engineering starting point, not proof of HFSS convergence, manufacturability, regulatory compliance or production readiness.
- Final review must include S11/input impedance, efficiency, realized gain, radiation pattern, port validity, material dispersion, finite ground, conductor loss/roughness and manufacturing tolerance.
- Prefer a final discrete sweep for signoff. Never learn from a wrong mode, unconverged sweep or non-antenna resonance.
- Version 1.0.0 was exercised on Windows AEDT 2026.1 for VBS probe/inset, AEDT COM Python probe/inset, and PyAEDT probe/edge. Read `references/ENGINEERING.md` for the exact validation boundary.

Read `references/GUIDE_CN.md` for installation and complete usage, `references/API.md` for HTTP integration, and `references/ENGINEERING.md` for validation scope and accuracy boundaries.
