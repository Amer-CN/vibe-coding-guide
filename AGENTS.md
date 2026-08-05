# 项目真源文档（AGENTS.md）

> 这份文档是本项目“唯一说得算”的地方。每开一个新的 AI 对话，第一句先让它读这份文件。
> 任何重要决定定下来后立刻写进这里；这里没写的，一律视为还没定。

## 一、这个项目是什么

**vibe-coding-guide** 是一份给 AI 编程用的“规矩本”，外加一层真的会拦下危险操作的护栏（Claude Code 插件方式）。

- **给谁用**：不懂代码、靠 AI Agent（Claude Code、Cursor、Codex 等）开发软件产品的人——产品经理、创业者、独立开发者。
- **它解决什么**：AI 改代码“一改就崩、换电脑就报错、说修好了其实没好”；密码/金额/敏感数据怎么存；上线前怎么体检。
- **仓库形态**：纯文档 + 少量 bash 工具（自动体检脚本 + PreToolUse 护栏），无编译产物、无运行时依赖。

## 二、目录结构与职责

| 路径 | 职责 |
|---|---|
| `SKILL.md` | 核心规矩（五条铁律 + 十一条红线 + 三阶段工作流 + 参考文件路由表）。AI 读这份就够 |
| `references/` | 按需加载的展开说明：`redlines.md`（红线展开）、`legacy-audit.md`（老项目大检查）、`new-project.md`（新项目三阶段）、`scenarios.md`（五类项目）、`ai-disputes.md`（AI 分歧裁决）、`checklist.md`（25 条交付清单，⭐ 为最小必查 8 条） |
| `assets/` | 模板三件套：`AGENTS.template.md`（真源文档骨架）、`gitignore.template`、`delivery-report.template.md`（交付体检报告） |
| `scripts/audit.sh` | 自动体检：把清单里能机器查的部分跑一遍，输出 ✅／❌ 与 `文件:行号` |
| `hooks/` | Claude Code PreToolUse 强制护栏：`hooks.json`（配置）+ `guard-bash.sh`（危险命令）+ `guard-write.sh`（危险写入）+ `_common.sh`（共用函数，fail-open） |
| `install.sh` | 一键安装（克隆到 `~/.claude/skills/`）。只装规矩本，护栏不保证生效（见 docs/decisions/） |
| `.claude-plugin/` | 插件市场配置（plugin.json / marketplace.json） |
| `CHANGELOG.md` | 版本变更记录（历史小节不回改，见 docs/decisions/） |
| `README.md` / `README.en.md` | 对外介绍（双语） |
| `LICENSE.md` | 双重许可（中文为权威版本） |

## 三、关键设计决策

1. 护栏保持「极窄 deny + 带编号的 ask」：deny 只放几乎不存在正当理由的操作。
2. install.sh 路径的护栏标注为「不保证生效」。
3. CHANGELOG 历史小节不回改，新变更写进新小节。
4. 四个 .sh 的 shellcheck 必须用 git show HEAD:<file> 取 LF 版。
5. 程序输出字面量不参与标点规范化。
6. 跨文件搬运文本后，提交「原句 → 现句」逐条对照；「已逐字搬运」这类概括不算验收。

## 四、协作纪律

> 前 5 条对应 SKILL.md 的五条铁律，第 6 条是本仓库自己的补充。

1. 删/改数据、改库结构、装新依赖——做之前先问。
2. 同一问题修 3 次仍不成，停手，分析根因 + 给 2 种思路让用户选。
3. 不准只说“我修好了”——给证据：跑了什么命令、输出是什么。测试不过时改实现去满足测试，不准改测试来迁就实现。
4. 重要决定定下来后立刻写进本文件；开新对话先让 AI 读它。本文件没写的，一律视为还没定。
5. 指令自相矛盾或与红线冲突时，停下来问，不要自己挑一条执行完再报“已完成”。
6. 每次只改一小步，改前存档，改后跑体检命令。

## 五、体检命令（红绿灯）

- 自动体检（必须有）：`bash scripts/audit.sh .`，应退出码 0
- 语法检查：`bash -n` 四个 .sh
- Shell 检查：`git show HEAD:<file> > /tmp/x && shellcheck /tmp/x`（LF 版，见 docs/decisions/）
- 结构校验：代码块围栏成对、表格列一致、无连续分隔线（`---` 空行 `---`）与三连空行

> 全绿才算通过。跑不起来的命令不许写进这张表。

## 六、已知不做（明确的不做清单）

| 项 | 为什么不做 |
|---|---|
| 提示词注入检测 | 语义问题，grep 模式匹配做不了——判断“这段模型输出会不会被拿去执行”不是模式能解决的，硬做只会抓不到真问题还打印假绿。红线 9、11 保持人读的规矩，不进机器查的清单 |
| `claude plugin validate .` | 作者已不使用 Claude Code，本机无该 CLI，无法验证插件元数据；改用 json.load + 结构自检代替 |
| shellcheck 10 条风格告警 | SC2086×4、SC2012×2、SC2035×1、SC2034×2、SC2016×1，均为风格类、不改变行为；改动需动 hooks/scripts 代码，留待需要时处理 |

## 七、时效性

- `hooks/` 的机制（`hooks/hooks.json` 插件式 PreToolUse 配置、`${CLAUDE_PLUGIN_ROOT}` 占位符）基于 **2026 年 8 月的 Claude Code 规范**。
- 作者已不再日常使用 Claude Code，规范如有变更不会第一时间跟进。接手者改动 hooks 相关代码前，应先核对官方文档（code.claude.com/docs/en/hooks 与 /plugins-reference）。

## 八、教训（一天踩过的坑）

1. **“测试全绿”和“功能活着”是两回事**：guard 私钥规则因 `match --` 传参错误永远不触发、C17 只抓单行、audit.sh 扫自己出假阳——三个都是绿灯通过的死功能。测试矩阵必须逐条覆盖规则，样例代表真实形状，不许改样例迁就实现。
2. **Windows 上 shellcheck 的数字要先查行尾**：277 条告警里 261 条是 CRLF 噪声（SC1017），`git ls-files --eol` 看一眼再统计。
3. **改完的东西要对着提交验证，不是对着临时工作树**：双 `---` 那次压平后因 `git checkout` 恢复丢失，汇报说“已压平”实际没进提交——验证对象是提交后的内容。
4. **文档里的字面量是事实**：`文件:行号` 是程序输出，批量替换标点前先排除，为格式统一改事实是错误。
5. **没人碰过的文件最危险**：install.sh 从 v1.0 活到 v2.1 没人审过，最终结论是“机制可行但别承诺没实测的事”——诚实标注比假装完整强。

## 九、决策记录

历史决策与论证见 `docs/decisions/`（只追加、不修改）。
