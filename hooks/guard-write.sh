#!/usr/bin/env bash
# 拦截危险的文件写入。fail-open。
set -u
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
. "$DIR/_common.sh"

FILE="$(json_get '.tool_input.file_path' 'd.get("tool_input",{}).get("file_path","")')"
BODY="$(json_get '.tool_input.content // .tool_input.new_string' 'd.get("tool_input",{}).get("content") or d.get("tool_input",{}).get("new_string","")')"
[ -z "$BODY" ] && exit 0

# 文档类文件直接放行：规则文本里天然出现 password / API Key 等词，不能自己拦自己。
case "$FILE" in
	*.md|*.mdx|*.txt|*.rst|*.example|*.template|*.sample) exit 0 ;;
esac
case "$FILE" in
	*/.env.example|*/.env.sample|*CHANGELOG*|*LICENSE*) exit 0 ;;
esac

SUBJECT="$BODY"

# ── 硬拦：私钥文件内容 ──────────────────
match -- '-----BEGIN[[:space:]][A-Z ]*PRIVATE KEY-----' \
	&& deny '你正在把一段私钥写进文件。私钥绝不能进代码库（红线 7）'

# ── 弹确认 ──────────────────
match '(NEXT_PUBLIC_|VITE_|REACT_APP_|EXPO_PUBLIC_)[A-Z0-9_]*(KEY|SECRET|TOKEN|PASSWORD)' \
	&& ask '带这些前缀的变量会被打包进浏览器，任何人都能看到，不能放真密钥（红线 7）'

match '(api[_-]?key|apikey|secret|token|password|passwd)["'"'"']?[[:space:]]*[:=][[:space:]]*["'"'"'][A-Za-z0-9_/+-]{16,}["'"'"']' \
	&& ask '这里像是硬编码的密钥或口令。应该放进环境变量并被 .gitignore 排除（红线 7）'

match '(price|amount|money|balance|fee|total|cost|salary|金额|价格|余额)[^;\n]{0,40}(FLOAT|DOUBLE|REAL)' \
	&& ask '金额字段用了浮点类型，对账迟早对不上。请改成整数分或 DECIMAL（红线 4）'

match '(md5|sha1|sha256)[[:space:]]*\(' && match '(password|passwd|pwd|密码)' \
	&& ask '密码不能用 MD5/SHA 这类算法存。请改用 bcrypt、argon2 或 scrypt（红线 3）'

exit 0
