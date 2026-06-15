<p align="center">
  <img src="assets/banner.jpg" alt="vibe-coding-guide — 给 AI 编程装上安全护栏" width="100%">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/%F0%9F%91%B6%20made%20for-beginners-ff69b4" alt="made for beginners">
  <img src="https://img.shields.io/badge/%F0%9F%A4%96%20works%20with-any%20AI-brightgreen" alt="works with any AI">
  <img src="https://img.shields.io/badge/%E2%9A%A1%20install-copy%20%26%20paste-1f6feb" alt="copy and paste install">
  <img src="https://img.shields.io/badge/%F0%9F%93%84%20license-Dual-orange" alt="dual license">
  <img src="https://img.shields.io/badge/docs-EN%20%2B%20%E4%B8%AD%E6%96%87-9cf" alt="EN plus Chinese">
</p>

<p align="center"><b>简体中文</b> | <a href="README.en.md">English</a></p>

---

## 这是什么?

一句话:**这是一份给 AI 编程用的"规矩本"。** 把它交给你的 AI 编程助手(Claude Code、Cursor、Codex 等都行),AI 在帮你写代码时就会先想清楚、先跟你确认,并自动避开那些会闯祸的操作。

你不用写一行代码,也不用改你的编辑器。用上之后,AI 就会按这套规矩来配合你。

---

## 🚀 怎么开始用(三选一)

挑一个你顺手的就行:

**① 插件市场(推荐,Claude Code)**

```
/plugin marketplace add Amer-CN/vibe-coding-guide
/plugin install vibe-coding-guide@vibe-coding-guide
```

**② 一键脚本(Claude Code)**

```bash
curl -fsSL https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/install.sh | bash
```

**③ 复制给 agent(任何 AI 都行)**

复制下面这段,粘贴进你的 AI 对话框(Claude、Cursor、Gemini……都行),发送即可——

```text
请阅读并严格遵守这份《AI 编程安全规则》:
https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/SKILL.md

从现在起,帮我写代码时,请全程按上面这份规则来。
```

> 💡 如果你的 AI 不能联网打开链接,就直接打开仓库里的 `SKILL.md`,把内容整段复制、粘贴给它,效果一样。

用①②装好后,在新对话里说"我要用 vibe-coding-guide 规范写代码,我想做一个……",Claude 会自动按规矩配合你,也可以用 `/vibe-coding-guide` 直接调用。

---

## 为什么需要它?

用 AI 写代码的人,大概都经历过这种"爽 → 崩"的循环:

- AI 刚把 A 修好,B、C、D 三个地方又莫名其妙坏了。
- 你其实看不懂代码,AI 说啥你只能点头,真崩了只能干瞪眼。
- API 密钥、密码被 AI 顺手写进代码,差点直接推上 GitHub 公开。
- 项目文件越堆越乱,最后你和 AI 都找不着北。

这份指南就是你的**安全护栏 + 老司机副驾**:你踩油门,它帮你盯着刹车。

---

## 它能帮你做什么?

1. **先思考,再动手** — AI 改代码前,必须先讲清楚:改哪里、为什么改、会影响什么。
2. **红线自动拦截** — 删数据、花钱、暴露密码、改线上配置……这类危险操作,必须先经你确认。
3. **说人话,不打哑谜** — AI 的解释要让你能听懂,而不是甩一堆代码和报错了事。

---

## 用了之后,有什么不一样?

| 没用这份指南 | 用了这份指南 |
|---|---|
| AI 想改就改,经常一崩一大片 | 每步先确认,改完先验证 |
| 崩了只能从头再来,不知能否恢复 | 改坏能回退,心里有底 |
| 危险、花钱的操作容易被忽略 | 红线清单自动挡下并提醒 |
| 每次提交都像拆炸弹 | 你能放心让 AI 真正去干活 |

---

## 谁适合用?

**适合 👇**

- 不会写代码,但想做小工具、小网站、小程序的人
- 产品、运营、学生、自媒体——想用 AI 提效又怕翻车的人
- 想认真把第一个 AI 项目做出来的人

**不太适合 👇**

- 资深工程师。这套规矩对你来说可能有点"啰嗦"。

---

## 怎么用?(真实对比)

**❌ 没用的时候**

> 你:帮我加个登录功能。
> AI:好的,已修改。
> 你:……怎么崩了?

**✅ 用了之后**

> 你:我要用 vibe-coding-guide 规范写代码,帮我加个登录功能。
> AI:收到,先跟你确认几点:
> 1. 你用的是哪个框架?
> 2. 密码我建议存在环境变量里,可以吗?
> 3. 这次会改动 3 个文件,我改完先让你验证。
> 你:确认。
> AI:已修改,这是改动说明……

---

## 项目结构

```
vibe-coding-guide/
├── SKILL.md              # 核心规矩,AI 读这份就够
├── references/
│   ├── handbook.md       # 完整手册(AI 需要时自动查,你不用管)
│   └── checklist.md      # 19 条安全检查清单
├── install.sh            # 一键安装脚本(Claude Code)
├── .claude-plugin/       # 插件市场配置(Claude Code 一行安装)
├── LICENSE.md            # 双重许可协议
├── README.md             # 本文件(中文)
└── README.en.md          # 英文版
```

---

## 想自定义?

直接改 `SKILL.md` 和 `references/checklist.md`,加上属于你的红线,比如:

- 不许动我的 `main` 分支
- 任何花钱超过 1 块钱的操作都要先问我
- 每次改完必须写清楚"改了什么"

---

## 贡献

有想法?欢迎提 Issue 或 PR。也欢迎分享你自己的"翻车经历",我们一起把红线清单补得更全。

---

## 许可

本项目采用**双重许可**(详见 `LICENSE.md`):

- **免费使用**:个人学习、开源项目、免费教程内容。
- **商用需授权**:闭源产品、付费课程/服务、转售倒卖等盈利用途,需先联系作者授权。

> AI 编程不该是一场赌博。先把护栏装上,你才敢放手让它真正帮你干活。
