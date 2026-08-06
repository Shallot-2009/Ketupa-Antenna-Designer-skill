---
name: ketupa-antenna-designer
description: Interpret Chinese, English, or mixed natural-language antenna requirements offline; classify patch, dipole, monopole, horn, waveguide, helix, spiral, sinuous, Vivaldi/tapered-slot, log-periodic, PIFA, bowtie, bicone/discone, and slot variants; bind dimensions to exact HFSS VBS parameter contracts; and generate auditable Ansys HFSS starting models. Use for offline antenna family/shape recognition, prompt-to-parameter conversion, rectangular-patch VBS/AEDT COM/PyAEDT generation, legacy analytical VBS packages, strict port checks, S11/gain/radiation plots, Touchstone export, result analysis, refinement, or the local HTTP API. Only rectangular microstrip patches are fully synthesis-and-solve verified; label every other family as a legacy analytical starting model.
---

# Ketupa Antenna Designer 1.0.0

Use the packaged deterministic engine. Do not replace the requested family with a rectangular patch and do not describe an analytical starting model as converged or optimized.

## Runtime

Resolve `SKILL_ROOT` as the directory containing this file.

- Windows engine: `SKILL_ROOT/bin/windows/ketupa-antenna.exe`
- Windows wrapper: `SKILL_ROOT/scripts/ketupa-antenna.ps1`
- Linux/macOS: use the HTTP API hosted by a Windows node, or a Linux-native build produced on Linux.

The Windows engine performs classification, synthesis, generation, result analysis, and HTTP serving offline. It does not require Python or a cloud model.

## Required workflow

1. Run `families` when the requested family or variant is unclear.
2. Run `interpret --prompt <request>` before generation.
3. Inspect `antenna_type`, `variant`, `synthesis_tier`, `parameters`, `parameter_sources`, `evidence`, `conflicts`, `missing_parameters`, `warnings`, and `ready_for_design`.
4. Stop and ask for clarification when `ready_for_design` is false. Never silently choose a different family.
5. Run `design` with the same prompt and a new output directory.
6. Branch on `synthesis_tier`:
   - `verified`: use the existing rectangular-patch package containing VBS, AEDT COM Python, and PyAEDT.
   - `legacy_synthesized` or `template_parameterized`: use `legacy_vbs/run_model.cmd`; state that dimensions are an analytical starting point.
7. Require a non-empty AEDT excitation list. A missing port is a hard failure.
8. For a verified rectangular patch, require `S11.s1p`, S11 data/image, realized-gain image, and radiation-pattern data/image after the solve.
9. For another family, inspect geometry and port orientation, converge it in HFSS, and create reports before accepting performance.
10. Use `analyze-sparams`, `refine`, and `learn` only with physically credible, converged results.

## Offline commands

```powershell
& "$SKILL_ROOT\bin\windows\ketupa-antenna.exe" families

& "$SKILL_ROOT\bin\windows\ketupa-antenna.exe" interpret `
  --prompt "生成一个2.4 GHz右旋轴向模螺旋天线，5圈，螺旋直径40毫米"

& "$SKILL_ROOT\bin\windows\ketupa-antenna.exe" design `
  --prompt "生成一个2.4 GHz右旋轴向模螺旋天线，5圈，螺旋直径40毫米" `
  --output "C:\AntennaWork\helix_2p4"

& "$SKILL_ROOT\bin\windows\ketupa-antenna.exe" design `
  --prompt "生成一个5.8 GHz圆形贴片天线，介电常数3.2，板厚0.8毫米，同轴探针馈电" `
  --output "C:\AntennaWork\circular_patch_5p8"

& "$SKILL_ROOT\bin\windows\ketupa-antenna.exe" design `
  --prompt "生成一个2.4 GHz WiFi矩形贴片天线，介电常数3，板厚1毫米，嵌入馈电" `
  --output "C:\AntennaWork\verified_patch_2p4"
```

Use `--antenna-type <catalog-key>` to force a known variant. Use repeatable `--parameter NAME=VALUE` only for explicit user overrides. Record and disclose every override.

## Interpretation rules

- Require one recognized antenna family and one unambiguous target frequency.
- Prefer the most specific phrase: for example, `elliptical horn` over `horn`, `bowtie slot` over `slot`, and `rectangular waveguide` over `rectangular patch`.
- Convert GHz/MHz/kHz/Hz and mm/mil/um/cm/m/in to normalized GHz/mm values.
- Treat an unqualified antenna `厚度`/`thickness` as substrate height, normalize it to millimetres, and require every generated patch VBS `subH` variable to use `subH & units`.
- Recognize Chinese and English dimensions, dielectric data, feed, boundary, solver, arm/turn counts, handedness, and continuous/stepped geometry.
- Require `=` or `:` for one-letter VBS symbols such as `a` and `b`; never parse the English article “a” as a dimension.
- Treat conflicting values or families as blockers.
- Mark formula-derived values as `legacy_analytical_default`, wavelength-scaled values as `wavelength_scaled_default`, and user values as `prompt` or `explicit`.
- Treat evidence and exact VBS argument order as authoritative. An optional LLM may clarify wording but may not invent or reorder parameters.

## Engineering boundary

- Fully verified family: rectangular microstrip patch with probe, inset, or edge feed.
- Catalog families: offline recognition and exact legacy VBS parameter binding are regression-tested; their RF performance and current-AEDT geometry are not all solver-verified.
- Every legacy package adds a strict excitation check and saves the AEDT project, while preserving the source geometry contract.
- Review material dispersion, conductor loss/roughness, boundary distance, port integration, mesh convergence, S11/input impedance, efficiency, realized gain, radiation pattern, and tolerance.
- Do not learn from an unconverged sweep, a wrong mode, a missing port, or a non-antenna resonance.

Read `README_CN.md` or `README_EN.md` for installation and complete usage, `references/ANTENNA_CATALOG.md` for family keys and tiers, `references/PROMPT_INTERPRETER.md` for the JSON contract, `references/API.md` for HTTP integration, and `references/ENGINEERING.md` for validation limits.
