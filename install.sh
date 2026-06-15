#!/usr/bin/env bash
# vibe-coding-guide 一键安装脚本
# 用法:curl -fsSL https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/install.sh | bash
set -euo pipefail

REPO_URL="https://github.com/Amer-CN/vibe-coding-guide.git"
SKILLS_DIR="${HOME}/.claude/skills"
TARGET_DIR="${SKILLS_DIR}/vibe-coding-guide"

echo "▶ 正在安装 vibe-coding-guide ..."

if ! command -v git >/dev/null 2>&1; then
  echo "✗ 未检测到 git,请先安装 git 后重试。"
  exit 1
fi

mkdir -p "${SKILLS_DIR}"

if [ -d "${TARGET_DIR}/.git" ]; then
  echo "• 已安装,正在更新到最新版本 ..."
  git -C "${TARGET_DIR}" pull --ff-only
else
  git clone --depth 1 "${REPO_URL}" "${TARGET_DIR}"
fi

echo ""
echo "✓ 安装完成!位置:${TARGET_DIR}"
echo "  在 Claude Code 新对话里说一句:\"我要用 vibe-coding-guide 规范来写代码\" 即可。"
