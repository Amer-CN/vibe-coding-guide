<p align="center">
  <img src="assets/banner.jpg" alt="vibe-coding-guide — safety rails for AI coding" width="100%">
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

**① Plugin marketplace (recommended, Claude Code)**

```
/plugin marketplace add Amer-CN/vibe-coding-guide
/plugin install vibe-coding-guide@vibe-coding-guide
```

**② One-line script (Claude Code)**

```bash
curl -fsSL https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/install.sh | bash
```

**③ Paste it to your agent (works with any AI)**

Copy the block below, paste it into your AI chat (Claude, Cursor, Gemini… all work), and send —

```text
Please read and strictly follow these AI coding safety rules:
https://raw.githubusercontent.com/Amer-CN/vibe-coding-guide/main/SKILL.md

From now on, follow these rules whenever you help me write code.
```

> 💡 If your AI can't open links, just open `SKILL.md` in this repo, copy the whole content, and paste it to your AI — same effect.

After installing with ① / ②, in a new chat say "I want to write code using the vibe-coding-guide rules, I want to build …", and Claude will follow the rules automatically. You can also invoke it directly with `/vibe-coding-guide`.

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
├── SKILL.md              # Core rules — reading this is enough for the AI
├── references/
│   ├── handbook.md       # Full handbook (the AI reads it on demand; you don't need to)
│   └── checklist.md      # 19-item safety checklist
├── install.sh            # One-line install script (Claude Code)
├── .claude-plugin/       # Plugin marketplace config (one-line install for Claude Code)
├── LICENSE.md            # Dual license
├── README.md             # Chinese (default)
└── README.en.md          # This file (English)
```

---

## Want to customize?

Edit `SKILL.md` and `references/checklist.md`, and add your own red lines, e.g.:

- Never touch my `main` branch
- Ask me before any action that costs money
- Always write a clear "what changed" after each change

---

## Contributing

Got ideas? Issues and PRs welcome. Feel free to share your own "crash stories" so we can make the red-line checklist more complete together.

---

## License

This project uses a **Dual License** (see `LICENSE.md`):

- **Free use**: personal learning, open-source projects, free tutorial content.
- **Commercial use requires authorization**: closed-source products, paid courses/services, reselling, etc. — contact the author first.

> AI coding shouldn't be a gamble. Put the rails on first, and you can finally let it do real work for you.
