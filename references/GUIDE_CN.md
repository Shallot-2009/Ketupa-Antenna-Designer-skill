# Ketupa Antenna Designer Skill 1.0.0 中文教程

## 1. 这个发布包能做什么

本 Skill 将中文或英文天线需求转换为可复现的矩形微带贴片天线初始设计，并生成三种 HFSS 自动化入口：

- VBS：面向 Windows AEDT 的传统脚本入口。
- AEDT COM Python：面向 Windows AEDT COM 自动化。
- PyAEDT：面向已正确安装 AEDT/PyAEDT 的 Windows 或 Linux 主机。

它还可以读取 Touchstone `.s1p` 或 HFSS 导出的 CSV，分析谐振点和 S11，并根据可信仿真结果生成下一轮修正版。

核心综合算法已经编译到 `bin/windows/ketupa-antenna.exe`。最终发布目录没有 Python 实现源码，普通用户无需安装 Python 即可完成离线综合、脚本生成、S 参数分析和 HTTP API 服务。

## 2. 支持范围与必要条件

### 2.1 已验证范围

- 天线类型：矩形微带贴片天线。
- 馈电：同轴探针、嵌入式微带、边缘馈电。
- 输入语言：中文或英文。
- 输出：设计 JSON、设计摘要、VBS、AEDT COM Python、PyAEDT Python。
- 结果反馈：Touchstone `.s1p`、HFSS CSV。

其他天线类型不能因为大模型“会描述”就声称已验证自动综合。

### 2.2 Windows 本地使用

- 建议 Windows 10/11 x64。
- 只做尺寸综合和脚本生成：不需要 Python，不需要启动 HFSS。
- 真正执行 VBS/AEDT COM/PyAEDT 脚本：需要用户自己的合法 Ansys Electronics Desktop/HFSS 环境和许可证。
- 运行 PyAEDT 后端脚本：执行脚本的 Python 环境需要与 AEDT 版本兼容的 `ansys-aedt-core`。

### 2.3 Linux 使用边界

1.0.0 黑盒计算引擎是 Windows 原生 EXE。Nuitka 不支持从 Windows 安全交叉编译出 Linux 原生二进制，因此本包不伪造 Linux 可执行文件。

Linux 有两种可靠用法：

1. 在 Windows 主机启动本地/LAN HTTP API，Linux 通过 HTTP 调用。
2. 在 Linux 原生构建机生成正式 Linux 黑盒二进制后，再替换 `bin/linux` 内容。

由本工具生成的 PyAEDT 脚本可以在兼容的 Linux AEDT/PyAEDT 主机执行。

## 3. 直接离线使用

先验证版本：

```powershell
cd "C:\Tools\Ketupa-Antenna-Designer-skill"
.\bin\windows\ketupa-antenna.exe --version
```

应显示：

```text
ketupa-antenna 1.0.0
```

生成 2.4 GHz WiFi 贴片天线：

```powershell
.\bin\windows\ketupa-antenna.exe design `
  --prompt "生成一个 2.4 GHz WiFi 矩形贴片天线，介电常数 3，基板厚度 1 mm，同轴探针馈电，尺寸紧凑" `
  --output "C:\AntennaWork\wifi_2p4"
```

纯英文也可以：

```powershell
.\bin\windows\ketupa-antenna.exe design `
  --prompt "Design a compact 5.8 GHz rectangular patch, er=3.48, substrate thickness 0.8 mm, inset feed" `
  --output "C:\AntennaWork\wifi_5p8"
```

输出目录包含：

```text
wifi_2p4/
├── design.json
├── summary.md
├── vbs/
│   ├── build_model.vbs
│   ├── hfss_arguments.json
│   ├── run_model.cmd
│   └── run_model.ps1
├── aedt_com/
│   ├── build_model_aedt.py
│   ├── run_model.cmd
│   └── run_model.ps1
└── pyaedt/
    ├── build_model_pyaedt.py
    ├── run_model.cmd
    ├── run_model.ps1
    └── run_model.sh
```

三种后端的几何均以 HFSS Local Variables 表达，`design.json` 中的 Agent 结果是变量默认值，不是写死后无法修改的实体尺寸。生成脚本在求解前检查端口列表；端口为空时立即失败，不会把无端口模型当作成功结果。

常用显式参数可以覆盖自然语言：

```powershell
.\bin\windows\ketupa-antenna.exe design `
  --frequency-ghz 2.4 `
  --relative-permittivity 3.0 `
  --substrate-height-mm 1.0 `
  --feed-type probe `
  --boundary ABC `
  --sweep-type Discrete `
  --compact `
  --no-calibration `
  --output "C:\AntennaWork\explicit_design"
```

## 4. 安装成 Codex Skill

Codex 当前官方位置：

- 用户级：`~/.agents/skills/ketupa-antenna-designer/SKILL.md`
- 项目级：`<project>/.agents/skills/ketupa-antenna-designer/SKILL.md`

官方说明：<https://learn.chatgpt.com/docs/customization/overview#skills>

### 4.1 用户级安装

```powershell
cd "C:\Tools\Ketupa-Antenna-Designer-skill"
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Target CodexUser
```

安装结果：

```text
%USERPROFILE%\.agents\skills\ketupa-antenna-designer\SKILL.md
```

### 4.2 单个项目安装

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 `
  -Target CodexProject `
  -ProjectRoot "D:\YourProject"
```

安装结果：

```text
D:\YourProject\.agents\skills\ketupa-antenna-designer\SKILL.md
```

### 4.3 在 Codex 中调用

安装后开启一个新的 Codex 任务，直接说：

```text
使用 $ketupa-antenna-designer，生成一个 2.4 GHz WiFi 矩形贴片天线，
介电常数 3，板厚 1 mm，同轴探针馈电，把结果放到 C:\AntennaWork\wifi_2p4。
```

也可以不显式写 `$` 名称；当请求明显属于 HFSS 贴片天线设计时，Codex 可以根据 Skill 描述自动选择它。为了首次验证，建议显式写出 Skill 名称。

### 4.4 Codex 安装检查

```powershell
& "$env:USERPROFILE\.agents\skills\ketupa-antenna-designer\bin\windows\ketupa-antenna.exe" --version
```

如果安装目标已存在，安装器默认停止，避免静默覆盖。确认要替换时添加 `-Force`；旧目录会先改名为带时间戳的备份。

## 5. 安装成 Claude Code Skill

Claude Code 当前官方位置：

- 用户级：`~/.claude/skills/ketupa-antenna-designer/SKILL.md`
- 项目级：`<project>/.claude/skills/ketupa-antenna-designer/SKILL.md`

官方说明：<https://code.claude.com/docs/en/skills>

### 5.1 用户级安装

```powershell
cd "C:\Tools\Ketupa-Antenna-Designer-skill"
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Target ClaudeUser
```

### 5.2 单个项目安装

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 `
  -Target ClaudeProject `
  -ProjectRoot "D:\YourProject"
```

### 5.3 同时安装到 Codex 和 Claude Code

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Target AllUser
```

### 5.4 在 Claude Code 中调用

打开新的 Claude Code 会话，输入：

```text
/ketupa-antenna-designer 生成一个 5.8 GHz 矩形贴片天线，er=3.48，h=0.8 mm，嵌入馈电
```

Claude Code 也可依据 `description` 自动触发。Skill 内部可用 `${CLAUDE_SKILL_DIR}` 定位自身目录；本发布包已经在 `SKILL.md` 中说明黑盒 EXE 的相对位置。

### 5.5 Claude Code 安装检查

```powershell
& "$env:USERPROFILE\.claude\skills\ketupa-antenna-designer\bin\windows\ketupa-antenna.exe" --version
```

## 6. HTTP API 使用

### 6.1 启动服务

仅本机访问：

```powershell
.\bin\windows\ketupa-antenna.exe serve `
  --host 127.0.0.1 `
  --port 8765 `
  --output-root "C:\AntennaWork\api_output"
```

局域网访问：

```powershell
.\bin\windows\ketupa-antenna.exe serve `
  --host 0.0.0.0 `
  --port 8765 `
  --output-root "C:\AntennaWork\api_output"
```

使用 `0.0.0.0` 前，应在 Windows 防火墙中只允许可信网段。当前 API 没有内置 TLS 和用户认证，不应直接暴露到公网。

### 6.2 健康检查

```powershell
Invoke-RestMethod http://127.0.0.1:8765/health
```

### 6.3 创建设计

```powershell
$body = @{
  prompt = "2.4 GHz WiFi 矩形贴片天线，介电常数 3，板厚 1 mm，同轴探针馈电"
  output_name = "wifi_2p4"
} | ConvertTo-Json

Invoke-RestMethod `
  -Uri http://127.0.0.1:8765/v1/design `
  -Method Post `
  -ContentType "application/json" `
  -Body $body
```

Linux/curl：

```bash
curl -sS http://WINDOWS_NODE_IP:8765/v1/design \
  -H 'Content-Type: application/json' \
  -d '{"prompt":"2.4 GHz rectangular patch, er=3, h=1 mm, probe feed","output_name":"wifi_2p4"}'
```

详细路由和 JSON 字段见 `references/API.md`。

## 7. 接入 OpenAI 兼容或本地大模型

大模型只负责把模糊自然语言归一化为结构化参数，最终尺寸仍由确定性引擎计算。

```powershell
.\bin\windows\ketupa-antenna.exe design `
  --prompt "我想做一个 2.45 GHz、小尺寸、低成本板材的 WiFi 贴片天线" `
  --llm-base-url "https://api.example.com/v1" `
  --llm-model "YOUR_MODEL_NAME" `
  --llm-api-key "YOUR_API_KEY" `
  --output "C:\AntennaWork\llm_normalized"
```

本地 OpenAI-compatible 服务可将 `--llm-base-url` 指向本机地址。完全离线时不要传任何 `--llm-*` 参数，程序会直接使用内置中英文解析器。

不要把 API Key 写进脚本或提交到 Git；优先使用临时环境变量或安全密钥管理。

## 8. 在 HFSS 中运行生成模型

### 8.1 VBS

适合 Windows AEDT。进入输出的 `vbs` 目录，检查 `hfss_arguments.json`，然后运行：

```powershell
.\run_model.ps1
```

生成的 VBS 无 UTF-8 BOM，Agent 默认参数已嵌入，可直接启动。脚本会严格检查 excitation，并在求解后自动输出 S11、Realized Gain、方向图和 `results/S11.s1p`。

### 8.2 AEDT COM Python

适合 Windows。运行环境必须具有可用的 `win32com`，且 AEDT COM ProgID 与安装版本兼容：

```powershell
cd "C:\AntennaWork\wifi_2p4\aedt_com"
python .\build_model_aedt.py --check-only
python .\build_model_aedt.py
```

`--build-only` 只创建并保存参数化工程，不执行求解。完整运行必须生成 `results/simulation_manifest.json` 和全部结果文件，否则以失败退出。

### 8.3 PyAEDT

适合兼容的 Windows/Linux AEDT 主机：

```powershell
cd "C:\AntennaWork\wifi_2p4\pyaedt"
python .\build_model_pyaedt.py --check-only
python .\build_model_pyaedt.py
python .\build_model_pyaedt.py --graphical
```

默认是非图形界面。不同 AEDT/PyAEDT 版本的端口、边界和报告 API 可能变化。首次运行必须人工检查端口积分线、辐射边界、单位、材料和扫频设置。

## 9. S 参数分析、学习和修正

分析：

```powershell
.\bin\windows\ketupa-antenna.exe analyze-sparams `
  "C:\AntennaWork\wifi_2p4\results\S11.s1p" `
  --target-frequency-ghz 2.4 `
  --threshold-db -10
```

记录可信结果：

```powershell
.\bin\windows\ketupa-antenna.exe learn `
  --design-file "C:\AntennaWork\wifi_2p4\design.json" `
  --result-file "C:\AntennaWork\wifi_2p4\results\S11.s1p" `
  --database "C:\AntennaWork\calibration.jsonl"
```

生成下一轮修正版：

```powershell
.\bin\windows\ketupa-antenna.exe refine `
  --design-file "C:\AntennaWork\wifi_2p4\design.json" `
  --result-file "C:\AntennaWork\wifi_2p4\results\S11.s1p" `
  --database "C:\AntennaWork\calibration.jsonl" `
  --output "C:\AntennaWork\wifi_2p4_r2"
```

只把已收敛、模式正确、端口正确、谐振识别可信的结果写入数据库。

## 10. 卸载 Skill

Codex 用户级：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\uninstall.ps1 `
  -Target CodexUser `
  -Confirm:$false
```

Claude Code 用户级：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\uninstall.ps1 `
  -Target ClaudeUser `
  -Confirm:$false
```

项目级卸载需要同时传 `-ProjectRoot`。

## 11. 黑盒说明

- 发布包不包含核心 Python 源码、单元测试源码、构建脚本和旧 VBS 资料库。
- EXE 使用 Nuitka 编译并单文件打包，提高普通分发场景下的代码保护程度。
- 任何客户端黑盒都不能保证密码学意义上的“绝对不可逆”。真正高保密需求应把算法部署为受认证的服务器 API，只向客户提供客户端。
- 请遵守 `LICENSE.txt`。

## 12. 验证说明

1.0.0 已完成：

- 8 项单元测试：全部通过。
- 1,000,000 项确定性工程回归：全部通过，失败 0。
- Windows EXE：版本、帮助、中文设计、三后端生成、生成 Python 语法、S 参数分析、HTTP `/health` 和 `/v1/design` 全部通过。
- Windows AEDT 2026.1 真实求解：VBS probe/inset、AEDT COM Python probe/inset、PyAEDT probe/edge 全部保留有效端口并成功生成参数化工程、S11、Realized Gain、方向图和 `S11.s1p`。

这 100 万项是解析、公式、几何参数、阻抗反算和后端静态生成回归，不是 100 万次 HFSS 求解。完整数字见 `validation_summary_1000000.json`，真实 AEDT 案例记录见 `hfss_validation_20260805.json`。

## 13. 常见问题

### EXE 无法启动

确认 Windows 为受支持的 x64 版本，并安装最新系统更新。Windows 10/11 通常自带运行所需的 Universal CRT。若企业安全软件拦截单文件解包，应对经过校验的 EXE 设置允许规则，而不是关闭整机防护。

### Skill 没有被 Codex/Claude Code 识别

检查 `SKILL.md` 是否位于正确目录，关闭并重新开启任务/会话。不要同时在旧的 `~/.codex/skills` 和新的 `~/.agents/skills` 安装重复副本。

### 生成成功但 HFSS 结果偏移

检查实际 Dk/Df、频散、铜厚与粗糙度、有限地尺寸、馈电结构、端口、边界距离和网格收敛，再使用 `refine`。不要直接把错误模式写入学习数据库。

## 14. 作者

作者：hongbo.li  
邮箱：asenjoaupa@gmail.com  
　　　3405802009@qq.com
