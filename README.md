<p align="center">
  <img src="banner.png" alt="vibe-coding-guide — 给 AI 编程装上安全护栏" width="100%">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/%F0%9F%91%B6%20made%20for-beginners-ff69b4" alt="made for beginners">
  <img src="https://img.shields.io/badge/%F0%9F%A4%96%20works%20with-any%20AI-brightgreen" alt="works with any AI">
  <img src="https://img.shields.io/badge/%E2%9A%A1%20install-copy%20%26%20paste-1f6feb" alt="copy and paste install">
  <img src="https://img.shields.io/badge/%F0%9F%93%84%20license-Dual-orange" alt="dual license">
  <img src="https://img.shields.io/badge/docs-EN%20%2B%20%E4%B8%AD%E6%96%87-9cf" alt="EN plus Chinese">
  <img src="https://img.shields.io/badge/version-v2.1.0-blue" alt="version">
</p>

<p align="center"><b>简体中文</b> | <a href="README.en.md">English</a></p>

---

## 这是什么？

一句话：**这是一份给 AI 编程用的“规矩本”，外加一层真的会拦下危险操作的护栏。**

把它交给你的 AI 编程助手（Claude Code、Cursor、Codex 等都行），AI 在帮你写代码时
就会先想清楚、先跟你确认，并自动避开那些会闯祸的操作。

如果你用的是 Claude Code 并按方式 ① 安装，它还会在 AI 真正执行危险命令之前
直接拦下来——不是提醒，是执行不了。

---

## 🚀 怎么开始用（三选一）

挑一个你顺手的就行：

**① 插件市场（推荐，Claude Code）——完整：规矩本 + 护栏**

```
/plugin marketplace add Amer-CN/vibe-coding-guide
/plugin install vibe-coding-guide@vibe-coding-guide
```

**② 一键脚本（Claude Code）——装规矩本。护栏不保证生效，需要护栏请用方式 ①。**

```bash
curl -fsSL https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/install.sh | bash
```

> 🔐 这份指南教你“别人让你跑的命令要看清再点”，那它自己也该守规矩：不放心 `curl | bash` 的话，先执行 `curl -fsSL https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/install.sh -o install.sh` 看一眼内容，确认后再 `bash install.sh`。脚本只做一件事——把本仓库 clone 到 `~/.claude/skills/`。

**③ 复制给 agent（任何 AI 都行）——装规矩本。护栏不保证生效，需要护栏请用方式 ①。**

复制下面这段，粘贴进你的 AI 对话框（Claude、Cursor、Gemini……都行），发送即可——

```text
请阅读并严格遵守这份《AI 编程安全规则》：
https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/SKILL.md

从现在起，帮我写代码时，请全程按上面这份规则来。
```

> 💡 如果你的 AI 不能联网打开链接，就直接打开仓库里的 `SKILL.md`，把内容整段复制、粘贴给它，效果一样。

用①②装好后，在新对话里说“我要用 vibe-coding-guide 规范写代码，我想做一个……”，Claude 会自动按规矩配合你，也可以用 `/vibe-coding-guide` 直接调用。

---

## 🗣️ 它什么时候会“自动出手”？

用上面 ①② 装好之后，你**不用每次点名调用**它——只要你说的话撞上下面这些场景，AI 就会自动按这套规矩来配合你。下面这些大白话，直接说就行：

**🚀 想从零做点东西**

- “想做个 XX 系统 / 小工具，不知道从哪开始”
- “帮我用 AI 从零规划并开发一个 XX”
- “我想做个网站 / 小程序 / App / 桌面工具 / 后台”

**🔧 代码出问题了**

- “代码一改就崩 / 越改越乱”
- “换了台电脑就报错 / 白屏 / 登录不了”
- “满屏红字报错看不懂”
- “AI 说改好了，其实根本没好”
- “这两个 AI 说得不一样，该信哪个？”
- “AI 让我跑一条命令，敢不敢点？”

**🔒 数据和安全没底**

- “数据丢了 / 误删了 / 找不回”
- “密码 / 身份证 / 银行卡这种敏感信息怎么存？”
- “金额、对账老是对不上”
- “这个能上线吗？会不会被拖库？”

**🚢 准备上线 / 交付**

- “老项目帮我大检查一遍”
- “能不能上线了？”
- “帮我部署上线，顺便配好 HTTPS”

> 💡 想更稳地触发，直接加一句“用 vibe-coding-guide 规范来”最保险；装成插件的话，也可以用 `/vibe-coding-guide` 直接点名。

---

## 为什么需要它？

用 AI 写代码的人，大概都经历过这种“爽 → 崩”的循环：

- AI 刚把 A 修好，B、C、D 三个地方又莫名其妙坏了。
- 你其实看不懂代码，AI 说啥你只能点头，真崩了只能干瞪眼。
- API 密钥、密码被 AI 顺手写进代码，差点直接推上 GitHub 公开。
- 项目文件越堆越乱，最后你和 AI 都找不着北。

这份指南就是你的**安全护栏 + 老司机副驾**：你踩油门，它帮你盯着刹车。

---

## 它能帮你做什么？

1. **先思考，再动手** — AI 改代码前，必须先讲清楚：改哪里、为什么改、会影响什么。
2. **十一条红线** — 从密码怎么存、金额怎么算，到 AI 功能防注入、依赖供应链、
   Agent 无人值守操作。每条都有展开说明和检查方法。
3. **真的会拦下来**（Claude Code 插件方式）— 删根目录、强推主分支、删库这类
   不可逆操作直接执行不了；装依赖、改表结构、部署上线会弹确认并告诉你违反了
   第几条红线。**其他安装方式和其他 AI 只有规矩，没有这层强制拦截。**
4. **一行命令做体检** — `bash scripts/audit.sh`，把 25 条交付清单里机器能查的
   部分跑一遍，输出 ✅／❌ 和精确到 `文件:行号`。它还会主动列出自己查不了的项。
5. **说人话，不打哑谜** — AI 的解释要让你能听懂，而不是甩一堆代码和报错了事。
6. **现成模板直接抄** — 项目真源文档、`.gitignore`、交付体检报告，三份骨架拿走就用。

---

## 用了之后，有什么不一样？

| 没用这份指南 | 用了这份指南 |
|---|---|
| AI 想改就改，经常一崩一大片 | 每步先确认，改完先验证 |
| 崩了只能从头再来，不知能否恢复 | 改坏能回退，心里有底 |
| 危险、花钱的操作容易被忽略 | 红线清单会提醒；装了插件的话，最危险的那几类直接执行不了 |
| 每次提交都像拆炸弹 | 你能放心让 AI 真正去干活 |

---

## 🛡️ 关于强制护栏

装上插件后，护栏会自动生效：

- **直接拦下**的只有极少数几乎不可能有正当理由的操作：删根目录、强推主分支、
  删库、把网上下载的内容直接执行、递归 777、格式化磁盘。
- **弹确认**的是装依赖、改表结构、丢弃本地改动、往线上部署、写入疑似密钥等，
  提示里会告诉你违反了哪条红线。
- 删除 `node_modules`、`dist`、`build`、`.next` 这类构建产物不会被打扰；
  删其他路径会弹一次确认，因为路径打错删掉源码是最常见的翻车方式。

**它不是万无一失的**：护栏靠 shell 脚本运行，在没有 bash 或缺少 jq / python3 的
环境（比如部分 Windows 原生终端）会静默跳过——也就是说你可能以为有护栏、实际没有。
所以请记住：**护栏是第二道锁，第一道永远是你自己看清楚再点确认。**

不想要护栏：`/plugin disable vibe-coding-guide`，或删掉 `hooks/` 目录后重装。

### 装完后，花一分钟确认它真的生效了

最快的确诊方式：在 Claude Code 里输入 `/hooks`，看列表里有没有 vibe-coding-guide 的两条 PreToolUse。没有，就是护栏没加载。

护栏在自身出故障时会**静默放行**——这是为了不卡住你，但也意味着
“没弹提示”可能是“没有危险”，也可能是“护栏根本没加载”。装完后请验一次：

1. 让 AI 执行 `rm -rf /` —— 应该看到以 ⛔ 开头、带红线编号的拒绝信息。
2. 让 AI 执行 `npm install left-pad` —— 应该弹出带「红线 10」的确认。
3. 让 AI 执行 `rm -rf node_modules` —— 应该毫无动静，直接放行。

第 1 步没有任何反应，说明护栏没有加载。常见原因是系统里没有 `bash`
（Windows 尤其常见）。这种情况下这个插件的规则部分仍然有效，
但强制拦截那一层是关掉的，请当作没有它来使用。

---

## 谁适合用？

**适合 👇**

- 不会写代码，但想做小工具、小网站、小程序的人
- 产品、运营、学生、自媒体——想用 AI 提效又怕翻车的人
- 想认真把第一个 AI 项目做出来的人

**不太适合 👇**

- 资深工程师。这套规矩对你来说可能有点“啰嗦”。

---

## 怎么用？（真实对比）

**❌ 没用的时候**

> 你：帮我加个登录功能。
> AI：好的，已修改。
> 你：……怎么崩了？

**✅ 用了之后**

> 你：我要用 vibe-coding-guide 规范写代码，帮我加个登录功能。
> AI：收到，先跟你确认几点：
> 1. 你用的是哪个框架？
> 2. 密码我建议存在环境变量里，可以吗？
> 3. 这次会改动 3 个文件，我改完先让你验证。
> 你：确认。
> AI：已修改，这是改动说明……

---

## 项目结构

```
vibe-coding-guide/
├── SKILL.md                    # 核心规矩，AI 读这份就够
├── references/                 # AI 按需查阅，你不用管
│   ├── redlines.md             # 十一条安全红线（展开版）
│   ├── legacy-audit.md         # 老项目大检查
│   ├── new-project.md          # 新项目三阶段 + 上线
│   ├── scenarios.md            # 五类项目适配
│   ├── ai-disputes.md          # 两个 AI 说法冲突怎么办
│   └── checklist.md            # 25 条交付检查清单
├── assets/                     # 现成模板，直接抄走改
│   ├── AGENTS.template.md      # 项目真源文档模板
│   ├── gitignore.template      # 密钥与数据文件排除
│   └── delivery-report.template.md  # 交付体检报告
├── scripts/                    # 能直接跑的体检脚本
│   └── audit.sh                # 自动扫描清单里可机检的部分
├── hooks/                      # 强制护栏（插件启用后自动生效）
│   ├── hooks.json              # 护栏配置
│   ├── guard-bash.sh           # 危险命令拦截
│   └── guard-write.sh          # 危险写入拦截
├── install.sh                  # 一键安装脚本（Claude Code）
├── .claude-plugin/             # 插件市场配置
├── CHANGELOG.md                # 版本变更记录
├── LICENSE.md                  # 双重许可协议
├── README.md                   # 本文件（中文）
└── README.en.md                # 英文版
```

---

## 想自定义？

直接改 `SKILL.md` 和 `references/redlines.md`，加上属于你的红线，比如：

- 不许动我的 `main` 分支
- 任何花钱超过 1 块钱的操作都要先问我
- 每次改完必须写清楚“改了什么”

> 也可以直接拿 `assets/` 里的模板改：真源文档、`.gitignore`、交付报告都有现成骨架。

---

## 贡献

有想法？欢迎提 Issue 或 PR。也欢迎分享你自己的“翻车经历”，我们一起把红线清单补得更全。

---

## 许可

本项目采用**双重许可**（详见 `LICENSE.md`）：

- **免费使用**：个人学习、开源项目、免费教程内容。
- **商用需授权**：闭源产品、付费课程/服务、转售倒卖等盈利用途，需先联系作者授权。

> AI 编程不该是一场赌博。先把护栏装上，你才敢放手让它真正帮你干活。

