#!/usr/bin/env bash
# vibe-coding-guide 自动体检：把交付清单里能机器查的部分跑一遍。
# 它只是 grep 启发式，抓到的一定要看，没抓到不等于没问题。
set -u

TARGET="${1:-.}"
SELF_ABS="$(cd "$(dirname "$0")" 2>/dev/null && pwd)/$(basename "$0")"
cd "$TARGET" 2>/dev/null || { echo "找不到目录：$TARGET" >&2; exit 2; }

FAIL=0
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

echo "======================================================"
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
