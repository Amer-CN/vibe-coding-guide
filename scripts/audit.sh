#!/usr/bin/env bash
# vibe-coding-guide 自动体检：把交付清单里能机器查的部分跑一遍。
# 它只是 grep 启发式，抓到的一定要看，没抓到不等于没问题。
set -u

TARGET="${1:-.}"
SELF_ABS="$(cd "$(dirname "$0")" 2>/dev/null && pwd)/$(basename "$0")"
cd "$TARGET" 2>/dev/null || { echo "找不到目录：$TARGET" >&2; exit 2; }

FAIL=0
WARN=0
# 只排除脚本自己这一个文件，不排除 scripts/ 或 hooks/ 目录——
# 用户项目里那两个目录常有真代码要审（插件安装场景 SELF_REL 为空，行为不变）。
ROOT_ABS="$(pwd)"
case "$SELF_ABS" in
	"$ROOT_ABS"/*) SELF_REL="./${SELF_ABS#"$ROOT_ABS"/}" ;;
	*)             SELF_REL="" ;;
esac
EX="--exclude-dir=.git --exclude-dir=node_modules --exclude-dir=vendor
--exclude-dir=dist --exclude-dir=build --exclude-dir=.next --exclude-dir=out
--exclude-dir=venv --exclude-dir=.venv --exclude-dir=__pycache__
--exclude-dir=coverage --exclude-dir=.pytest_cache
--exclude=*.md --exclude=*.mdx --exclude=*.txt --exclude=*.rst
--exclude=*.example --exclude=*.template --exclude=*.sample"

ok()   { printf '[✅] %-5s %s\n' "$1" "$2"; }
no()   { printf '[❌] %-5s %s\n' "$1" "$2"; FAIL=1; }
na()   { printf '[➖] %-5s %s\n' "$1" "$2"; }
warn() { printf '[⚠️] %-5s %s\n' "$1" "$2"; WARN=$((WARN+1)); }
ev()   { printf '%s\n' "$1" | head -n 5 | sed 's/^/           /'; }

scan() {
	if [ -n "$SELF_REL" ]; then
		grep -rIniE $EX "$1" . 2>/dev/null | grep -v "^${SELF_REL}:"
	else
		grep -rIniE $EX "$1" . 2>/dev/null
	fi
}
# 大小写敏感版：打包器只认大写前缀（NEXT_PUBLIC_ 等），小写同名变量不会进浏览器包
scanS() {
	if [ -n "$SELF_REL" ]; then
		grep -rInE $EX "$1" . 2>/dev/null | grep -v "^${SELF_REL}:"
	else
		grep -rInE $EX "$1" . 2>/dev/null
	fi
}

echo "vibe-coding-guide 自动体检 — $(pwd)"
echo "======================================================"

# C3 密码哈希
R="$(scan '(md5|sha1|sha256)[[:space:]]*\(' | grep -iE 'passw|pwd|密码' || true)"
if [ -n "$R" ]; then no "C3" "疑似用 MD5/SHA 存密码，应改用 bcrypt/argon2/scrypt"; ev "$R"
else ok "C3" "未发现用 MD5/SHA 处理密码"; fi

# C4 金额浮点
R="$(scan '(price|amount|money|balance|fee|total|cost|salary)[^;]{0,40}(FLOAT|DOUBLE|REAL)' || true)"
if [ -n "$R" ]; then no "C4" "金额字段疑似使用浮点类型，应改整数分或 DECIMAL"; ev "$R"
else ok "C4" "未发现金额字段使用浮点类型"; fi

# C7 密钥
R="$(git ls-files 2>/dev/null | grep -E '(^|/)\.env($|\.)' | grep -vE '\.(example|sample|template)$' || true)"
if [ -n "$R" ]; then no "C7a" ".env 已被 Git 跟踪，密钥可能已进入历史"; ev "$R"
else ok "C7a" "未发现 .env 被 Git 跟踪"; fi

# 用 scanS：打包器只认大写前缀（NEXT_PUBLIC_ 等），小写同名变量不会进浏览器包
R="$(scanS '(NEXT_PUBLIC_|VITE_|REACT_APP_|EXPO_PUBLIC_)[A-Z0-9_]*(KEY|SECRET|TOKEN|PASSWORD)' || true)"
if [ -n "$R" ]; then no "C7b" "前端可见的环境变量里出现了密钥类命名，会被打包进浏览器"; ev "$R"
else ok "C7b" "前端环境变量未发现密钥类命名"; fi

R="$(scan '(api[_-]?key|apikey|secret|token|password|passwd)["'"'"']?[[:space:]]*[:=][[:space:]]*["'"'"'][A-Za-z0-9_/+-]{16,}["'"'"']' | grep -viE '(example|sample|placeholder|your[_-]|xxx|changeme|test)' || true)"
if [ -n "$R" ]; then no "C7c" "疑似硬编码密钥或口令"; ev "$R"
else ok "C7c" "未发现明显的硬编码密钥"; fi

if [ -f .gitignore ]; then
	if grep -qE '^\s*\.env' .gitignore; then ok "C7d" ".gitignore 已排除 .env"
	else no "C7d" ".gitignore 存在但没有排除 .env"; fi
else no "C7d" "没有 .gitignore 文件"; fi

# C9 SQL 拼接
R="$(scan '(execute|query|cursor\.execute)\([^)]*("[^"]*(SELECT|INSERT|UPDATE|DELETE)[^"]*"[[:space:]]*\+|f"[^"]*(SELECT|INSERT|UPDATE|DELETE)|%s?"[[:space:]]*%)' || true)"
if [ -n "$R" ]; then no "C9" "疑似字符串拼接 SQL，应改参数化查询"; ev "$R"
else ok "C9" "未发现明显的 SQL 字符串拼接"; fi

# C13 模型 Key 在前端
R="$(scan '(sk-[A-Za-z0-9]{20,}|OPENAI_API_KEY|ANTHROPIC_API_KEY)' | grep -iE '^\./[^:]*(src/|components/|pages/|app/|public/|client)' || true)"
if [ -n "$R" ]; then no "C13" "前端目录里出现模型 API Key，应只在后端调用"; ev "$R"
else ok "C13" "前端目录未发现模型 API Key"; fi

# C14 Git 与备份
if [ -d .git ]; then ok "C14" "有 Git 仓库，可以回退"
else no "C14" "没有 Git 仓库，改坏了无法回退"; fi

# C17 静默吞错（含跨行形态）
silent_catch_multiline() {
	# shellcheck disable=SC2086
	grep -rIl $EX -E '(except|catch)' . 2>/dev/null | while IFS= read -r f; do
		awk -v F="$f" '
			{
				line = $0
				sub(/[[:space:]]+$/, "", line)
				if (pend && NR == pendline + 1) {
					if (line ~ /^[[:space:]]*(pass|\})$/) {
						printf "%s:%d:%s\n", F, NR, $0
					}
					pend = 0
				}
				if (line ~ /except[[:space:]]*[A-Za-z_.]*([[:space:]]+as[[:space:]]+[A-Za-z_]+)?[[:space:]]*:$/ \
				 || line ~ /catch[[:space:]]*(\([^)]*\))?[[:space:]]*\{$/) {
					pend = 1; pendline = NR
				}
			}
		' "$f"
	done
}

R="$( { scan '(except[[:space:]]*[A-Za-z]*[[:space:]]*:[[:space:]]*pass|catch[[:space:]]*\([^)]*\)[[:space:]]*\{[[:space:]]*\})'; silent_catch_multiline; } 2>/dev/null || true)"
if [ -n "$R" ]; then no "C17" "存在捕获异常后既不处理也不记录的静默吞错"; ev "$R"
else ok "C17" "未发现静默吞错"; fi

# C18 迁移文件
if ls -d migrations Migrations db/migrate prisma/migrations supabase/migrations 2>/dev/null | head -n1 | grep -q . \
	|| ls *.sql 2>/dev/null | head -n1 | grep -q .; then
	ok "C18" "找到数据库迁移或建表文件"
elif [ -n "$(scan '(CREATE TABLE|createTable)' || true)" ]; then
	no "C18" "代码里在建表，但没有独立的迁移文件作为唯一来源"
else na "C18" "未发现数据库相关代码，跳过"; fi

# C23 依赖锁定
LOCKED=0; NEEDED=0
for m in package.json:package-lock.json,pnpm-lock.yaml,yarn.lock,bun.lockb \
	pyproject.toml:poetry.lock,uv.lock Gemfile:Gemfile.lock composer.json:composer.lock; do
	man="${m%%:*}"; locks="${m#*:}"
	[ -f "$man" ] || continue
	NEEDED=1
	IFS=','; for l in $locks; do
		git ls-files --error-unmatch "$l" >/dev/null 2>&1 && LOCKED=1
	done; unset IFS
done
if [ "$NEEDED" = "0" ]; then na "C23" "未发现依赖清单，跳过"
elif [ "$LOCKED" = "1" ]; then ok "C23" "依赖锁定文件已提交进 Git"
else no "C23" "有依赖清单但锁定文件没提交，换台机器装出来可能不是同一份代码"; fi

# W1/W2 先以 warn 进场跑满一个版本，下一版由一次显式提交转硬拦。
# W1 规则体积（AGENTS.md ≤200 行 / ≤10KB / 单行 ≤500 字符）
if [ -f AGENTS.md ]; then
	LINES="$(awk 'END { print NR }' AGENTS.md)"
	BYTES="$(wc -c < AGENTS.md | awk '{ print $1 }')"
	# UTF-8 每字符恰好一个非连续字节，去掉连续字节后长度即字符数，不依赖 locale
	MAXINFO="$(awk '{ line=$0; sub(/\r$/, "", line); gsub(/[\x80-\xBF]/, "", line); if (length(line) > m) { m = length(line); ml = NR } } END { print m+0, ml+0 }' AGENTS.md)"
	MAXLINE="${MAXINFO%% *}"
	MAXLINE_NO="${MAXINFO##* }"
	VIOLATIONS=""
	if [ "$LINES" -gt 200 ] && [ "$BYTES" -gt 10240 ]; then
		VIOLATIONS="AGENTS.md 行数与字节超限（${LINES} 行 / ${BYTES} 字节，上限 200 行 / 10KB）"
	elif [ "$LINES" -gt 200 ]; then
		VIOLATIONS="AGENTS.md 行数超限（${LINES} 行 / 上限 200）"
	elif [ "$BYTES" -gt 10240 ]; then
		VIOLATIONS="AGENTS.md 字节超限（${BYTES} 字节 / 上限 10KB）"
	fi
	if [ "$MAXLINE" -gt 500 ]; then
		if [ -n "$VIOLATIONS" ]; then
			VIOLATIONS="${VIOLATIONS}；AGENTS.md:${MAXLINE_NO} 单行超长（${MAXLINE} 字符 / 上限 500）"
		else
			VIOLATIONS="AGENTS.md:${MAXLINE_NO} 单行超长（${MAXLINE} 字符 / 上限 500）"
		fi
	fi
	if [ -n "$VIOLATIONS" ]; then
		warn "W1" "${VIOLATIONS}：膨胀说明有内容放错了位置：能机器查的写成检查项，为什么这么定的写进 docs/decisions/，现状快照删掉改成写『跑哪条命令能看到』"
	else
		ok "W1" "AGENTS.md 规则体积在预算内（${LINES} 行 / ${BYTES} 字节 / 单行最长 ${MAXLINE} 字符）"
	fi
else
	na "W1" "项目根没有 AGENTS.md，跳过"; fi

# W2 单一真身（AGENTS.md 与 CLAUDE.md 并存时，CLAUDE.md 去注释后只能有一行指向 AGENTS.md）
if [ -f AGENTS.md ] && [ -f CLAUDE.md ]; then
	BODY="$(awk '
		BEGIN { in_comment = 0 }
		{
			line = $0
			sub(/\r$/, "", line)
			while (1) {
				if (in_comment) {
					end = index(line, "-->")
					if (end == 0) { line = ""; break }
					line = substr(line, end + 3)
					in_comment = 0
				} else {
					start = index(line, "<!--")
					if (start == 0) break
					before = substr(line, 1, start - 1)
					rest = substr(line, start + 4)
					end = index(rest, "-->")
					if (end == 0) { line = before; in_comment = 1; break }
					line = before substr(rest, end + 3)
				}
			}
			if (line !~ /^[[:space:]]*$/) printf "%d:%s\n", NR, line
		}
	' CLAUDE.md)"
	COUNT="$(printf '%s\n' "$BODY" | grep -c . || true)"
	if [ "$COUNT" -eq 1 ] && printf '%s' "$BODY" | grep -q 'AGENTS.md'; then
		ok "W2" "CLAUDE.md 去注释后只有一行指向 AGENTS.md，真身唯一"
	else
		EXTRA="$( { printf '%s' "$BODY" | grep -v 'AGENTS.md' || true; printf '%s' "$BODY" | grep 'AGENTS.md' | tail -n +2 || true; } | sed 's/:.*$//' | sort -n | tr '\n' ' ' | sed 's/ $//' )"
		if [ -n "$EXTRA" ]; then
			POS="$(printf '%s' "$EXTRA" | sed 's/^/CLAUDE.md:/; s/ / CLAUDE.md:/g')"
			warn "W2" "两份规则必然分叉，选一份当真身：${POS}（CLAUDE.md 去注释后应有且仅有一行指向 AGENTS.md，现有 ${COUNT} 行非空内容）"
		else
			warn "W2" "两份规则必然分叉，选一份当真身：CLAUDE.md 去注释后没有一行指向 AGENTS.md（现有 ${COUNT} 行非空内容）"
		fi
	fi
else
	na "W2" "AGENTS.md 与 CLAUDE.md 未并存，跳过"; fi

# W3 决策档案格式（warn：文件名 YYYY-MM-DD-主题.md + 五节齐全，纯文本匹配）
if [ -d docs/decisions ]; then
	W3_BAD=0
	for f in docs/decisions/*; do
		[ -f "$f" ] || continue
		base="$(basename "$f")"
		[ "$base" = "README.md" ] && continue
		if ! printf '%s' "$base" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}-.+\.md$'; then
			warn "W3" "docs/decisions/$base 文件名不符合 YYYY-MM-DD-主题.md 格式"
			W3_BAD=1
		fi
		MISS=""
		for h in 影响 根因 裁决 被否决的方案 不变量; do
			if ! grep -qF "## $h" "$f"; then
				MISS="${MISS} $h"
			fi
		done
		if [ -n "$MISS" ]; then
			warn "W3" "docs/decisions/$base 缺节：${MISS# }"
			W3_BAD=1
		fi
	done
	if [ "$W3_BAD" = "0" ]; then
		ok "W3" "docs/decisions/ 文件名与五节齐全"
	fi
else
	na "W3" "没有 docs/decisions/ 目录，跳过"; fi
echo "======================================================"
echo "⚠️ 提醒 ${WARN} 条：W1/W2/W3 先以 warn 进场，不影响退出码"
cat <<'EOF'

这个脚本只做了文本匹配，能力有限：

- 抓到的（❌）几乎都值得看一眼，但可能有误报，逐条确认再改。
- 没抓到的不等于安全。它完全查不了这些：
  权限是否真在后端校验（C1 C2 C10）、敏感信息是否加密（C5）、
  是否软删除加审计（C6）、默认口令（C8）、模型输出是否被校验（C11 C12）、
  是否有冒烟测试（C15）、建表脚本与代码字段是否一致（C16）、
  结构与规范类（C19-C22）、Agent 权限与密钥外泄（C24 C25）。
- 完整的 25 条见 references/checklist.md，逐条填 assets/delivery-report.template.md。

EOF

exit $FAIL
