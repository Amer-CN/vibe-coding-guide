#!/usr/bin/env bash
# 拦截危险 Bash 命令。fail-open。
set -u
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
. "$DIR/_common.sh"

CMD="$(json_get '.tool_input.command' 'd.get("tool_input",{}).get("command","")')"
[ -z "$CMD" ] && exit 0
SUBJECT="$CMD"

# ── 硬拦（deny）：几乎不存在正当理由 ──────────────────

# 1. 根级 / 家目录 / 系统目录的递归删除
match 'rm[[:space:]]+(-[a-z]*[rf][a-z]*[[:space:]]+)+(/|~|\$HOME|\*)([[:space:]]|$)' \
	&& deny '这是对根目录或家目录的递归删除，会清空整台机器（铁律 1）'
match 'rm[[:space:]]+(-[a-z]*[rf][a-z]*[[:space:]]+)+/(usr|etc|var|bin|lib|opt|home|root|System|Library|Users)([[:space:]/]|$)' \
	&& deny '这是对系统目录的递归删除，会让系统无法启动（铁律 1）'
match 'rm[[:space:]]+(-[a-z]*[rf][a-z]*[[:space:]]+)+\.([[:space:]]|$)' \
	&& deny '这会删掉整个当前目录，包括你还没提交的代码（铁律 1）'

# 2. 强推主分支
match 'git[[:space:]]+push' \
	&& match '(--force([[:space:]]|$)|[[:space:]]-f([[:space:]]|$))' \
	&& match '(main|master)([[:space:]]|$)' \
	&& deny '强推主分支会永久覆盖远端历史，别人的提交会消失（红线 11）'

# 3. 删库
match 'drop[[:space:]]+database' \
	&& deny '这会删除整个数据库，且通常无法恢复（红线 6）'

# 4. 管道直接执行网络内容
match '(curl|wget)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(bash|sh|zsh)([[:space:]]|$)' \
	&& deny '这是把网上下载的内容直接执行，你没机会看清它要做什么（红线 10）'

# 5. 递归 777 与磁盘写入
match 'chmod[[:space:]]+(-[a-zA-Z]*R[a-zA-Z]*[[:space:]]+777|777[[:space:]]+-[a-zA-Z]*R)' \
	&& deny '递归 777 会把文件权限对所有人开放（红线 7）'
match '(mkfs(\.[a-z0-9]+)?[[:space:]]|dd[[:space:]]+[^|]*of=/dev/)' \
	&& deny '这是直接格式化或写裸设备，会造成不可恢复的数据丢失（铁律 1）'

# ── 弹确认（ask）：有正当理由，但要你点头 ──────────────

# 常见构建产物删掉即可重建，不打扰。其余递归删除仍要确认。
rm_targets_all_safe() {
	local t p any=0
	set -f
	t="$(printf '%s' "$CMD" \
		| grep -oE 'rm[[:space:]]+[^;|&]*' | head -n1 \
		| sed -E 's/^rm[[:space:]]+//; s/(^|[[:space:]])-[a-zA-Z]+([[:space:]]|$)/ /g')"
	for p in $t; do
		any=1
		case "$(basename "${p%/}")" in
			node_modules|dist|build|out|.next|.nuxt|.turbo|.cache|.parcel-cache) ;;
			coverage|__pycache__|.pytest_cache|target|venv|.venv|tmp) ;;
			*) set +f; return 1 ;;
		esac
	done
	set +f
	[ "$any" = "1" ]
}

match '(npm[[:space:]]+(i|install|add)|pnpm[[:space:]]+(i|install|add)|yarn[[:space:]]+add|bun[[:space:]]+(add|install)|pip3?[[:space:]]+install|poetry[[:space:]]+add|cargo[[:space:]]+add|go[[:space:]]+get|gem[[:space:]]+install|composer[[:space:]]+require)' \
	&& ask '要安装新依赖了。装之前请先确认包名全称、用途、周下载量和最近更新时间（红线 10）'

match 'git[[:space:]]+(reset[[:space:]]+--hard|clean[[:space:]]+-[a-z]*f)' \
	&& ask '这会丢弃你本地还没提交的改动，丢了找不回来（铁律 1）'

match '(drop[[:space:]]+table|truncate[[:space:]]+table|alter[[:space:]]+table)' \
	&& ask '这是在改数据库结构。请先出迁移文件再执行，不要直接改库（红线 6）'

match 'delete[[:space:]]+from' && ! match 'delete[[:space:]]+from[^;]*where' \
	&& ask '这条 DELETE 没有 WHERE 条件，会清空整张表（红线 6）'

match 'git[[:space:]]+push[^&|;]*(--force([[:space:]]|$)|[[:space:]]-f([[:space:]]|$))' \
	&& ask '强推会覆盖远端历史。确认这个分支只有你一个人在用（红线 11）'

# rm -rf：常见构建产物（按 basename 匹配）直接放行，混合/其他路径弹确认
if match 'rm[[:space:]]+(-[a-z]*[rf][a-z]*[[:space:]]+)'; then
	rm_targets_all_safe \
		|| ask '要递归删除文件了。确认路径没写错、且这些文件已经提交过（铁律 1）'
fi

match 'git[[:space:]]+add[^&|;]*(^|[[:space:]]|/)\.env([[:space:]]|$)' \
	&& ask '你正在把 .env 加进 Git。密钥一旦提交，删掉也留在历史里（红线 7）'

match '(vercel[^|;]*--prod|netlify[^|;]*deploy[^|;]*--prod|wrangler[[:space:]]+(publish|deploy)|fly[[:space:]]+deploy|kubectl[[:space:]]+apply|docker[[:space:]]+push)' \
	&& ask '这是往线上环境部署。确认已经在本地验证过（红线 11）'

exit 0
