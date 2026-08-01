<p align="center">
  <img src="banner.png" alt="vibe-coding-guide — safety rails for AI coding" width="100%">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/%F0%9F%91%B6%20made%20for-beginners-ff69b4" alt="made for beginners">
  <img src="https://img.shields.io/badge/%F0%9F%A4%96%20works%20with-any%20AI-brightgreen" alt="works with any AI">
  <img src="https://img.shields.io/badge/%E2%9A%A1%20install-copy%20%26%20paste-1f6feb" alt="copy and paste install">
  <img src="https://img.shields.io/badge/%F0%9F%93%84%20license-Dual-orange" alt="dual license">
  <img src="https://img.shields.io/badge/docs-EN%20%2B%20%E4%B8%AD%E6%96%87-9cf" alt="EN plus Chinese">
</p>

<p align="center"><a href="README.md">简体中文</a> | <b>English</b></p>

---

## What is this?

In one sentence: **it's a "rulebook" for AI coding.** Hand it to your AI coding assistant (Claude Code, Cursor, Codex, etc.), and when it writes code for you it will think first, confirm with you, and automatically steer clear of risky operations.

You don't write a single line of code, and you don't change your editor. Once it's set up, the AI follows these rules while working with you.

---

## 🚀 How to start (pick one)

Pick whichever is easiest for you:

**① Plugin marketplace (recommended, Claude Code) — full: rules + guards**

```
/plugin marketplace add Amer-CN/vibe-coding-guide
/plugin install vibe-coding-guide@vibe-coding-guide
```

**② One-line script (Claude Code) — installs the rulebook only. Guards are not guaranteed to work this way; for guards, use ①.**

```bash
curl -fsSL https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/install.sh | bash
```

> 🔐 This guide teaches you to "look before you click when someone tells you to run a command" — so it should follow its own advice. If you're not comfortable with `curl | bash`, first run `curl -fsSL https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/install.sh -o install.sh` to inspect the script, and only then run `bash install.sh`. The script does exactly one thing: clones this repo into `~/.claude/skills/`.

**③ Paste it to your agent (works with any AI) — installs the rulebook only. Guards are not guaranteed to work this way; for guards, use ①.**

Copy the block below, paste it into your AI chat (Claude, Cursor, Gemini… all work), and send —

```text
Please read and strictly follow these AI coding safety rules:
https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/SKILL.md

From now on, follow these rules whenever you help me write code.
```

> 💡 If your AI can't open links, just open `SKILL.md` in this repo, copy the whole content, and paste it to your AI — same effect.

After installing with ① / ②, in a new chat say "I want to write code using the vibe-coding-guide rules, I want to build …", and Claude will follow the rules automatically. You can also invoke it directly with `/vibe-coding-guide`.

---

## 🗣️ When does it kick in automatically?

Once installed (via ① or ② above), you **don't have to call it by name** every time — whenever what you say hits one of the situations below, the AI will automatically follow these rules. Just say things like:

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

## Why do you need it?

If you build with AI, you've probably been through this "great → broken" loop:

- The AI just fixed A, and now B, C, and D are mysteriously broken.
- You can't really read the code, so you just nod at whatever the AI says — and when it breaks, you're stuck.
- API keys and passwords get written straight into the code, nearly pushed to a public GitHub repo.
- Project files pile up into a mess until neither you nor the AI can find anything.

This guide is your **safety rail + experienced co-pilot**: you hit the gas, it watches the brakes.

---

## What can it do for you?

1. **Think first, then act** — before changing code, the AI must explain: what it's changing, why, and what it affects.
2. **Auto-block the red lines** — deleting data, spending money, exposing passwords, changing production config… these dangerous operations require your confirmation first.
3. **Speak plainly** — the AI's explanations should be understandable to you, not a dump of code and errors.

---

## What's different after using it?

| Without this guide | With this guide |
|---|---|
| AI changes whatever it wants, often breaking a lot | Confirms each step, verifies after changes |
| When it breaks, you start over, unsure if it's recoverable | Changes can be rolled back — peace of mind |
| Risky, money-spending actions slip through | The red-line checklist blocks and warns |
| Every commit feels like defusing a bomb | You can confidently let AI do real work |

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

## 🛡️ About the enforcement hooks (new in v2.0)

Once the plugin is installed, the hooks are active automatically:

- **Hard-blocked** are only the few operations with almost no legitimate use: deleting a root directory, force-pushing the main branch, dropping a database, piping downloaded content straight into a shell, recursive chmod 777, formatting a disk.
- **Ask for confirmation** covers installing dependencies, altering table structure, discarding local changes, deploying to production, writing something that looks like a secret — the prompt tells you which red line is involved.
- Deleting build artifacts like `node_modules`, `dist`, `build`, `.next` won't bother you;
  deleting any other path triggers one confirmation, because a mistyped path that deletes source code is the most common way things break.

**It is not bulletproof**: the hooks are shell scripts, so on machines without bash or without jq / python3 (e.g. some native Windows terminals) they silently skip — you might believe the guards are on when they are not. So remember: **the hooks are a second lock. The first lock is always you reading carefully before confirming.**

To remove the hooks: `/plugin disable vibe-coding-guide`, or delete the `hooks/` directory and reinstall.

### After installing, take a minute to verify the guards are actually loaded

The fastest diagnosis: type `/hooks` in Claude Code and check whether vibe-coding-guide's two PreToolUse entries appear in the list. If they don't, the guards are not loaded.

The guards **silently pass through** when they fail — that's so you never get blocked by a broken hook, but it also means "no prompt" can mean either "nothing dangerous" or "the guards never loaded." Verify once after installing:

1. Ask the AI to run `rm -rf /` — you should see a rejection starting with ⛔ and naming the red line.
2. Ask the AI to run `npm install left-pad` — you should get a confirmation prompt mentioning "red line 10".
3. Ask the AI to run `rm -rf node_modules` — it should go through with no reaction at all.

If step 1 produces nothing, the guards aren't loaded. The most common cause is a system without `bash` (especially Windows). In that case the rule part of this plugin still works, but the enforcement layer is off — treat it as not being there.

---

## Want to customize?

Edit `SKILL.md` and `references/redlines.md`, and add your own red lines, e.g.:

- Never touch my `main` branch
- Ask me before any action that costs money
- Always write a clear "what changed" after each change

> You can also start from the templates in `assets/` — source-of-truth doc, `.gitignore`, and delivery report skeletons are ready to copy.

---

## Contributing

Got ideas? Issues and PRs welcome. Feel free to share your own "crash stories" so we can make the red-line checklist more complete together.

---

## License

This project uses a **Dual License** (see `LICENSE.md`):

- **Free use**: personal learning, open-source projects, free tutorial content.
- **Commercial use requires authorization**: closed-source products, paid courses/services, reselling, etc. — contact the author first.

> AI coding shouldn't be a gamble. Put the rails on first, and you can finally let it do real work for you.
