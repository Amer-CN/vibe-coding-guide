#!/usr/bin/env bash
# vibe-coding-guide 护栏共用函数。
# 设计原则：本脚本任何自身故障都必须 fail-open（放行），绝不阻断用户。

set -u

CLOSE_HINT="关闭护栏：/plugin disable vibe-coding-guide"

INPUT="$(cat 2>/dev/null || true)"

if command -v jq >/dev/null 2>&1; then
	JSON_TOOL="jq"
elif command -v python3 >/dev/null 2>&1; then
	JSON_TOOL="python3"
else
	echo "vibe-coding-guide: 未找到 jq 或 python3，护栏已跳过（放行）。" >&2
	exit 0
fi

# json_get <jq过滤器> <python表达式>
json_get() {
	if [ "$JSON_TOOL" = "jq" ]; then
		printf '%s' "$INPUT" | jq -r "$1 // empty" 2>/dev/null || true
	else
		printf '%s' "$INPUT" | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(0)
try:
    v = '"$2"'
except Exception:
    v = ""
sys.stdout.write(str(v) if v else "")
' 2>/dev/null || true
	fi
}

# 输出决定。理由文本中禁止出现双引号、反斜杠和换行。
emit() {
	printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"%s","permissionDecisionReason":"%s"}}\n' "$1" "$2"
	exit 0
}

deny() { emit "deny" "⛔ vibe-coding-guide 拦截：$1。确需执行请你自己在终端手动运行。$CLOSE_HINT"; }
ask()  { emit "ask"  "⚠️ vibe-coding-guide 提醒：$1。确认要继续吗？$CLOSE_HINT"; }

# 大小写不敏感匹配
match() { printf '%s' "$SUBJECT" | grep -qiE "$1"; }
