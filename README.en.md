<p align="center">
  <img src="banner.png" alt="vibe-coding-guide — safety rails for AI coding" width="100%">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/%F0%9F%91%B6%20made%20for-beginners-ff69b4" alt="made for beginners">
  <img src="https://img.shields.io/badge/%F0%9F%A4%96%20works%20with-any%20AI-brightgreen" alt="works with any AI">
  <img src="https://img.shields.io/badge/%F0%9F%93%84%20license-Dual-orange" alt="dual license">
  <img src="https://img.shields.io/badge/docs-EN%20%2B%20%E4%B8%AD%E6%96%87-9cf" alt="EN plus Chinese">
  <img src="https://img.shields.io/badge/version-v2.1.0-blue" alt="version">
</p>

<p align="center"><a href="README.md">简体中文</a> | <b>English</b></p>

---

## What is this?

You let the AI write code for you. It's obedient, and fast.

Until one day it deletes a directory you haven't committed, or slips an API key
into Git, or tells you to run a command you don't understand. By the time you
notice, it's too late.

**This project does two things: it gives the AI eleven rules, and the moment it
is actually about to do something dangerous, it stops it.**

Not a reminder — it just won't execute. But you still can; you just have to do
it yourself.

> AI coding shouldn't be a gamble. Put the rails on first, and you can finally let it do real work for you.

---

## 🛑 What it blocks

When the AI tries to run `rm -rf /`, this is what it sees:

```
⛔ vibe-coding-guide 拦截：这是对根目录或家目录的递归删除，会清空整台机器（铁律 1）。确需执行请你自己在终端手动运行。关闭护栏：/plugin disable vibe-coding-guide
```

> The guard messages are in Chinese — they come verbatim from the hooks source.

These are also **blocked outright** (reasons verbatim from hooks/guard-bash.sh):

| The AI tries | What it sees |
|---|---|
| `rm -rf .` | 这会删掉整个当前目录，包括你还没提交的代码（铁律 1） |
| `git push -f main` | 强推主分支会永久覆盖远端历史，别人的提交会消失（红线 11） |
| `drop database` | 这会删除整个数据库，且通常无法恢复（红线 6） |
| `curl … \| bash` | 这是把网上下载的内容直接执行，你没机会看清它要做什么（红线 10） |

These are not blocked, but it will **stop and ask you once**:

| The AI tries | What it asks |
|---|---|
| `git add .env` | 你正在把 .env 加进 Git。密钥一旦提交，删掉也留在历史里（红线 7） |
| `npm install <package>` | 要安装新依赖了。装之前请先确认包名全称、用途、周下载量和最近更新时间（红线 10） |

---

## 🚀 Install it

Claude Code, two commands:

```
/plugin marketplace add Amer-CN/vibe-coding-guide
/plugin install vibe-coding-guide@vibe-coding-guide
```

Once installed, just talk normally in a new chat — no commands to remember.
Say "help me build an XX" or "is this code safe to ship?" and it follows the
rules automatically. You can also call it by name with `/vibe-coding-guide`.

---

## What can it do for you?

1. **Think first, then act** — before changing code, the AI must explain: what it's changing, why, and what it affects.
2. **Eleven red lines** — from how passwords are stored and money is calculated, to AI-feature injection defense, the dependency supply chain, and unattended agent operations. Each one has an expanded explanation and a way to check it.
3. **Actually blocks things** (Claude Code plugin install) — irreversible operations like deleting a root directory, force-pushing the main branch, or dropping a database simply won't run; installing dependencies, altering table structure, and deploying to production trigger a confirmation that names the red line involved. **Other install methods and other AIs get the rules only — no enforcement layer.**
4. **One-line check-up** — `bash scripts/audit.sh` runs the machine-checkable part of the 25-item delivery checklist, printing ✅／❌ with precise `file:line` references. It also lists what it can't check.
5. **Speak plainly** — the AI's explanations should be understandable to you, not a dump of code and errors.
6. **Templates to copy** — project source-of-truth doc, `.gitignore`, and delivery check-up report: three skeletons ready to take and adapt.

---

## 🗣️ When does it kick in automatically?

Once installed, you **don't have to call it by name** every time — whenever what you say hits one of the situations below, the AI will automatically follow these rules. Just say things like:

**🚀 Starting something from scratch**

- "I want to build an XX system / tool but have no idea where to start"
- "Help me plan and build an XX from zero with AI"
- "I want to make a website / mini-app / app / desktop tool / backend"

**🔧 Something broke**

- "Every fix breaks something else / it keeps getting messier"
- "It errors / shows a blank page / won't log in on another computer"
- "A screen full of red errors I can't read"
- "The AI said it's fixed, but it really isn't"
- "Two AIs say different things — which do I trust?"
- "The AI told me to run a command — is it safe to click?"

**🔒 Unsure about data & security**

- "I lost / deleted data and can't get it back"
- "How should I store passwords / ID numbers / bank cards?"
- "The amounts / accounting never add up"
- "Is this safe to ship? Could the database get leaked?"

**🚢 Getting ready to ship / deliver**

- "Do a full check-up on my old project"
- "Is it ready to go live?"
- "Help me deploy it and set up HTTPS"

> 💡 To trigger it most reliably, just add "use the vibe-coding-guide rules"; if installed as a plugin, you can also call `/vibe-coding-guide` by name.

---

## What's different after using it?

| Without this guide | With this guide |
|---|---|
| AI changes whatever it wants, often breaking a lot | Confirms each step, verifies after changes |
| When it breaks, you start over, unsure if it's recoverable | Changes can be rolled back — peace of mind |
| Risky, money-spending actions slip through | The red-line checklist reminds you; with the plugin installed, the most dangerous few simply won't run |
| Every commit feels like defusing a bomb | You can confidently let AI do real work |

---

## 🛡️ About the enforcement hooks

Once the plugin is installed, the hooks are active automatically:

- **Hard-blocked** are only the few operations with almost no legitimate use: deleting a root directory, force-pushing the main branch, dropping a database, piping downloaded content straight into a shell, recursive chmod 777, formatting a disk.
- **Ask for confirmation** covers installing dependencies, altering table structure, discarding local changes, deploying to production, writing something that looks like a secret — the prompt tells you which red line is involved.
- Deleting build artifacts like `node_modules`, `dist`, `build`, `.next` won't bother you;
  deleting any other path triggers one confirmation, because a mistyped path that deletes source code is the most common way things break.

**It is not bulletproof**: the hooks are shell scripts, so on machines without bash or without jq / python3 (e.g. some native Windows terminals) they silently skip — you might believe the guards are on when they are not. So remember: **the hooks are a second lock. The first lock is always you reading carefully before confirming.**

### After installing, take a minute to verify the guards are actually loaded

The fastest diagnosis: type `/hooks` in Claude Code and check whether vibe-coding-guide's two PreToolUse entries appear in the list. If they don't, the guards are not loaded.

The guards **silently pass through** when they fail — that's so you never get blocked by a broken hook, but it also means "no prompt" can mean either "nothing dangerous" or "the guards never loaded." Verify once after installing:

1. Ask the AI to run `rm -rf /` — you should see a rejection starting with ⛔ and naming the red line.
2. Ask the AI to run `npm install left-pad` — you should get a confirmation prompt mentioning "red line 10".
3. Ask the AI to run `rm -rf node_modules` — it should go through with no reaction at all.

If step 1 produces nothing, the guards aren't loaded. The most common cause is a system without `bash` (especially Windows). In that case the rule part of this plugin still works, but the enforcement layer is off — treat it as not being there.

---

## What it deliberately doesn't do

- **No prompt-injection checking.** Deciding whether "the thing the model just
  produced will be executed" is a semantic problem; pattern matching can't do
  it. Red lines 9 and 11 are rules written for humans to read, not items for
  automated scanning.
- **No code-quality judging.** It cares about "will this cause a disaster",
  not "is this elegant".
- **No guarantee of completeness.** The deny list is deliberately narrow —
  better to miss than to over-block. Being let through is not the same as being safe.

> There are already good AI-coding rulebook projects out there, each with its
> own focus: some teach test-driven development, others ship a full set of
> roles and slash commands. This project does exactly one thing — **holds the
> AI's hand before it touches something dangerous**. No commands to remember;
> once installed it just runs in the background.

---

## Other ways to install

<details>
<summary>Not using Claude Code, or don't want a plugin</summary>

**One-line script (Claude Code) — installs the rulebook only. Guards are not guaranteed to work this way; for guards, use the plugin install.**

```bash
curl -fsSL https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/install.sh | bash
```

> 🔐 This guide teaches you to "look before you click when someone tells you to run a command" — so it should follow its own advice. If you're not comfortable with `curl | bash`, first run `curl -fsSL https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/install.sh -o install.sh` to inspect the script, and only then run `bash install.sh`. The script does exactly one thing: clones this repo into `~/.claude/skills/`.

**Paste it to your agent (works with any AI) — installs the rulebook only. Guards are not guaranteed to work this way; for guards, use the plugin install.**

Copy the block below, paste it into your AI chat (Claude, Cursor, Gemini… all work), and send —

```text
Please read and strictly follow these AI coding safety rules:
https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/SKILL.md

From now on, follow these rules whenever you help me write code.
```

> 💡 If your AI can't open links, just open `SKILL.md` in this repo, copy the whole content, and paste it to your AI — same effect.

</details>

---

## Who is it for?

**A good fit 👇**

- People who can't code but want to build small tools, sites, or apps
- Product folks, operators, students, creators — anyone who wants AI leverage without crashing
- Anyone who wants to seriously ship their first AI project

**Not really for 👇**

- Senior engineers. These rules may feel a bit "naggy" to you.

---

## How to use it (real comparison)

**❌ Without it**

> You: Add a login feature.
> AI: Done, modified.
> You: …why did it crash?

**✅ With it**

> You: Using the vibe-coding-guide rules, add a login feature.
> AI: Got it. First, a few things to confirm:
> 1. Which framework are you using?
> 2. I suggest storing the password in an environment variable — OK?
> 3. This will change 3 files; I'll let you verify afterwards.
> You: Confirmed.
> AI: Done. Here's the change summary…

---

## Project structure

```
vibe-coding-guide/
├── AGENTS.md                   # Source-of-truth doc (this repo uses it too)
├── SKILL.md                    # Core rules — reading this is enough for the AI
├── references/                 # On-demand references for the AI; you don't need to touch these
│   ├── redlines.md             # The eleven safety red lines (expanded)
│   ├── legacy-audit.md         # Full check-up for existing projects
│   ├── new-project.md          # New-project workflow in three phases + deployment
│   ├── scenarios.md            # Guidance for five project types
│   ├── ai-disputes.md          # What to do when two AIs disagree
│   └── checklist.md            # 25-item delivery checklist
├── assets/                     # Ready-to-use templates — copy and adapt
│   ├── AGENTS.template.md      # Source-of-truth project doc template
│   ├── gitignore.template      # Excludes secrets and data files
│   └── delivery-report.template.md  # Delivery check-up report template
├── scripts/                    # Runnable check-up scripts
│   └── audit.sh                # Scans machine-checkable checklist items
├── hooks/                      # Enforcement hooks, active once the plugin is enabled
│   ├── hooks.json              # Hook configuration
│   ├── guard-bash.sh           # Dangerous command guard
│   └── guard-write.sh          # Dangerous write guard
├── install.sh                  # One-line install script (Claude Code)
├── .claude-plugin/             # Plugin marketplace config
├── CHANGELOG.md                # Version history
├── LICENSE.md                  # Dual license
├── README.md                   # Chinese (default)
└── README.en.md                # This file (English)
```

---

## Want to customize?

Edit `SKILL.md` and `references/redlines.md`, and add your own red lines, e.g.:

- Never touch my `main` branch
- Ask me before any action that costs money
- Always write a clear "what changed" after each change

> You can also start from the templates in `assets/` — source-of-truth doc, `.gitignore`, and delivery report skeletons are ready to copy.

---

## Don't want it anymore?

```
/plugin disable vibe-coding-guide
```

If you want the rules but not the enforced blocking: delete the `hooks/` directory and reinstall.

---

## Contributing

Got ideas? Issues and PRs welcome. Feel free to share your own "crash stories" so we can make the red-line checklist more complete together.

---

## License

This project uses a **Dual License** (see `LICENSE.md`):

- **Free use**: personal learning, open-source projects, free tutorial content.
- **Commercial use requires authorization**: closed-source products, paid courses/services, reselling, etc. — contact the author first.
