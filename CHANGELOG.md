# Changelog

本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

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
