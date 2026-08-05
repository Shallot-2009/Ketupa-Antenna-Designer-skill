# Ketupa Antenna Designer Skill 1.0.0

这是可直接分发的黑盒 Skill 发布版。核心算法已编译到 Windows EXE，目录中不包含 Python 实现源码。

> **发布模式说明：** 本仓库公开提供 Skill 元数据、包装/安装脚本、文档和 Windows 二进制发行版。仓库内由项目作者创作并拥有权利的内容按 BSD 2-Clause 许可分发；核心算法源码未包含，因此核心引擎属于 binary-only 发行，不应将本仓库描述为“核心实现完整开源”。

本次 1.0.0 发布已经修复并验证：端口不会静默丢失；模型使用 HFSS Local Variables 参数化；Agent 计算值作为默认参数；仿真后自动生成 S11、Realized Gain、方向图，并导出 `S11.s1p`；VBS、AEDT COM Python 和 PyAEDT 三种脚本均具备可执行入口与失败检查。

## 最快开始

```powershell
cd "C:\Tools\Ketupa-Antenna-Designer-skill"

.\bin\windows\ketupa-antenna.exe --version

.\bin\windows\ketupa-antenna.exe design `
  --prompt "生成一个 2.4 GHz WiFi 矩形贴片天线，介电常数 3，基板厚度 1 mm，同轴探针馈电，尺寸紧凑" `
  --output "C:\AntennaWork\wifi_2p4"
```

## 离线直接运行

Windows 黑盒 EXE 可以完全离线运行尺寸综合、参数化脚本生成和 S 参数分析，不需要安装 Python，也不会访问网络。只有真正启动生成的 HFSS 脚本并求解时，才需要本机已经安装可用的 AEDT/HFSS 和许可证。

进入本 Skill 的根目录后执行：

```powershell
cd "C:\Tools\Ketupa-Antenna-Designer-skill"

.\bin\windows\ketupa-antenna.exe design --help
```

也可以使用包装脚本：

```powershell
.\scripts\ketupa-antenna.ps1 design --help
```

如果已经把 `bin\windows` 加入 `PATH`，命令可以简写为：

```powershell
ketupa-antenna design [参数] --output "输出目录"
```

完整格式：

```text
ketupa-antenna design [-h]
  [--prompt PROMPT]
  [--config CONFIG]
  [--frequency-ghz FREQUENCY_GHZ]
  [--relative-permittivity RELATIVE_PERMITTIVITY]
  [--substrate-height-mm SUBSTRATE_HEIGHT_MM]
  [--loss-tangent LOSS_TANGENT]
  [--feed-type {probe,inset,edge}]
  [--boundary {ABC,PML,FEBI}]
  [--solver {HFSS,HFSS-IE}]
  [--sweep-type {Discrete,Interpolating,Fast}]
  [--project-name PROJECT_NAME]
  [--compact]
  [--calibration-database CALIBRATION_DATABASE]
  [--no-calibration]
  [--llm-base-url LLM_BASE_URL]
  [--llm-model LLM_MODEL]
  [--llm-api-key LLM_API_KEY]
  [--llm-timeout LLM_TIMEOUT]
  --output OUTPUT
```

### 命令各部分含义

| 命令部分 | 是否必需 | 含义 |
|---|---:|---|
| `ketupa-antenna` | 是 | 主程序。未加入 `PATH` 时使用 `.\bin\windows\ketupa-antenna.exe`。 |
| `design` | 是 | 执行矩形微带贴片天线综合，并生成 VBS、AEDT COM Python 和 PyAEDT 三种脚本。 |
| `-h` / `--help` | 否 | 显示当前命令帮助，不生成模型。 |
| `--prompt` | 否 | 中文或英文自然语言需求，例如频率、介电常数、板厚和馈电方式。完全离线时由内置解析器处理。 |
| `--config` | 否 | 从 UTF-8 JSON 文件读取设计参数，适合保存固定模板或自动化批处理。 |
| `--frequency-ghz` | 否 | 目标中心频率，单位 GHz，例如 `2.4`、`5.8`。显式值会覆盖自然语言中的频率。 |
| `--relative-permittivity` | 否 | 基板相对介电常数 Dk/Er，例如 `3.0`、`3.48`、`4.4`。 |
| `--substrate-height-mm` | 否 | 基板厚度，单位 mm，例如 `1.0`、`0.8`、`0.508`。 |
| `--loss-tangent` | 否 | 基板损耗角正切 Df，例如 `0.002`、`0.0037`。 |
| `--feed-type probe` | 否 | 同轴探针馈电，生成同轴内外导体和 Terminal 端口。 |
| `--feed-type inset` | 否 | 嵌入式微带馈电，在贴片内形成 inset 槽并使用 lumped port。 |
| `--feed-type edge` | 否 | 边缘微带馈电，包含四分之一波长阻抗变换线。 |
| `--boundary ABC` | 否 | 吸收边界，计算量相对较低，适合初始模型。 |
| `--boundary PML` | 否 | 完美匹配层，通常更严格，但模型和网格成本更高。 |
| `--boundary FEBI` | 否 | 有限元/边界积分组合边界，使用前应确认当前 AEDT 求解环境支持。 |
| `--solver HFSS` | 否 | 标准 HFSS 求解器，默认选择。 |
| `--solver HFSS-IE` | 否 | HFSS Integral Equation 路线，仅在项目确实需要且许可证支持时选择。 |
| `--sweep-type Discrete` | 否 | 离散扫频。每个频点独立求解，适合最终核验和保存场数据。 |
| `--sweep-type Interpolating` | 否 | 插值扫频，通常更快，适合较宽频段的前期分析。 |
| `--sweep-type Fast` | 否 | 快速扫频；可用性和效果取决于 AEDT 版本及模型。 |
| `--project-name` | 否 | 设置生成的 AEDT 工程/设计名称，例如 `WiFi_Patch_2p4G`。 |
| `--compact` | 否 | 使用更紧凑的基板和空气区域起始配置；不代表自动满足整机尺寸限制。 |
| `--calibration-database` | 否 | 指定本地 JSONL 校准数据库。数据库只应保存已收敛且人工确认可信的 HFSS 结果。 |
| `--no-calibration` | 否 | 禁用历史校准，只使用确定性解析公式计算默认尺寸。首次设计或排查问题时推荐使用。 |
| `--llm-base-url` | 否 | OpenAI-compatible 大模型地址。完全离线运行时不要填写。 |
| `--llm-model` | 否 | 配合 `--llm-base-url` 使用的模型名称。离线确定性模式不需要。 |
| `--llm-api-key` | 否 | 大模型接口密钥。不要把真实密钥写进项目或命令历史。 |
| `--llm-timeout` | 否 | 大模型请求超时秒数，只影响启用了大模型的自然语言归一化。 |
| `--output` | 是 | 生成结果保存目录。建议每轮设计使用不同目录，避免覆盖上一轮结果。 |

`--prompt`、`--config` 和显式参数可以组合使用。显式命令行参数优先，用于覆盖自然语言或 JSON 中的对应值。完全离线时不要设置任何 `--llm-*` 参数。

### 离线案例 1：中文自然语言，同轴探针馈电

```powershell
.\bin\windows\ketupa-antenna.exe design `
  --prompt "生成一个 2.4 GHz WiFi 矩形贴片天线，介电常数 3，板厚 1 mm，同轴探针馈电，尺寸紧凑" `
  --no-calibration `
  --output "C:\AntennaWork\wifi_2p4_probe"
```

含义：目标频率为 2.4 GHz，Er=3，基板厚度 1 mm，使用 `probe` 馈电；`--no-calibration` 表示只使用确定性公式，不读取历史经验库。

### 离线案例 2：全部使用明确参数，嵌入式馈电

```powershell
.\bin\windows\ketupa-antenna.exe design `
  --frequency-ghz 5.8 `
  --relative-permittivity 3.48 `
  --substrate-height-mm 0.8 `
  --loss-tangent 0.0037 `
  --feed-type inset `
  --boundary PML `
  --solver HFSS `
  --sweep-type Discrete `
  --project-name "WiFi_5p8G_Inset" `
  --no-calibration `
  --output "C:\AntennaWork\wifi_5p8_inset"
```

含义：不依赖自然语言解析，直接指定 5.8 GHz、材料参数、嵌入馈电、PML 边界和离散扫频，适合可重复的工程自动化。

### 离线案例 3：边缘馈电和紧凑模式

```powershell
.\bin\windows\ketupa-antenna.exe design `
  --frequency-ghz 10 `
  --relative-permittivity 2.2 `
  --substrate-height-mm 0.508 `
  --feed-type edge `
  --boundary ABC `
  --compact `
  --project-name "Patch_10G_Edge" `
  --output "C:\AntennaWork\patch_10g_edge"
```

含义：生成 10 GHz、Er=2.2、0.508 mm 基板的边缘馈电模型，并缩小默认外围区域。此处未指定 `--no-calibration`，程序会使用默认本地校准数据库；数据库为空时仍按确定性结果生成。

### 离线案例 4：使用 JSON 配置文件

创建 `C:\AntennaWork\wifi_config.json`：

```json
{
  "frequency_ghz": 2.45,
  "relative_permittivity": 4.4,
  "substrate_height_mm": 1.6,
  "loss_tangent": 0.018,
  "feed_type": "inset",
  "boundary": "ABC",
  "solver": "HFSS",
  "sweep_type": "Discrete",
  "project_name": "FR4_WiFi_2p45G",
  "compact": false
}
```

运行：

```powershell
.\bin\windows\ketupa-antenna.exe design `
  --config "C:\AntennaWork\wifi_config.json" `
  --no-calibration `
  --output "C:\AntennaWork\fr4_wifi_2p45"
```

JSON 方式适合版本管理、批量设计和由其他软件调用。配置文件本身不包含输出目录，输出位置仍由必需参数 `--output` 指定。

### 输出目录内容

每次 `design` 成功后会生成：

```text
输出目录/
├── design.json                    完整输入、Agent 默认尺寸、Local Variables 和仿真设置
├── summary.md                     可阅读的工程摘要
├── vbs/
│   ├── build_model.vbs            Windows VBS 后端
│   ├── hfss_arguments.json        VBS 参数记录
│   └── run_model.ps1/.cmd         VBS 启动入口
├── aedt_com/
│   ├── build_model_aedt.py        Windows AEDT COM Python 后端
│   └── run_model.ps1/.cmd
└── pyaedt/
    ├── build_model_pyaedt.py      Windows/Linux PyAEDT 后端
    └── run_model.ps1/.cmd/.sh
```

生成脚本在 HFSS 求解前会验证端口。完整仿真成功后，应在相应后端的 `results` 中看到 `S11.s1p`、S11 图、Realized Gain 图和方向图；任一必需结果缺失都会被视为自动化失败。

安装到 Codex 用户级 Skill：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Target CodexUser
```

安装到 Claude Code 用户级 Skill：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Target ClaudeUser
```

同时安装到 Codex 和 Claude Code：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Target AllUser
```

完整安装、Codex/Claude Code、离线、HTTP API、HFSS 后端和故障排查教程见 [references/GUIDE_CN.md](references/GUIDE_CN.md)。

## 许可证、第三方组件与商标

- 项目作者拥有权利的代码、脚本、文档和二进制发行许可见 [LICENSE.txt](LICENSE.txt)（BSD 2-Clause）。
- Windows EXE 使用 CPython/Nuitka 工具链构建；相关运行时和压缩组件的许可证与告知见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) 和 `third_party_licenses/`。
- 本仓库不包含 Ansys Electronics Desktop、HFSS、PyAEDT 或任何 Ansys 二进制文件与许可证。用户必须自行取得合法、兼容的 Ansys 环境。
- Ansys、Ansys Electronics Desktop 和 HFSS 是其各自权利人的商标。本项目是独立项目，与 Ansys, Inc. 不存在隶属、赞助或认可关系。

## 发布目录

```text
Ketupa-Antenna-Designer-skill/
├── SKILL.md
├── README.md
├── VERSION
├── LICENSE.txt
├── THIRD_PARTY_NOTICES.md
├── third_party_licenses/
├── CHECKSUMS.txt
├── agents/openai.yaml
├── bin/
│   ├── windows/ketupa-antenna.exe
│   └── linux/README.md
├── scripts/
│   ├── install.ps1
│   ├── uninstall.ps1
│   ├── install.sh
│   ├── uninstall.sh
│   ├── ketupa-antenna.ps1
│   └── ketupa-antenna.sh
└── references/
    ├── GUIDE_CN.md
    ├── GUIDE_EN.md
    ├── API.md
    ├── ENGINEERING.md
    ├── validation_summary_1000000.json
    └── hfss_validation_20260805.json
```

作者：Asenjo.HB.L  
邮箱：asenjoaupa@gmail.com  
　　　3405802009@qq.com
