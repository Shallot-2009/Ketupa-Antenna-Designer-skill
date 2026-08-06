# Ketupa Antenna Designer Skill 1.0.0

Offline-first natural-language antenna recognition and Ansys HFSS starting-model generation.

- [中文说明](README_CN.md)
- [English guide](README_EN.md)
- [Antenna catalog](references/ANTENNA_CATALOG.md)
- [HTTP API](references/API.md)
- [Engineering and validation boundary](references/ENGINEERING.md)

Author: hongbo.li  
Email: asenjoaupa@gmail.com  
       3405802009@qq.com

## Quick verification on Windows

```powershell
$SkillRoot = (Resolve-Path .).Path
& "$SkillRoot\bin\windows\ketupa-antenna.exe" --version
& "$SkillRoot\bin\windows\ketupa-antenna.exe" families
```

The expected version is `ketupa-antenna 1.0.0`, and the catalog `count` is `38`.
The engine runs offline and does not require Python or a cloud model.

## Support boundary

| Tier | Scope |
|---|---|
| `verified` | Rectangular microstrip patch with VBS, AEDT COM Python, and PyAEDT backends |
| `legacy_synthesized` | Exact legacy VBS contract plus analytical starting dimensions |
| `template_parameterized` | Exact complex VBS contract with auditable prompt/default parameters |

Only the rectangular microstrip patch is fully synthesis-and-solve verified. Other families are parameterized engineering starting models and require HFSS geometry, port, convergence, S11, efficiency, gain, and pattern review.

The Windows black-box executable targets x64 Windows 10 / Windows Server 2016 or newer. Linux installs may use the Skill metadata and a Windows-hosted local HTTP API; this package does not contain a native Linux engine.
