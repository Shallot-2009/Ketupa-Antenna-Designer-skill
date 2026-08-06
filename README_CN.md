# Ketupa Antenna Designer Skill 1.0.0 中文使用说明

Ketupa Antenna Designer 是面向 Ansys HFSS 的离线优先天线设计 Skill。它可以把中文、英文或中英混合自然语言转换为可审计的天线类型、参数和 HFSS 建模文件。

作者：Asenjo.HB.L  

邮箱：asenjoaupa@gmail.com  
　　　3405802009@qq.com

## 目录

1. [能力和验证边界](#1-能力和验证边界)
2. [目录结构](#2-目录结构)
3. [Windows 直接使用](#3-windows-直接使用)
4. [安装到 Codex](#4-安装到-codex)
5. [安装到 Claude Code](#5-安装到-claude-code)
6. [完全离线使用](#6-完全离线使用)
7. [运行 HFSS 与结果检查](#7-运行-hfss-与结果检查)
8. [本地 HTTP API](#8-本地-http-api)
9. [兼容性](#9-兼容性)
10. [升级、校验和卸载](#10-升级校验和卸载)
11. [常见问题](#11-常见问题)

## 1. 能力和验证边界

Skill 包含 38 个稳定的天线类型/变体键，覆盖矩形、方形、圆形和椭圆形贴片、偶极子、单极子、喇叭、波导、螺旋、Spiral、Sinuous、Vivaldi、Log-periodic、PIFA、Bowtie、Bicone/Discone 和 Slot 等模型。

能力分为三级：

- `verified`：矩形微带贴片。支持 probe、inset、edge 馈电；生成 VBS、AEDT COM Python、PyAEDT；包含端口硬检查、S11、Realized Gain、方向图和 Touchstone 导出。
- `legacy_synthesized`：保留原始 HFSS VBS 几何及参数顺序，并提供解析式或波长缩放起始尺寸。
- `template_parameterized`：严格绑定复杂旧 VBS 参数契约，提示词、显式覆盖值和默认值均可追踪。

只有矩形微带贴片是完整的“综合并真实求解验证”流程。其他天线是参数化工程起始模型，必须在 HFSS 中复核几何、端口、材料、网格、收敛、S11、效率、增益和方向图。

程序不会把不明确的天线静默替换为矩形贴片。例如只输入“椭圆形”会被拒绝；输入“5.8 GHz 椭圆形贴片天线”才会匹配 `elliptical_patch`。

## 2. 目录结构

```text
Ketupa-Antenna-Designer-skill/
├─ SKILL.md                         Agent 工作规则
├─ README.md                       文档入口
├─ README_CN.md                    中文说明
├─ README_EN.md                    English guide
├─ agents/openai.yaml              Codex UI 元数据
├─ bin/windows/ketupa-antenna.exe  Windows 黑盒引擎
├─ bin/linux/README.md             Linux 兼容说明
├─ scripts/                        安装、卸载和运行包装器
└─ references/                     API、目录、工程边界和验证记录
```

发行包不包含实现源码，也不会调用旧 `HFSS_ADK.exe`。

## 3. Windows 直接使用

不安装也可以直接运行：

```powershell
$SkillRoot = "G:\FF_AI_Agent\SIExpert\Ketupa\IDE\Ketupa_skills\Ketupa-Antenna-Designer-skill"

& "$SkillRoot\bin\windows\ketupa-antenna.exe" --version
& "$SkillRoot\bin\windows\ketupa-antenna.exe" families
```

也可以使用 PowerShell 包装器：

```powershell
& "$SkillRoot\scripts\ketupa-antenna.ps1" families
```

正确版本应显示：

```text
ketupa-antenna 1.0.0
```

`families` 输出中的 `count` 应为 `38`。

## 4. 安装到 Codex

### 4.1 用户级安装

```powershell
$SkillRoot = "G:\FF_AI_Agent\SIExpert\Ketupa\IDE\Ketupa_skills\Ketupa-Antenna-Designer-skill"
& "$SkillRoot\scripts\install.ps1" -Target CodexUser -Force
```

验证安装：
```powershell
$InstalledSkill = "$env:USERPROFILE\.codex\skills\ketupa-antenna-designer"

& "$InstalledSkill\bin\windows\ketupa-antenna.exe" --version
& "$InstalledSkill\bin\windows\ketupa-antenna.exe" families
```

安装位置优先使用：

```text
%CODEX_HOME%\skills\ketupa-antenna-designer
```

如果未设置 `CODEX_HOME`，使用：

```text
%USERPROFILE%\.codex\skills\ketupa-antenna-designer
```

### 4.2 项目级安装

```powershell
& "$SkillRoot\scripts\install.ps1" `
  -Target CodexProject `
  -ProjectRoot "D:\MyProject"
```

项目级位置为：

```text
D:\MyProject\.agents\skills\ketupa-antenna-designer
```

安装后重新打开 Codex 任务，使 Skill 索引刷新。可在提示词中明确调用：

```text
Use $ketupa-antenna-designer to interpret this request offline first,
then generate the exact antenna family without falling back to a rectangle:
生成一个5.8 GHz椭圆形贴片天线，介电常数3.2，板厚0.8毫米，同轴探针馈电。
```

Codex 应先执行 `interpret`，检查 `ready_for_design`，然后才运行 `design`。

## 5. 安装到 Claude Code

### 5.1 用户级安装

```powershell
& "$SkillRoot\scripts\install.ps1" -Target ClaudeUser -Force
```

安装位置：

```text
%USERPROFILE%\.claude\skills\ketupa-antenna-designer
```
同时安装到 Codex 和 Claude Code：

```
& "$SkillRoot\scripts\install.ps1" -Target AllUser -Force
```



### 5.2 项目级安装

```powershell
& "$SkillRoot\scripts\install.ps1" `
  -Target ClaudeProject `
  -ProjectRoot "D:\MyProject"
```

项目级位置：

```text
D:\MyProject\.claude\skills\ketupa-antenna-designer
```

重新打开 Claude Code 会话，然后明确要求使用 `ketupa-antenna-designer` Skill，并要求先解释类型和参数、再生成模型。不要让模型跳过 `ready_for_design`、`conflicts` 或 `missing_parameters` 检查。

同时安装到 Codex 和 Claude Code 用户目录：

```powershell
& "$SkillRoot\scripts\install.ps1" -Target AllUser
```

## 6. 完全离线使用

以下命令只使用本地黑盒引擎，不需要 Python、网络、API Key 或大模型。

### 6.1 只识别，不生成

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" interpret `
  --prompt "生成一个2.4 GHz右旋轴向模螺旋天线，5圈，螺旋直径40毫米"
```



重点检查：

- `antenna_type` 和 `variant`
- `synthesis_tier`
- `parameters` 和 `parameter_sources`
- `evidence`
- `conflicts` 和 `missing_parameters`
- `ready_for_design`

只有 `ready_for_design=true` 才应生成模型。

### 6.2 椭圆形贴片

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" design `
  --prompt "生成一个5.8 GHz椭圆形贴片天线，介电常数3.2，板厚0.8毫米，同轴探针馈电" `
  --output "C:\AntennaWork\elliptical_patch_5p8"
```

该输入应识别为 `elliptical_patch`，并在 VBS 中创建 `CreateEllipse`，不会退回矩形贴片。

### 6.3 轴向螺旋

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" design `
  --prompt "生成一个2.4 GHz右旋轴向模螺旋天线，5圈，螺旋直径40毫米" `
  --output "C:\AntennaWork\helix_2p4"
```

### 6.4 已验证矩形贴片

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" design `
  --prompt "生成一个2.4 GHz WiFi矩形贴片天线，介电常数3，板厚1毫米，嵌入馈电" `
  --output "C:\AntennaWork\verified_patch_2p4"
```

### 6.5 显式指定类型和参数

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" design `
  --antenna-type axial_helix `
  --frequency-ghz 2.4 `
  --parameter N=6 `
  --parameter helixD=38 `
  --parameter direction=Left `
  --output "C:\AntennaWork\explicit_helix"
```

`--parameter` 可以重复；每个显式值都会在 `parameter_sources` 中记录为 `explicit`。

### 6.6 输出结构

矩形贴片输出：

```text
design.json
summary.md
vbs/build_model.vbs
aedt_com/build_model_aedt.py
pyaedt/build_model_pyaedt.py
```

其他家族输出：

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

`model_contract.json` 按真实 `args(0)...args(n)` 顺序记录参数、值和来源。

## 7. 运行 HFSS 与结果检查

矩形贴片：

```powershell
Set-Location "C:\AntennaWork\verified_patch_2p4\vbs"
.\run_model.ps1
```

其他家族：

```powershell
Set-Location "C:\AntennaWork\elliptical_patch_5p8\legacy_vbs"
.\run_model.cmd
```

运行需要本机 Ansys Electronics Desktop 和有效许可证。生成的 VBS 会检查 AEDT excitation 列表；端口为空时写入 `model_failed.txt` 并停止。

矩形贴片完整求解后应检查：

- AEDT 工程文件
- `S11.s1p`
- S11 数据和图片
- Realized Gain 图片
- 方向图数据和图片
- 非空端口列表

S 参数分析：

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" analyze-sparams `
  "C:\AntennaWork\verified_patch_2p4\results\S11.s1p" `
  --target-frequency-ghz 2.4
```

## 8. 本地 HTTP API

在 Windows 节点启动：

```powershell
& "$SkillRoot\bin\windows\ketupa-antenna.exe" serve `
  --host 127.0.0.1 `
  --port 8765 `
  --output-root "C:\AntennaWork\api"
```

接口：

```text
GET  /health
GET  /v1/capabilities
POST /v1/interpret
POST /v1/design
POST /v1/analyze
POST /v1/learn
```

本地测试：

```powershell
$body = @{prompt='Design a 10 GHz pyramidal horn antenna'} | ConvertTo-Json
Invoke-RestMethod "http://127.0.0.1:8765/v1/interpret" `
  -Method Post `
  -ContentType "application/json; charset=utf-8" `
  -Body $body
```

内置服务没有 TLS 和身份认证。默认只绑定 `127.0.0.1`；不要直接暴露到公网。

## 9. 兼容性

### Windows

- 架构：x64
- API 基线：Windows 10、Windows Server 2016 或更新版本
- PowerShell：Windows PowerShell 5.1 或 PowerShell 7
- 黑盒运行：不需要目标机 Python
- 中文 CLI/文件 JSON：ASCII-safe Unicode 转义，避免 PowerShell 5.1 中文乱码
- HTTP JSON：UTF-8

兼容基线不等于每个系统都完成了真实 AEDT 求解。最终仍需在目标 Windows、AEDT 版本和许可证环境中验收。

### Linux/macOS

本发行包没有原生 Linux/macOS 黑盒引擎。可以安装 Skill 元数据，并调用 Windows 节点上的 HTTP API。生成的 PyAEDT 脚本可以在兼容的 Linux AEDT/PyAEDT 主机上进一步验证，但不能把 Windows `.exe` 重命名后当作 Linux 程序。

## 10. 升级、校验和卸载

如果目标目录已经存在，使用 `-Force` 会先保留带时间戳的备份，再安装新副本：

```powershell
& "$SkillRoot\scripts\install.ps1" -Target CodexUser -Force
```

检查黑盒引擎：

```powershell
Get-FileHash "$SkillRoot\bin\windows\ketupa-antenna.exe" -Algorithm SHA256
& "$SkillRoot\bin\windows\ketupa-antenna.exe" families
```

本发行版引擎 SHA256：

```text
4D94DC00B64DF63AD8884C2A2D9B08149F207F781B404E1BDDD17D3D876FA52D
```

卸载 Codex 用户级副本：

```powershell
& "$SkillRoot\scripts\uninstall.ps1" -Target CodexUser
```

卸载 Claude Code 用户级副本：

```powershell
& "$SkillRoot\scripts\uninstall.ps1" -Target ClaudeUser
```

卸载脚本只删除所选安装目标，不删除原始 Skill 文件夹和自动创建的备份。

## 11. 常见问题

### 输入椭圆形却生成矩形

运行 `families`。如果命令不存在，或者 `count` 不是 `38`，说明实际调用的是旧引擎。使用 `install.ps1 -Force` 更新，然后重新打开 Codex 或 Claude Code 会话。

### 只有“椭圆形”无法生成

这是有意的安全行为。“椭圆形”可能表示椭圆贴片或椭圆喇叭。请写明完整家族，例如“5.8 GHz 椭圆形贴片天线”或“10 GHz 椭圆喇叭天线”。程序不会静默替换成矩形贴片。

### `ready_for_design=false`

检查 `missing_parameters` 和 `conflicts`，补充天线类型、频率或解决互斥参数后重新运行 `interpret`。

### HFSS 没有生成工程

检查 AEDT 安装、许可证、脚本执行权限，以及 `results/model_failed.txt`。端口为空或工程保存失败会被视为硬失败。

更多信息：

- `references/ANTENNA_CATALOG.md`
- `references/PROMPT_INTERPRETER.md`
- `references/API.md`
- `references/ENGINEERING.md`
