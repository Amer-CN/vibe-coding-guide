# 四个 .sh 的 shellcheck 必须取 LF 版（2026-08-01）

## 影响

- 之前：直接对 Windows 工作树跑 shellcheck 会被 SC1017 行尾噪声淹没，277 条告警里 261 条是噪声。
- 之后：先 `git ls-files --eol` 看行尾，再 `git show HEAD:<file>` 取 LF 版检查，真实告警只有 16 条。

## 根因

四个 .sh 在仓库里是 LF，Windows 工作树是 CRLF。跑 shellcheck 必须用 `git show HEAD:<file>` 取 LF 版再检查，否则会被 SC1017（Literal carriage return）淹没——曾出现过“277 条告警”里 261 条是行尾噪声的情况，真实告警只有 16 条。

## 裁决

**跑 shellcheck 必须用 `git show HEAD:<file>` 取 LF 版再检查；先 `git ls-files --eol` 看行尾，再统计数字。**

## 被否决的方案

- 原始记录未载。

## 不变量

1. 对 .sh 的 shellcheck 统计必须基于 LF 版。
2. 失效条件：原始记录未载。

