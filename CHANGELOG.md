# Changelog

本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [2.2.0] - 2026-08-05

### Added
- `assets/decision.template.md`：五节式决策档案模板，强调「被否决的方案」与「不变量含失效条件」，文件名用 `YYYY-MM-DD-短横线主题.md`，只追加、不修改。
- `scripts/audit.sh` 新增 W1 规则体积、W2 单一真身两项检查，先以 warn 进场，只提醒、不影响退出码。
- `docs/decisions/`：8 篇决策档案 + README（一篇一决策、只追加、推翻时另写新篇并注明取代关系）。
- `scripts/audit.sh` 新增 W3 决策档案格式检查（warn：文件名与五节齐全）。

### Changed
- `SKILL.md` 铁律 4 改为「结论进 AGENTS.md、论证与被否决的方案进 docs/decisions/」；工作流补人眼验收（绿灯 → 启动给用户看 → 用户点头 → 提交 Git）。
- `SKILL.md` 新增两条硬规则：回退先确认已验收版本并保留历史；合并进主分支不等于上线。
- `SKILL.md` 路由表新增「需要记录一条重要决定 → assets/decision.template.md」。
- `SKILL.md` 「两条硬规则」改名「Git 与上线纪律」并补上小节前的空行。
- `scripts/audit.sh` W1 只报真正越界的指标（`AGENTS.md` 或 `AGENTS.md:<行号>`）；W2 补 CLAUDE.md 多余非空行的行号。
- `assets/decision.template.md` 顶部注释补落点与首次创建 README 的说明。
- `AGENTS.md` 第三节瘦身为当前生效的祈使句规矩，第九节表格替换为 `docs/decisions/` 索引；删除 3 条第九节重复杂目（一进一出抵扣 3 条）；2 条被否决方案描述原样移入档案（论证资产，不计入抵扣）。
- `assets/decision.template.md` 顶部注释补「格式范例见本仓库 docs/decisions/」。
- `docs/decisions/` 三篇档案裁决改为不变量第 1 项，原裁决原句移入影响/根因；8 篇文末补追溯迁移声明。
- `docs/decisions/README.md` 明令禁止事后编造「被否决的方案」或「失效条件」。
- `scripts/audit.sh` W3 增加占位统计行（N/M 篇含未填写占位，只统计、不影响退出码）。
- `AGENTS.md` 第三节新增「跨文件搬运必须提交原句→现句逐条对照」。
- `assets/decision.template.md` 裁决注释补「与不变量逐字相同即槽位错填」；`SKILL.md` 铁律 3 补「汇报前删掉已被后续动作推翻的过程性描述」。

## [2.1.0] - 2026-08-01

### Added
- 铁律从四条扩到五条：新增「测试不过时改实现去满足测试，不准改测试来迁就实现」与「指令自相矛盾或与红线冲突时，停下来问用户」两条。这是行为约束的扩充，非破坏性变更，故升次版本。
- README 双语新增「装完后，花一分钟确认护栏真的生效了」验证步骤。
- `SKILL.md` description 末尾追加英文触发句——description 是 Agent 判断要不要加载本技能的唯一依据，纯中文会让英文提问几乎不触发。

### Changed
- `references/checklist.md` 第 15 条补充「新加的每一条校验或拦截规则，是否本身也有一条测试覆盖」。
- LICENSE.md 与插件元数据（plugin.json / marketplace.json）的中文标点统一为全角。
- install.sh 与 README 明确区分「规矩本安装」与「完整安装」；护栏是否随 skills 目录安装生效未经实测，不做承诺。

## [2.0.0] - 2026-08-01

### Added
- `scripts/audit.sh`：自动体检脚本，覆盖清单中可机检的部分，输出 ✅／❌ 与 `文件:行号`，
  并明确列出它查不了的条目。
- `hooks/`：基于 Claude Code PreToolUse 的强制护栏。极少数不可逆操作直接拦下，
  其余弹确认并标明违反的红线编号；拒绝信息中包含关闭方法。
- README 新增「关于强制护栏」一节，写明生效范围与失效场景。

### Changed
- 红线从"只靠 AI 自觉遵守"变为"部分由 hooks 强制"，这是本项目定位上的变化，故升主版本。
- `banner.png` 压缩，仓库体积大幅下降。
- `references/new-project.md` 速查页排序表述与清单对齐。
- `assets/delivery-report.template.md` 条目列改为按显示宽度截断。

## [1.2.0] - 2026-08-01

### Added
- 红线从 8 条扩到 11 条：新增「AI 功能」「依赖供应链」「Agent 操作安全」三组。
- 自检清单从 19 条扩到 25 条，并标出 ⭐ 最小必查 8 条。
- `assets/` 模板三件套：`AGENTS.template.md`、`gitignore.template`、`delivery-report.template.md`。

### Changed
- `SKILL.md` description 同步为 25 条，并覆盖三组新红线的触发场景。
- `SKILL.md` 参考文件路由表新增 `assets/` 一行。

## [1.1.0] - 2026-08-01

### Changed
- **精简 `SKILL.md` 的 description**：从 600+ 字的关键词堆砌压缩到约 190 字，长尾触发说法统一由 README 承载，减少常驻上下文占用。
- **真源文档统一为 `AGENTS.md`**：不再与 `CLAUDE.md` 并列；`CLAUDE.md` 退化为一行引用。
- **拆分 `references/handbook.md`**：原 33KB 单文件拆为 `redlines.md`、`legacy-audit.md`、`new-project.md`、`scenarios.md`、`ai-disputes.md`，实现按需加载。
- **消除重复**：“四铁律 + 八红线”原先在三处各写一遍，现以 `SKILL.md`（短表）+ `redlines.md`（展开）为唯一来源。
- `references/checklist.md` 要求每条给出证据位置。

### Added
- 本 CHANGELOG。
- `SKILL.md` 中的参考文件路由表。

### Removed
- `references/handbook.md`（内容已全部迁移，无信息丢失）。

## [1.0.0] - 2026-06-15

- 首次发布：`SKILL.md` + 完整手册 + 19 条自检清单 + Claude Code 插件配置。
