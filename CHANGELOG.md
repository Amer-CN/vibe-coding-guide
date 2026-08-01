# Changelog

本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [1.1.0] - 2026-08-01

### Changed
- **精简 `SKILL.md` 的 description**：从 600+ 字的关键词堆砌压缩到约 150 字，长尾触发说法统一由 README 承载，减少常驻上下文占用。
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
